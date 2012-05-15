class UsersController < ApplicationController

  before_filter :restricted_area, :only=>[:pending_request,:authenticate_requests]
  before_filter :no_visitors, :only => [:update_password, :settings,:no_sms_updates]
  before_filter :only_client, :only =>[:edit, :update]
  before_filter :authorize, :only=>[:show]
  before_filter :no_logged_in, :only=> [:new,:create]
  skip_before_filter :client_must_verify_phone_number, :only=>[:settings]

  def index
    @users = User.all
  end

  def show

  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    @user.build_client_detail if @user.client_detail.nil?
  end

  def create
    @user = User.new(params[:user])
    @user.phone_carrier = params[:mobile_carrier]
    @user.account_type="user"
    if @user.save

    else
      render :action => "new"
    end
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def account_activate
    reset_session
    user=User.where(["activation_code = ? ", params[:act] ]).first
    unless user.nil?
      user.activation_code=nil
      user.active=1
      user.save(false)
      @activated=1
      Notifier.welcome_mail(user).deliver
    else
      @activated=0
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(users_url)
  end

  def pending_request
    @users = User.unapproved_advacate_sign_up(params[:page])
  end

  def authenticate_requests
    if params[:commit]=='Approve'
      User.where(["id in (?)",params[:select]]).collect {
        |x|
        x.approved=1
        x.save(false)
        x.send_activation_mail
      }
      flash[:notice]="The selected invitation(s) has been approved."
    else
      User.where(["id in (?)",params[:select]]).collect {|x| x.destroy}
      flash[:notice]="The selected invitation(s) has been declined."
    end
    redirect_to  pending_request_users_path
  end

  def lawyers
    @lawyers = Appointment.select('distinct(lawyer_id)').where(['user_id = ? ', session[:user_id]])
  end

  def settings
    if @user.sm.nil?
      @sm = Sm.new
    else
      @sm = @user.sm

    end
  end

  def update_password
    @user = User.find(session[:user_id])
    @user.old_password=params[:user][:old_password]
    if  @user.old_password_match and @user.update_attributes(params[:user])
      flash[:notice] = 'Password updated successfully.'
      redirect_to settings_users_path
    else
      render :action => "settings"
    end
  end

  def no_sms_updates
    @user.sms_number = nil
    @user.sms_carrier = nil
    @user.save(:validate=>false)
    flash[:notice]="You will not recieve sms notifications. You an enable it anytime"
    redirect_to settings_users_path(@user)
  end

  private
  def authorize
    begin
      @client = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "This record does not exist."
      redirect_to(home_url)
    end

    unless @client.active == 1 and @client.account_type =='user'
      flash[:error] = "This record does not exist."
      redirect_to(home_url)
    end
  end

end

