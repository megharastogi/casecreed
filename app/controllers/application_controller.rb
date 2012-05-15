class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :login_check
  before_filter :client_must_verify_phone_number
  before_filter :mailer_set_url_options
  before_filter :search_box_attributes
  helper :all
  layout :set_layout
  #sms_fu = SMSFu::Client.configure(:delivery => :action_mailer)
  private

  def client_must_verify_phone_number
    if session[:account_type]=="user" and @user.sms_number.nil?
      flash[:notice]="Please verify your phone number to proceed."
      redirect_to settings_users_path
      return
    end
  end

  def visitor_only
    if session[:user_id]
      flash[:error]="You are not authorized for this action."
      redirect_to home_path
      return
    end
  end

  def only_lawyers
    unless session[:account_type]=="lawyer"
      flash[:error]="You are not authorized for this action."
      redirect_to home_path
      return
    end
  end

  def admin_acces
    unless session[:account_type]=='admin'
      redirect_to home_path
    end
  end

  def only_client
    unless session[:account_type]=="user"
      flash[:error]="You are not authorized for this action."
      redirect_to home_path
      return
    end
  end

  def no_visitors
    unless session[:user_id]
      flash[:error]="Please login."
      redirect_to login_path
      return
    end
  end

  def no_logged_in
    if session[:user_id]
      redirect_to root_path
      return
    end
  end

  def restricted_area
    unless session[:account_type] =='admin'
      flash[:error]="You are not authorized for this action."
      redirect_to home_path
    end
  end

  def no_admin_acess
    if session[:account_type] =='admin'
      flash[:error]="You are not authorized for this action."
      redirect_to pending_request_search_accounts_path
    end
  end

  def set_layout
    if session[:account_type] =='admin'
      'admin'
    else
      'application'
    end
  end

  def random_string
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(5) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def login_check
    if session[:user_id]   # incase of site navigation
      @user=User.find(:first, :conditions =>["id = ?", session[:user_id]])
      set_user_login_attributes
    elsif  cookies[:key] and @user=User.find(:first, :conditions =>["remember_me = ?", cookies[:key]]) #case for remember me
      set_user_login_attributes
    end
  end

  def search_box_attributes
    @categories = Category.all
  end

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def set_user_login_attributes
    session[:user_id] = @user.id
    session[:account_type] = @user.account_type
  end

end

