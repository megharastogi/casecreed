class Sm < ActiveRecord::Base

  belongs_to :user
  validates_presence_of  :phone_number, :carrier
  validates_numericality_of :phone_number
  validates_length_of :phone_number, :is => 10
  before_create :generate_verification_code
  after_save :send_verification_code



  def generate_verification_code
    self.verification_code = random_string
  end


  def send_verification_code
    if self.verified==0
      sms_fu = SMSFu::Client.configure(:delivery => :action_mailer)
      message ="Hello " + self.user.full_name + ", please use "+ self.verification_code  +  " as verifcation code to get sms notifications."
      sms_fu.deliver(self.phone_number,self.carrier,message)
    else
      self.user.sms_number = self.phone_number
      self.user.sms_carrier =  self.carrier
      self.user.save(:validate=>false)
      self.destroy
    end
  end

  def random_string
    #generate a random vaerification code consisting of strings and digits
    chars = ("a".."z").to_a + ("0".."9").to_a
    newcode = ""
    1.upto(4) { |i| newcode << chars[rand(chars.size-1)] }
    return newcode
  end

end

