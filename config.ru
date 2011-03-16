require 'rubygems'
require 'bundler'

Bundler.require(:default)

require 'app'

use SendgridEventProxy::Application
run Sinatra::Application