class Notifier < ActionMailer::Base
  default :from => "notifications@casecreed.com"

  def account_activation_mail(recipient)
    @recipient = recipient
    mail(:to => @recipient.email, :subject => "Just one more step to get started on Casecreed")
  end

  def welcome_mail(recipient)
    @recipient = recipient
    mail(:to => @recipient.email, :subject => "Welcome to Casecreed")
  end

  def password_recovery(recipient)
    @recipient = recipient
    mail(:to => recipient.email, :subject => "Casecreed Password Assistance")
  end

  def send_claim_reject_mail(recipient)
    @recipient = recipient
    mail(:to => recipient.email, :subject => "Request for account claim has been rejected")
  end

  def send_claim_account_activation_mail(recipient,password)
    @recipient = recipient
    @password = password
    mail(:to => recipient.email, :subject => "Request for account claim has been accepted")
  end

  def send_rejection_mail(recipient)
    @recipient = recipient
    mail(:to => recipient.email, :subject => "Request for account activation has been rejected")
  end

  def appointment_book(appointment,recipient,appointment_with)
    event = RiCal.Event do
      description "MA-6 First US Manned Spaceflight"
      dtstart     DateTime.parse(appointment.slot.date_on.strftime("%m/%d/%Y").to_s + " " + appointment.slot.start_time.strftime("%I.%M %p").to_s)
      dtend       DateTime.parse(appointment.slot.date_on.strftime("%m/%d/%Y").to_s + " " + appointment.slot.end_time.strftime("%I.%M %p").to_s)
      add_attendee appointment_with.full_name
      alarm do
        description "Segment 51"
      end
    end
    attachments['event.ics'] = { 
       :mime_type => 'text/calendar', 
       :content => event.export 
     }
    @recipient = recipient
    @appointment = appointment
    mail(:to => recipient.email, :subject => "Appointment book")
  end

  def appointment_cancel(appointment,recipient)
    @recipient = recipient
    @appointment = appointment
    mail(:to => recipient.email, :subject => "Appointment cancelled")
  end

  def account_create_request_mail(recipient)
    @recipient = recipient
    mail(:to => recipient.email, :subject => "Request for account activation has been sent to admin.")
  end

  def contact_us_mail_to_admin(contact_us)
    @contact_us = contact_us
    mail(:to => 'hajj23@gmail.com', :subject => "Message for Casecreed.")
  end

  def vote_for_next_city(vote_for_next_city)
    @vote_for_next_city = vote_for_next_city
    mail(:to => 'hajj23@gmail.com', :subject => "Vote for next city")
  end
end

