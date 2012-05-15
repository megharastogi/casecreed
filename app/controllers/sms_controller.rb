class SmsController < ApplicationController

  before_filter :no_visitors
  before_filter :authorize, :only=>[:verify_phone,:send_verification_code_again]
  skip_before_filter :client_must_verify_phone_number
  def edit
    @sm = Sm.find(params[:id])
  end

  # POST /sms
  # POST /sms.xml
  def create
    @sm = Sm.new(params[:sm])
    @sm.user_id = @user.id
    @sm.carrier = params[:mobile_carrier]  unless params[:mobile_carrier]=="Select a Carrier"
    if @sm.valid?
      @sm.save
      flash[:notice]="Verification code has been sent to your phone."
      redirect_to settings_users_path(@user)
    else
      flash[:error]="Not a valid phone number."
      redirect_to settings_users_path(@user)
    end
  end

  # PUT /sms/1
  # PUT /sms/1.xml
  def update
    @sm = Sm.find(params[:id])

    respond_to do |format|
      if @sm.update_attributes(params[:sm])
        format.html { redirect_to(@sm, :notice => 'Sm was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sm.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @sm = Sm.find(params[:id])
    @sm.destroy

    respond_to do |format|
      format.html { redirect_to(sms_url) }
      format.xml  { head :ok }
    end
  end

  def verify_phone
    if @sm.verification_code == params[:sm][:verification_code]
      @sm.verified = 1
      @sm.save
      flash[:notice]="Thank you for verifying your phone number."
      redirect_to settings_users_path(@user)
    else
      flash[:error]="There is some issues with the verification code"
      redirect_to settings_users_path(@user)
    end
  end

  def send_verification_code_again
    @sm.send_verification_code
    flash[:notice]="Verification code sent."
    redirect_to settings_users_path(@user)
  end

  private

  def authorize
    begin
      @sm = Sm.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "This record does not exist."
      redirect_to settings_users_path(@user)
    end
    unless @sm.verified == 0 and @sm.user_id == @user.id
      flash[:error] = "You are not auhtorized for this action."
      redirect_to settings_users_path(@user)
    end
  end
end

