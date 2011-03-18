#!/usr/bin/env ruby


require 'rubygems'
require 'bundler'

Bundler.setup

require 'active_support/core_ext'
require 'active_record'
require 'delayed_job'
require 'daemons'


RACK_ROOT = File.expand_path('.')

Delayed::Worker.backend = :active_record

module Delayed
  
  module Backend
    module ActiveRecord
      class Job
        
        def self.after_fork
          dbconfig = YAML.load_file(File.join(File.dirname(__FILE__),'config','database.yml'))
          ::ActiveRecord::Base.establish_connection(dbconfig[ENV["RACK_ENV"] || "development"])
        end
      end
    end
  end
  
  class Command
    attr_accessor :worker_count
    
    def initialize(args)
      @files_to_reopen = []
      @options = {
        :quiet => true,
        :pid_dir => "#{RACK_ROOT}/tmp/pids"
      }
      
      @worker_count = 1
      @monitor = false
      
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] start|stop|restart|run"

        opts.on('-h', '--help', 'Show this message') do
          puts opts
          exit 1
        end
        opts.on('--min-priority N', 'Minimum priority of jobs to run.') do |n|
          @options[:min_priority] = n
        end
        opts.on('--max-priority N', 'Maximum priority of jobs to run.') do |n|
          @options[:max_priority] = n
        end
        opts.on('-n', '--number_of_workers=workers', "Number of unique workers to spawn") do |worker_count|
          @worker_count = worker_count.to_i rescue 1
        end
        opts.on('--pid-dir=DIR', 'Specifies an alternate directory in which to store the process ids.') do |dir|
          @options[:pid_dir] = dir
        end
        opts.on('-i', '--identifier=n', 'A numeric identifier for the worker.') do |n|
          @options[:identifier] = n
        end
        opts.on('-m', '--monitor', 'Start monitor process.') do
          @monitor = true
        end
        opts.on('--sleep-delay N', "Amount of time to sleep when no jobs are found") do |n|
          @options[:sleep_delay] = n
        end
        opts.on('-p', '--prefix NAME', "String to be prefixed to worker process names") do |prefix|
          @options[:prefix] = prefix
        end
      end
      @args = opts.parse!(args)
    end
  
    def daemonize
      Delayed::Worker.backend.before_fork

      ObjectSpace.each_object(File) do |file|
        @files_to_reopen << file unless file.closed?
      end
      
      dir = @options[:pid_dir]
      FileUtils.mkdir_p(dir) unless File.exists?(dir)
      
      if @worker_count > 1 && @options[:identifier]
        raise ArgumentError, 'Cannot specify both --number-of-workers and --identifier'
      elsif @worker_count == 1 && @options[:identifier]
        process_name = "delayed_job.#{@options[:identifier]}"
        run_process(process_name, dir)
      else
        worker_count.times do |worker_index|
          process_name = worker_count == 1 ? "delayed_job" : "delayed_job.#{worker_index}"
          run_process(process_name, dir)
        end
      end
    end
    
    def run_process(process_name, dir)
      Daemons.run_proc(process_name, :dir => dir, :dir_mode => :normal, :monitor => @monitor, :ARGV => @args) do |*args|
        $0 = File.join(@options[:prefix], process_name) if @options[:prefix]
        run process_name
      end
    end
    
    def run(worker_name = nil)
      Dir.chdir(RACK_ROOT)
      
      # Re-open file handles
      @files_to_reopen.each do |file|
        begin
          file.reopen file.path, "a+"
          file.sync = true
        rescue ::Exception
        end
      end

      Dir.mkdir("#{File.join(RACK_ROOT, 'log')}") unless File.exists?("#{File.join(RACK_ROOT, 'log')}")
      Delayed::Worker.logger = Logger.new(File.join(RACK_ROOT, 'log', 'delayed_job.log'))
      Delayed::Worker.backend.after_fork
      
      worker = Delayed::Worker.new(@options)
      worker.name_prefix = "#{worker_name} "
      worker.start
    rescue => e
      STDERR.puts e.backtrace
      STDERR.puts e.message
      exit 1
    end
    
  end
end

Delayed::Command.new(ARGV).daemonize