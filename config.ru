require 'bundler_helper'
require 'sinatra'
require 'db/setup'
require 'app'

use SendgridEventProxy::Application
run Sinatra::Application