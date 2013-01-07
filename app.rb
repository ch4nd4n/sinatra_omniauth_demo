require 'sinatra'
require 'omniauth'
require 'haml'
require 'sqlite3'
require 'sinatra/activerecord'
require './models/identity'

class SinatraApp < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::ActiveRecordExtension
  set :database, 'sqlite:///db/foo.db'
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :identity, on_failed_registration: lambda { |env|
      p "Registration data issue"
      status, headers, body = call env.merge("PATH_INFO" => '/register')
    }
  OmniAuth.config.on_failure = Proc.new { |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  }
  end

  get "/" do
    p session.inspect
    haml :index
  end

  get '/register' do
    haml :register
  end

  post "/register" do
    @identity = env['omniauth.identity']
    haml :register
  end

  get "/login" do
    haml :login
  end

  post '/auth/:name/callback' do
    auth = request.env['omniauth.auth']
    session[:user_id] = auth.uid
    redirect to "/"
  end

  get '/auth/failure' do
    @error = "Invalid Credentials. Try again"
    haml :login
  end

  get "/logout" do
    session[:user_id] = nil
    p session[:user_id].inspect
    redirect to "/"
  end

  helpers do
    def logged_in?
      !session[:user_id].nil?
    end
  end

end