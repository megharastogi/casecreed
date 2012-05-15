class CasecreedblogController < ApplicationController
  before_filter :redirect_to_blog
  def index
  end

  def show

  end

  def redirect_to_blog

    redirect_to "http://blog.casecreed.com" and return
  end
end

