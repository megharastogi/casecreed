class PagesController < ApplicationController
  def about_us


  end

  def privacy_policy
  end

  def terms_of_use
  end

  def select_user_type

  end

  def how_it_works
  end

  def presskit

  end

  def logo
    send_file "#{RAILS_ROOT}/public/images/logo.png", :type => 'image/jpeg'
  end

  def homepage
    send_file "#{RAILS_ROOT}/public/images/homepage.png", :type => 'image/jpeg'
  end

end

