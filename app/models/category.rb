class Category < ActiveRecord::Base

  has_many :sub_categories, :class_name => "Category",
  :foreign_key => "parent_category_id", :dependent => :destroy
  belongs_to :parent_category, :class_name => "Category",:foreign_key => "parent_category_id"
  has_many :lawyer_categories
  has_many :users, :through => :lawyer_categories
  validates_presence_of :name
  validates_uniqueness_of :name
  validate :presence_of_primary_category
  before_save :set_category_id

  def set_category_id
    if self.parent_category_id.nil?
      self.parent_category_id=0
    end
  end

  def self.parent_categories
    Category.where(["parent_category_id = ? ", 0 ])
  end

  def presence_of_primary_category
    if  self.parent_category_id!=0 and !self.parent_category_id.nil? and !Category.find(parent_category_id)
      errors.add_to_base("Category you choosing doesnot exists")
    end
  end

  def self.find_parent_category(name)
    category_chosen=Category.where(["name = ? ", name ]).first
    if category_chosen.parent_category_id!=0  #for subcategory
      category_chosen.parent_category.name
    else #for main category
      category_chosen.name
    end
  end

end

