class AppointmentsController < ApplicationController

  before_filter :no_visitors
  before_filter :only_client, :only=>[:new,:create]

  before_filter :authorize, :only=>[:destroy]
  before_filter :slot_exists_and_free, :only=>[:new]
  before_filter :slot_exists_and_free_create, :only=>[:create]
  def index
    if session[:account_type]=="lawyer"
      @appointments = @user.appointments_with_clients.paginate(:page => params[:page], :per_page=> 15)
    else
      @appointments = @user.appointments_with_lawyers.paginate(:page => params[:page], :per_page=> 15)
    end
  end


  def new
    @slot = Slot.find(params[:slot])
    @lawyer = @slot.lawyer
    @user_categories =  @lawyer.lawyer_categories
    @appointment = Appointment.new
  end


  def create
    @slot = Slot.find(params[:appointment][:slot_id])
    @lawyer = @slot.lawyer
    @appointment = Appointment.new(params[:appointment])
    @appointment.lawyer_id = @slot.lawyer_id
    @appointment.user_id = session[:user_id]
    if @appointment.save
      redirect_to(appointments_url, :notice => 'Appointment was successfully created.')
    else
      @user_categories =  @lawyer.lawyer_categories
      render :action => "new"
    end
  end


  def destroy
    @appointment.destroy
    redirect_to(appointments_url)
  end

  private

  def authorize
    begin
      @appointment = Appointment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "This record does not exist."
      redirect_to(appointments_url)
    else
      if session[:account_type]=="user" and  @appointment.user_id != session[:user_id]
        flash[:error] = "You are not authorized for this action."
        redirect_to(appointments_url)

      elsif session[:account_type]=="lawyer" and  @appointment.lawyer_id != session[:user_id]
        flash[:error] = "You are not authorized for this action."
        redirect_to(appointments_url)
      end
    end
  end

  def slot_exists_and_free_create
    begin
      slot = Slot.find(params[:appointment][:slot_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to lawyers_path
      flash[:error]="This record doesnot exists or removed by Admin"
    else
      unless slot.status == 0
        redirect_to lawyer_path(slot.lawyer)
        flash[:error]="This slot is already booked."
      end
    end

  end

  def slot_exists_and_free
    begin
      slot = Slot.find(params[:slot])
    rescue ActiveRecord::RecordNotFound
      redirect_to lawyers_path
      flash[:error]="This record doesnot exists or removed by Admin"
    else
      unless slot.status == 0
        redirect_to lawyer_path(slot.lawyer)
        flash[:error]="This slot is already booked."
      end
    end
  end

end

