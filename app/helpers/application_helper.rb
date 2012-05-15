module ApplicationHelper

  def show_search_box
    if (params[:controller]=="lawyers" and params[:action]=="index") or(params[:controller]=="lawyers" and params[:action]=="search") or (params[:controller]=="sessions" and params[:action]=="home")
      true
    else
      false
    end
  end

  def is_admin
    unless session[:account_type]=='normal'
      true
    else
      false
    end
  end

  def logged_in
    if session[:account_type].nil?
      false
    else
      true
    end
  end

  def half_round(i)
    x = (i*2).ceil / 2.0
    (x.to_s + "_stars").gsub('.', '')

  end


  def pagination_index(page, index)
    if page =='1' or page.blank?
      index +  1
    else
      (page.to_i - 1 ) * 30 + index +1
    end
  end

end

