module MessagesHelper
  def first_name
    @user.first_name unless @user.nil?
  end  
  def last_name
    @user.last_name unless @user.nil?
  end
  def email
    @user.email unless @user.nil?
  end
end
