require 'sinatra'
require 'omniauth'
require 'haml'
require 'sqlite3'
require 'sinatra/activerecord'
Dir["./models/*.rb", "./initializers/*.rb", "./lib/*.rb", "./app/*.rb", "./app/helpers/*.rb"].each {|file| require file }
class AdminApp < Sinatra::Base
  configure :production, :development do
    set :logging, Logger::DEBUG
  end
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::ActiveRecordExtension
  set :database, 'sqlite:///db/foo.db'
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :identity, on_failed_registration: lambda { |env|
      status, headers, body = call env.merge("PATH_INFO" => '/register')
    }
    OmniAuth.config.on_failure = Proc.new { |env|
      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
  end
end