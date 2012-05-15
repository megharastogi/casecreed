class VoteForNextCitiesController < ApplicationController
  before_filter :admin_acces, :except=>[:create,:new]
  # GET /vote_for_next_cities
  # GET /vote_for_next_cities.xml
  def index
    @vote_for_next_cities = VoteForNextCity.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vote_for_next_cities }
    end
  end

  # GET /vote_for_next_cities/1
  # GET /vote_for_next_cities/1.xml
  def show
    @vote_for_next_city = VoteForNextCity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vote_for_next_city }
    end
  end

  # GET /vote_for_next_cities/new
  # GET /vote_for_next_cities/new.xml
  def new
    @vote_for_next_city = VoteForNextCity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vote_for_next_city }
    end
  end

  # GET /vote_for_next_cities/1/edit
  def edit
    @vote_for_next_city = VoteForNextCity.find(params[:id])
  end

  # POST /vote_for_next_cities
  # POST /vote_for_next_cities.xml
  def create
    @vote_for_next_city = VoteForNextCity.new(params[:vote_for_next_city])

    respond_to do |format|
      if @vote_for_next_city.save
        format.html { redirect_to(new_vote_for_next_city_path, :notice => 'Thank you.') }
        format.xml  { render :xml => @vote_for_next_city, :status => :created, :location => @vote_for_next_city }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vote_for_next_city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vote_for_next_cities/1
  # PUT /vote_for_next_cities/1.xml
  def update
    @vote_for_next_city = VoteForNextCity.find(params[:id])

    respond_to do |format|
      if @vote_for_next_city.update_attributes(params[:vote_for_next_city])
        format.html { redirect_to(@vote_for_next_city, :notice => 'Vote for next city was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vote_for_next_city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vote_for_next_cities/1
  # DELETE /vote_for_next_cities/1.xml
  def destroy
    @vote_for_next_city = VoteForNextCity.find(params[:id])
    @vote_for_next_city.destroy

    respond_to do |format|
      format.html { redirect_to(vote_for_next_cities_url) }
      format.xml  { head :ok }
    end
  end
end

