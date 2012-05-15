class AvailableTiming < ActiveRecord::Base
  belongs_to :user, :foreign_key=>"lawyer_id"
  has_many :slots, :dependent => :destroy
  attr_accessor :option ,:date_from,:date_to,:days
  validates_presence_of :time_from,:time_to,:option
  validates_presence_of :date_to, :if => lambda{ |a| a.option!='1' and !option.nil?}
  validates_presence_of :date_on, :unless => lambda{ |a| option.nil?}
  validate :validate_time_to_and_time_from
  validate :weekdays_select, :if => lambda{ |a| a.option=='3' }
  validate :no_past_date
  after_create :create_slots
  validate :timings_for_a_day_is_unique, :unless => lambda{ |a| option.nil?}



  def timings_for_a_day_is_unique
    if option=='1'
      all_specfied_timings_for_this_day= AvailableTiming.where(['date_on = ? and lawyer_id = ?', date_on, lawyer_id])
      all_specfied_timings_for_this_day.each do |specified_timing|
        if specified_timing.time_from < time_from and specified_timing.time_to > time_from
          errors.add(:base,"Timings already specified")
        elsif specified_timing.time_from < time_to and specified_timing.time_to > time_to
          errors.add(:base,"Timings already specified")
        elsif specified_timing.time_from >= time_from and specified_timing.time_to <= time_to
          errors.add(:base,"Timings already specified")
        end
      end
    end

    if option=="2"
      temp_date_from = date_from.to_datetime()
      temp_date_to = date_to.to_datetime()
      while temp_date_from <= temp_date_to
        all_specfied_timings_for_this_day= AvailableTiming.where(['date_on = ? and lawyer_id = ?', date_on, lawyer_id])
        all_specfied_timings_for_this_day.each do |specified_timing|
          if specified_timing.time_from < time_from and specified_timing.time_to > time_from
            errors.add(:base,"Timings already specified for " + temp_date_from.strftime("%m/%d/%Y"))
          elsif specified_timing.time_from < time_to and specified_timing.time_to > time_to
            errors.add(:base,"Timings already specified for " + temp_date_from.strftime("%m/%d/%Y"))
          elsif specified_timing.time_from >= time_from and specified_timing.time_to <= time_to
            errors.add(:base,"Timings already specified for " + temp_date_from.strftime("%m/%d/%Y"))
          end
        end
        temp_date_from =temp_date_from.advance(:days => 1)
      end
    end


    if option=="3" and  !days.nil?
      temp_date_from = date_from.to_datetime()
      temp_date_to = date_to.to_datetime()
      while temp_date_from <= temp_date_to
        if days.include?(temp_date_from.strftime("%w"))
          all_specfied_timings_for_this_day= AvailableTiming.where(['date_on = ? and lawyer_id = ?', temp_date_from, lawyer_id ])
          all_specfied_timings_for_this_day.each do |specified_timing|
            if specified_timing.time_from < time_from and specified_timing.time_to > time_from
              errors.add(:base,"Timings already specified for " + temp_date_from.strftime("%m/%d/%Y"))
            elsif specified_timing.time_from < time_to and specified_timing.time_to > time_to
              errors.add(:base,"Timings already specified for " + temp_date_from.strftime("%m/%d/%Y"))
            elsif specified_timing.time_from >= time_from and specified_timing.time_to <= time_to
              errors.add(:base,"Timings already specified for " + temp_date_from.strftime("%m/%d/%Y"))
            end
          end
        end
        temp_date_from =temp_date_from.advance(:days => 1)
      end
    end

  end

  def validate_time_to_and_time_from
    if time_from > time_to or time_from == time_to
      errors.add(:base,"Timings are invalid")
    end
  end


  def no_past_date
    if !date_from.blank? and date_from.to_datetime() < Date.today
      errors.add(:date_from, " is invalid")
    end

    if !date_to.blank? and date_to.to_datetime() < Date.today and option!=1 and !option.nil?
      errors.add(:date_to, " is invalid")
    end
  end

  def weekdays_select
    if days.nil? or days.length == 0
      errors.add(:days, " is invalid")
    end
  end

  def create_slots
    temp_time_from = self.time_from
    temp_time_to = self.time_to
    while temp_time_from.advance(:minutes => 30) <= self.time_to
      slot = Slot.new
      slot.date_on = self.date_on
      slot.lawyer_id = self.lawyer_id
      slot.available_timing_id=self.id
      slot.start_time = temp_time_from
      slot.end_time =temp_time_from.advance(:minutes => 30)
      slot.save
      temp_time_to= temp_time_to.advance(:minutes => 30)
      temp_time_from = temp_time_from.advance(:minutes => 30)
    end


    if option == "2"
      temp_date_from = date_from.to_datetime()
      temp_date_from=temp_date_from.advance(:days => 1)
      temp_date_to = date_to.to_datetime()
      while temp_date_from <= temp_date_to
        available_timing = AvailableTiming.new
        available_timing.lawyer_id = self.lawyer_id
        available_timing.time_from = self.time_from
        available_timing.time_to = self.time_to
        available_timing.option = "1"
        available_timing.date_on =temp_date_from
        available_timing.save
        temp_date_from =temp_date_from.advance(:days => 1)
      end
    end

  end



end

