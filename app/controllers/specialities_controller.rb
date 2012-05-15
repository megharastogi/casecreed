class SpecialitiesController < ApplicationController
  before_filter :only_lawyers
  before_filter :authorize, :only=>[:destroy]

  def new
    @user = User.find(session[:user_id])
    @user_categories =  @user.lawyer_categories
    @lawyer_category = LawyerCategory.new
    @sub_categories=[]
  end

  def destroy
    @lawyer_category.destroy
    redirect_to(new_lawyer_speciality_path(@user), :notice => 'Speciality has been destroyed.')
  end

  def create
    @lawyer_category = LawyerCategory.new(params[:lawyer_category])
    @lawyer_category.lawyer_id = @user.id
    if @lawyer_category.save
      redirect_to(new_lawyer_speciality_path(@user), :notice => 'Speciality has been added.')
    else
      @user_categories =  @user.lawyer_categories
      @sub_categories = Category.where(["parent_category_id = ? or parent_category_id = ? and id!= ? ",  params[:lawyer_category][:parent_category ], 0 , params[:lawyer_category][:parent_category ] ])
      render :action => "new"
    end
  end


  private


  def authorize
    begin
      @lawyer_category = LawyerCategory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(new_lawyer_speciality_path(@user))
      flash[:error]="This record doesnot exist."
    else
      unless @lawyer_category.lawyer_id == session[:user_id]
        redirect_to(new_lawyer_speciality_path(@user))
        flash[:error]="You are not authorized for this action."
      end
    end
  end
end

