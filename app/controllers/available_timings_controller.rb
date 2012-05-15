class AvailableTimingsController < ApplicationController

  before_filter :only_lawyers
  before_filter :authorize, :only=>[:show,:destroy]

  def index
    @available_timings = @user.available_timings.where('date_on >= ? ', Date.today - 7 ).paginate(:page => params[:page],:order => 'date_on DESC', :per_page=> 15)
  end

  def show
  end

  def new
    @available_timing = AvailableTiming.new
  end

  def create
    @available_timing = AvailableTiming.new(params[:available_timing])
    @available_timing.lawyer_id=session[:user_id]
    @available_timing.date_on=params[:available_timing][:date_from]
    if @available_timing.valid?
      if params[:available_timing][:option]=="3"
        temp_date_from =@available_timing.date_from.to_datetime()
        temp_date_to = @available_timing.date_to.to_datetime()
        while temp_date_from <= temp_date_to
          if @available_timing.days.include?(temp_date_from.strftime("%w"))
            available_timing = AvailableTiming.new
            available_timing.lawyer_id = session[:user_id]
            available_timing.time_from = @available_timing.time_from
            available_timing.time_to = @available_timing.time_to
            available_timing.option = "1"
            available_timing.date_on =temp_date_from
            available_timing.save
          end
          temp_date_from =temp_date_from.advance(:days => 1)
        end
      else
        @available_timing.save
      end
      redirect_to(@available_timing, :notice => 'Available timing was successfully created.')
    else
      render :action => "new"
    end
  end


  def destroy
    @available_timing.destroy
    flash[:notice] = "Available timing destroyed successfully."
    redirect_to(available_timings_url)
  end

  private


  def authorize
    begin
      @available_timing = AvailableTiming.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "This record does not exist."
      redirect_to(available_timings_url)
    else
      unless  @available_timing.lawyer_id == session[:user_id]
        flash[:error] = "You are not authorized for this action."
        redirect_to(available_timings_url)
      end
    end
  end
end

