class CategoriesController < ApplicationController
  before_filter :admin_acces, :only=>[:create,:new]
  before_filter :authorize,:only=>[:update,:destroy,:edit]

  def index
    @title = 'All categories'
    @categories = Category.parent_categories
  end

  def new
    @title = 'New category'
    @category = Category.new
  end

  def edit
    @title = 'Edit category'
  end

  def create
    @category = Category.new(params[:category])
    @category.parent_category_id = params[:category][:parent_category_id]   #parent_category_id is the parent id. If this is blank then will set to zero to identity the parent category. Check model for details
    if @category.save
      redirect_to(categories_path, :notice => 'Category was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @category.parent_category_id = params[:category][:parent_category_id] if @category.parent_category_id!=0
    if @category.update_attributes(params[:category])
      redirect_to(categories_path, :notice => 'Category was successfully updated.')
    else
      render :action => "edit"
    end

  end

  def destroy
    @category.destroy
    flash[:notice]="Category was destroyed successfully."
    redirect_to(categories_path)
  end

  def get_sub_categories
    if params[:id]!=""
      @sub_categories = Category.where(["parent_category_id = ? or parent_category_id = ? and id!= ? ", params[:id], 0 ,params[:id] ])
    else
      @sub_categories = []
    end
  end

  private



  def authorize
    begin
      @category = Category.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to categories_path
      flash[:error]="This record doesnot exists or removed by Admin"
    else
      unless session[:account_type]=='admin'
        redirect_to categories_path
        flash[:error]="You are not authorized for this action."
      end
    end
  end
end

