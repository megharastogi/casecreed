class ForgotPasswordController < ApplicationController

  skip_before_filter :login_check
  before_filter :not_login
  skip_before_filter :client_must_verify_phone_number

  def new
    @title = "Forgot password"
    @user = User.new
  end

  def create
    @title = "Reset password"
    @user = User.where(["email = ?", params[:user][:email]]).first
    if @user.nil? or params[:user][:email]==""
      @user = User.new
      flash.now[:error] = "Invalid email"
      render :action=> 'new'
    else
      random_string=Digest::MD5.hexdigest(Time.now.to_f.to_s)
      #@user.update_attribute(:forgot_password_code, random_string)
      @user.forgot_password_code= random_string
      #User.after_save.clear
      @user.save(:validate => false)
      @user.send_password_recovery_mail
    end
  end

  def change_password
    @title = "Reset password"
    @user=User.where(['forgot_password_code = ?', params[:forgot_password_code]]).first
    if @user.blank?
      flash[:error] = "Seems like you have an expired or a wrong link. Please try generating a new link."
      redirect_to :action => :new
    end
  end

  def update_password
    @title = "Password updated"
    @user = User.where(['forgot_password_code = ?', params[:user][:forgot_password_code]]).first
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.forgot_password_code = params[:user][:password_confirmation]
    @user.profile = "1"
    if @user.save
      @message = "Your password has been changed."
    else
      @user.forgot_password_code = params[:user][:forgot_password_code]
      render :action => 'change_password'
    end
  end

  private

  def not_login
    unless session[:user_id].nil?
      redirect_to cards_path
    end
  end

end

