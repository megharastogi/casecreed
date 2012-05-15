class ImagesController < ApplicationController

  before_filter :only_lawyers
  before_filter :authorize, :only=>[:edit, :update, :destroy]
  def index
    @images = @user.images
  end


  def new
    @image = Image.new
  end

  def edit
  end

  def create
    @image = Image.new(params[:image])
    @image.lawyer_id= session[:user_id]
    if @image.save
      redirect_to(images_path, :notice => 'Image was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @image.update_attributes(params[:image])
      redirect_to(images_path, :notice => 'Image was successfully created.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @image.destroy
    redirect_to(images_url)
  end

  private


  def authorize
    begin
      @image = Image.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(images_url)
      flash[:error]="This record doesnot exist."
    else
      unless @image.lawyer_id == session[:user_id]
        redirect_to(images_url)
        flash[:error]="You are not authorized for this action."
      end
    end
  end
end

