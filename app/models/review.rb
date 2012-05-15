class Review < ActiveRecord::Base
  belongs_to :lawyer, :class_name => 'User', :foreign_key => 'lawyer_id'
  validates_presence_of :comment, :rating
  validates_numericality_of :rating,:greater_than_or_equal_to => 0,:less_than_or_equal_to=> 5, :unless => lambda{ |a| a.rating.blank? }


  after_save :update_lawyer_rating
  def update_lawyer_rating
    x = Review.where('lawyer_id = ? ', self.lawyer_id).average('rating')
    self.lawyer.lawyer_detail.skip_callback=1
    if self.lawyer.lawyer_detail.nil?
      self.lawyer.build_lawyer_detail
      self.lawyer.save(:validate=>false)
    end
    if x.nil?
      self.lawyer.lawyer_detail.update_attribute('rating', 0)
    else
      self.lawyer.lawyer_detail.update_attribute('rating', x)
    end
  end
end

