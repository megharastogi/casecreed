class Claim < ActiveRecord::Base
  validates_presence_of :message,:email, :phone
  validates_format_of :email,
  :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
  :unless => lambda{ |a| a.email.blank? }
  belongs_to :user
  after_destroy :send_claim_reject_mail


  private

  def send_claim_reject_mail
    Notifier.send_claim_reject_mail(self).deliver 
  end
end
