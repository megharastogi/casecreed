class Slot < ActiveRecord::Base
  has_one :appointment, :dependent => :destroy
  belongs_to :available_timing
  belongs_to :lawyer, :class_name => "User", :foreign_key => "lawyer_id"
  scope :active_slots ,where(["active = ? and status = ?" ,1, 0])

end

