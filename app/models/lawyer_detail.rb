class LawyerDetail < ActiveRecord::Base

  belongs_to :user
  validates_numericality_of :firm_size,:greater_than => 0, :only_integer =>true, :unless => lambda{ |a| a.firm_size.blank? }
  after_save :update_latitude_and_longitude, :unless => lambda{ |a| a.skip_callback==1 }
  attr_accessor :skip_callback


  def update_latitude_and_longitude
    a= Geocoder.fetch_coordinates(self.address + " , " + user.city.to_s +  " , " + user.state.to_s)
    unless a.nil?
      self.latitude=a[0]
      self.longitude=a[1]
      self.skip_callback=1
      self.save(false)
    else
      self.latitude=nil
      self.longitude=nil
      self.skip_callback=1
      self.save(false)
    end
  end


end

