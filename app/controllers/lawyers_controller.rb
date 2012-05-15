class LawyersController < ApplicationController

  before_filter :only_lawyers, :only=>[:edit, :update_profile]
  before_filter :authorize, :only=>[:show,:images]
  before_filter :no_logged_in, :only=> [:new,:create]
  def index
    @lawyers = User.all_lawyers(params[:page])
  end

  def search
    @lawyers = User.all_lawyers_search(params[:page],params[:category],params[:keyword])
    render :action=>"index"
  end

  def show
    @reviews= @lawyer.reviews
    @user_categories =  @lawyer.lawyer_categories
    @date= Date.today
  end

  def new
    @user = User.new
  end


  def create
    @user = User.new(params[:user])
    @user.account_type="lawyer"
    @user.phone_carrier = params[:mobile_carrier]
    if @user.save

    else
      render :action => "new"
    end
  end

  def edit
    @user = User.find(session[:user_id])
    @user.build_lawyer_detail if @user.lawyer_detail.nil?
  end

  def update_profile
    @user = User.find(session[:user_id])
    if @user.update_attributes(params[:user])
      redirect_to(lawyer_path(@user), :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def images
    @images = @lawyer.images
    @user_categories =  @lawyer.lawyer_categories
  end

  def clients
    @clients = Appointment.select('distinct(user_id)').where(['lawyer_id = ? ', session[:user_id]])
  end

  def get_timings_one_lawyer
    @lawyer = User.find(params[:lawyer_id])
    @date= Date.strptime(params[:date], "%Y - %m - %d")
  end

  private
  def authorize
    begin
      @lawyer = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "This record does not exist."
      redirect_to(home_url)
    end

    unless @lawyer.account_type == 'lawyer'
      flash[:error] = "This record does not exist."
      redirect_to(home_url)
    end
  end

end

