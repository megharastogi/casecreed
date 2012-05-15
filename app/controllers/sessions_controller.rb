class SessionsController < ApplicationController
  skip_before_filter :visitor_only, :only=>[:new,:create]
  before_filter :no_admin_acess, :only=>[:home]
  before_filter :no_logged_in, :only=>[:new,:create]
  #before_filter :no_visitors,:only=>[:destroy]
  #ssl_required :new, :create

  skip_before_filter :client_must_verify_phone_number
  def new
    # render login page. ie new session
    @title = "Login"
    @user = User.new
  end

  def destroy
    if cookies[:key]
      User.update(session[:user_id],:remember_me=>'')
    end
    reset_session
    redirect_to login_path
  end

  def create
    # validating login credentials and after that creating new session
    if @user=User.authenticate(params[:user][:email], params[:user][:password])
      if params[:remember]=='1'
        random_value=User.random_string
        cookies[:key] = { :value => random_value, :expires => 1.year.from_now }
        @user.remember_me=random_value
        @user.save
      end
      set_user_login_attributes
      if  session[:account_type]=="admin"
        redirect_to pending_request_search_accounts_path
      else
        redirect_to home_path
      end
    else
      invalid_login
    end
  end


  def home


  end

  private

  def invalid_login
    flash[:error] = "Invalid email or password"
    @user= User.new
    redirect_to login_path
  end


end

