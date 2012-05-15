class VoteForNextCity < ActiveRecord::Base

  validates_presence_of :email, :first_name, :last_name,:comment,:city
  validates_format_of :email,
  :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
  :unless => lambda{ |a| a.email.blank? }

  after_create :send_mail_to_admin

  def send_mail_to_admin
    Notifier.vote_for_next_city(self).deliver
  end

end

