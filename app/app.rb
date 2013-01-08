# Application routes listed here
# Author:: Chandan Kumar (http://chandankumar.com)
class AdminApp < Sinatra::Base
  get "/" do
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
    session.clear
    redirect to "/"
  end
end
