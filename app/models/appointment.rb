class Appointment < ActiveRecord::Base
  belongs_to :slot
  belongs_to :lawyer, :class_name=>'User', :foreign_key => 'lawyer_id'
  belongs_to :client, :class_name=> 'User', :foreign_key => 'user_id'
  validates_presence_of :description
  after_create :change_status_of_slot_and_appointment_book_mail
  validate :slot_free
  before_destroy :change_status_of_slot_and_appointment_cancel_mail

  def change_status_of_slot_and_appointment_book_mail
    sms_fu = SMSFu::Client.configure(:delivery => :action_mailer)

    unless self.lawyer.sms_number.nil?
      message ="Hello " + self.lawyer.full_name + " appointment dated " +  self.slot.date_on.strftime("%m/%d/%Y").to_s  + " at " + self.slot.start_time.strftime("%I.%M %p").to_s + " to " + self.slot.end_time.strftime("%I.%M %p").to_s + " has been booked."
      sms_fu.deliver(self.lawyer.sms_number,self.lawyer.sms_carrier,message)
    end

    unless self.client.sms_number.nil?
      message ="Hello " + self.client.full_name + " appointment dated " +  self.slot.date_on.strftime("%m/%d/%Y").to_s + " at "  + self.slot.start_time.strftime("%I.%M %p").to_s + " to " + self.slot.end_time.strftime("%I.%M %p").to_s + " has been booked."
      sms_fu.deliver(self.client.sms_number,self.client.sms_carrier,message)
    end


    self.slot.update_attribute('status', 1)
    Notifier.appointment_book(self, self.lawyer,self.client).deliver
    Notifier.appointment_book(self, self.client,self.lawyer).deliver
  end

  def slot_free
    slot=Slot.find_by_id(self.slot_id)
    if slot
      if slot.status == 1
        errors.add(:base,"Slot is not free.")
      end
    else
      errors.add(:base,"Slot invalid.")
    end
  end

  def change_status_of_slot_and_appointment_cancel_mail
    sms_fu = SMSFu::Client.configure(:delivery => :action_mailer)

    unless self.lawyer.sms_number.nil?
      message ="Hello " + self.lawyer.full_name + " appointment dated " +  self.slot.date_on.strftime("%m/%d/%Y").to_s  + " at " + self.slot.start_time.strftime("%I.%M %p").to_s + " to " + self.slot.end_time.strftime("%I.%M %p").to_s + " has been cancelled."
      sms_fu.deliver(self.lawyer.sms_number,self.lawyer.sms_carrier,message)
    end

    unless self.client.sms_number.nil?
      message ="Hello " + self.client.full_name + " appointment dated " +  self.slot.date_on.strftime("%m/%d/%Y").to_s + " at "  + self.slot.start_time.strftime("%I.%M %p").to_s + " to " + self.slot.end_time.strftime("%I.%M %p").to_s + " has been cancelled."
      sms_fu.deliver(self.client.sms_number,self.client.sms_carrier,message)
    end
    self.slot.update_attribute('status', 0)
    Notifier.appointment_cancel(self, self.lawyer).deliver
    Notifier.appointment_cancel(self, self.client).deliver
  end

end

