require 'bundler_helper'
require 'sinatra'
require 'db/setup'
require 'app/app'

use SendgridEventProxy::Application
run Sinatra::Application