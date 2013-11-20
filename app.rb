require 'sinatra'
require 'omniauth'
require 'haml'
require 'sqlite3'

# Use Sinatra Active Record to connect to DB https://github.com/janko-m/sinatra-activerecord
require 'sinatra/activerecord'

# load list of ruby files by recursing through folders
Dir["./models/*.rb", "./initializers/*.rb", "./lib/*.rb", "./app/*.rb", "./app/helpers/*.rb"].each {|file| require file }

# App configurations below
# Author:: Chandan Kumar (http://chandankumar.com)
class AdminApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure :production, :development do
    set :logging, Logger::DEBUG
  end

  enable :sessions
  set :session_secret, 'super secret'
  set :database, 'sqlite:///db/foo.db'
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :identity, fields: [:email, :name], model: User, on_failed_registration: lambda { |env|
      status, headers, body = call env.merge("PATH_INFO" => '/register')
    }
    OmniAuth.config.on_failure = Proc.new { |env|
      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
  end

end
