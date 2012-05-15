class SlotsController < ApplicationController

  before_filter :only_lawyers
  before_filter :authorize
  def disable
    slot = Slot.find(params[:id])
    if slot.status == 1
      slot.status=0
      slot.appointment.destroy
    end
    slot.active = 0
    slot.save
    flash[:notice]="Slot has been disabled"
    redirect_to available_timing_path(slot.available_timing)
  end


  def enable
    slot = Slot.find(params[:id])
    slot.active = 1
    slot.save
    flash[:notice]="Slot has been enabled"
    redirect_to available_timing_path(slot.available_timing)
  end

  private


  def authorize
    begin
      slot = Slot.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to available_timings_path
      flash[:error]="This record doesnot exists or removed by Admin"
    else
      unless slot.lawyer_id == session[:user_id]
        redirect_to available_timings_path
        flash[:error]="You are not authorized for this action."
      end
    end
  end

end

