# Application routes listed here
# Author:: Chandan Kumar (http://chandankumar.com)
class AdminApp < Sinatra::Base
  set(:auth) do |*roles|
    condition do
      unless signed_in? && roles.any? {|role| current_user.role.to_sym == role }
        redirect "/login", 303
      end
    end
  end

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
    @authentication = Authentication.find_with_omniauth(auth)
    if @authentication.nil?
      @authentication = Authentication.create_with_omniauth(auth)
    end
    if signed_in?
      if @authentication.user == current_user
        redirect to "/", notice: "You have already linked this account"
      else
        @authentication.user = current_user
        @authentication.save
        redirect to "/", notice: "Account successfully authenticated"
      end
    else # no user is signed_in
      if @authentication.user.present?
        self.current_user = @authentication.user
        redirect to "/", notice: "Signed in!"
      else
        if @authentication.provider == 'identity'
          u = User.find(@authentication.uid)
        else
          u = User.create_with_omniauth(auth)
        end
        u.authentications << @authentication
        self.current_user = u
        redirect to "/"
      end
    end
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

  get "/user/account", :auth => [:user, :admin] do
    "Your dashboard"
  end

  get "/manage/user", :auth => [:admin] do
    "Your dashboard"
  end
end
