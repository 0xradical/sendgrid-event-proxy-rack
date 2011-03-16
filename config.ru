require 'bundler_helper'
require 'sinatra'
require 'app'

use SendgridEventProxy::Application
run Sinatra::Application