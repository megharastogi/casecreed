class ReviewsController < ApplicationController
  before_filter :no_visitors
  before_filter :only_client, :only=>[:new,:create]
  before_filter :valid_lawyer, :only=>[:new, :create]
  before_filter :authorize, :only => [:destroy]
  def new
    @review = Review.new
    @user_categories =  @lawyer.lawyer_categories
  end

  def create
    @review = Review.new(params[:review])
    @review.user_id = session[:user_id]
    @review.lawyer_id = @lawyer.id
    if @review.save
      redirect_to(lawyer_path(@lawyer), :notice => 'Review was successfully created.')
    else
      @user_categories =  @lawyer.lawyer_categories
      render :action => "new"
    end
  end


  def destroy
    @review = Review.find(params[:id])
    lawyer= @review.lawyer_id
    @review.destroy
    flash[:notice]="Review deleted succesfully."
    redirect_to(lawyer_path(lawyer))
  end

  private

  def valid_lawyer
    begin
      @lawyer = User.find(params[:lawyer])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "This record does not exist."
      redirect_to(home_url)
    else
      if @lawyer.active != 1
        flash[:error] = "This record does not exist."
        redirect_to(home_url) and return
      end
    end
  end


  def authorize
    begin
      @review = Review.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(lawyer_path(session[:user_id]))
      flash[:error]="This record doesnot exist."
    else
      unless @review.lawyer_id == session[:user_id]
        redirect_to(lawyer_path(session[:user_id]))
        flash[:error]="You are not authorized for this action."
      end
    end
  end

end

