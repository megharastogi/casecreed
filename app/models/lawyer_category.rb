class LawyerCategory < ActiveRecord::Base

  belongs_to :user, :foreign_key=>"lawyer_id"
  belongs_to :category
  attr_accessor :parent_category
  validates_presence_of :parent_category, :percentage
  validate :only_parent_category, :unless => lambda{ |a| a.parent_category.blank? }
  validates_numericality_of :percentage,:greater_than => 0,:less_than_or_equal_to=> 100, :only_integer =>true, :unless => lambda{ |a| a.percentage.blank? }
  before_save :adjust_category_id_and_category_type

  def only_parent_category
    subcategory = Category.where(["parent_category_id = ? ", parent_category ]).count
    if subcategory != 0 and self.category_id.nil?
      errors.add(:category_id, " can't be blank.")
    end
  end

  def adjust_category_id_and_category_type
    subcategory = Category.where(["parent_category_id = ? ", parent_category ]).count
    if subcategory == 0
      self.category_id = parent_category
      self.category_type = "parent"
    else
      self.category_type = "child"
    end
  end
end

