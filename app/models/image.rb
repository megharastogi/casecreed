class Image < ActiveRecord::Base
  belongs_to :user, :foreign_key=>"lawyer_id"
  validates_presence_of :title
  has_attached_file :avatar,   :styles => {:thumb=>"150x150>",:large=>"400x400>" }
  validates_attachment_presence :avatar
  validates_attachment_content_type :avatar,  :content_type => ['image/jpeg', 'image/png','image/jpg', 'image/gif']
end

