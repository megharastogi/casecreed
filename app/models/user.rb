class User < ActiveRecord::Base
  has_attached_file :avatar,   :styles => {:thumb=> "190x170#", :medium  => "250x250>",:large=>"400x400>" }, :default_url => '/images/anonymous_icon.png'
  has_many :claims
  has_many :reviews, :foreign_key => 'lawyer_id'
  has_one :lawyer_detail
  has_one :client_detail
  has_one :sm
  has_many :lawyer_categories, :foreign_key => 'lawyer_id'
  has_many :categories, :through => :lawyer_categories
  has_many :slots, :foreign_key => "lawyer_id"
  has_many :images, :foreign_key=>'lawyer_id'
  has_many :available_timings, :foreign_key=>'lawyer_id'
  has_many :appointments_with_lawyers, :class_name => 'Appointment', :foreign_key => 'user_id'  #for client
  has_many :appointments_with_clients, :class_name => 'Appointment', :foreign_key => 'lawyer_id'  #for ADVOCATES
  attr_accessor :old_password
  accepts_nested_attributes_for :lawyer_detail, :allow_destroy => true
  accepts_nested_attributes_for :client_detail, :allow_destroy => true
  attr_accessor :password, :terms,:remember_me, :profile, :phone_number, :phone_carrier
  attr_accessor :password_confirmation
  validates_confirmation_of :password , :unless => lambda{ |a| a.profile=='1' }
  validates_length_of :password, :within => 6..20, :unless => lambda{ |a| a.password.blank? }
  validates_uniqueness_of :email, :unless => lambda{ |a| a.email.blank? or !a.new_record?}
  validates_presence_of :email, :first_name, :last_name,:account_type
  validates_presence_of :phone_number,:phone_carrier,  :unless => lambda{ |a| a.profile=='1' }
  validates_presence_of :password,  :unless => lambda{ |a| a.profile=='1' }
  validates_numericality_of :phone_number, :unless => lambda{ |a| a.phone_number.blank? }
  validates_length_of :phone_number, :is => 10, :unless => lambda{ |a| a.phone_number.blank? }
  validates_format_of :email,
  :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
  :unless => lambda{ |a| a.email.blank? }
  validates_acceptance_of :terms, :message => "must be accepted"
  validate :select_carrier, :unless => lambda{ |a| a.phone_number.blank? }
  validates_length_of :password, :within => 6..20, :unless => lambda{ |a| a.password.blank? }
  after_create :send_activation_mail , :unless => lambda{ |a| a.account_type == 'admin' }
  after_create :send_mobile_activation_code, :unless => lambda{ |a| a.phone_number.nil? or a.phone_carrier.nil? or a.phone_carrier =="Select a Carrier" }
  before_create :generate_activation_code
  before_destroy :send_rejection_mail
  cattr_reader :per_page
  @@per_page = 12
  def select_carrier
    if self.phone_carrier.nil? or self.phone_carrier == "Select a Carrier"
      errors.add(:base,"Please select phone carrier")
    end
  end

  def send_mobile_activation_code
    @sm = Sm.new
    @sm.user_id = self.id
    @sm.carrier = self.phone_carrier
    @sm.phone_number = self.phone_number
    @sm.save
  end

  def self.active_lawyers(page_number)
    where(['account_type = ? and active = ?', "lawyer", 1]).paginate(:page => page_number,:order => 'created_at DESC')
  end

  def self.all_lawyers(page_number)
    where(['account_type = ? ', "lawyer"]).paginate(:page => page_number,:order => 'created_at DESC')
  end

  def self.inactive_lawyers(page_number)
    where(['account_type = ? and active = ?', "lawyer", 0]).paginate(:page => page_number,:per_page=>30, :order => 'created_at DESC')
  end

  def old_password_match
    expected_password = User.encrypted_password(old_password, self.salt)
    if self.hashed_password != expected_password
      errors.add(:base,"Old Password is invalid.")
      return false
    else
      return true
    end
  end

  def self.inactive_lawyers_search(search_string,page_number)
    names=search_string.split(' ')
    lawyers = []
    names.each do |n|
      lawyers << self.where('first_name LIKE ? OR last_name LIKE ? and active = ? and activation_code = ?', "#{n}", "#{n}",0,nil)
    end
    lawyers.flatten!.compact
    lawyers.uniq!
    lawyers.paginate(:page => page_number,:per_page=> 10)
  end

  def self.unapproved_advacate_sign_up(page_number)
    where(['account_type = ? and approved = ?', "lawyer", 0]).paginate(:page => page_number,:order => 'created_at DESC')
  end


  def self.all_lawyers_search(page_number,category,keyword)
    if !category.blank? and !keyword.blank?
      keywords=keyword.split(' ')
      lawyers = []
      keywords.each do |n|
        lawyers << Category.find(category).users.where(['(account_type = ?) and (zipcode = ? or first_name = ? or last_name = ? )', "lawyer", n,n,n]).uniq
      end
      lawyers.flatten!.compact
      lawyers.uniq!
      lawyers.paginate(:page => page_number,:order => 'created_at DESC')
    elsif category.blank? and !keyword.blank?
      keywords=keyword.split(' ')
      lawyers = []
      keywords.each do |n|
        lawyers << where(['(account_type = ? ) and (zipcode = ? or first_name = ? or last_name = ?)', "lawyer", n,n,n]).uniq
      end
      lawyers.flatten!.compact
      lawyers.uniq!
      lawyers.paginate(:page => page_number,:order => 'created_at DESC')
    elsif !category.blank? and keyword.blank?
      Category.find(category).users.where(['account_type = ? ', "lawyer"]).uniq.paginate(:page => page_number,:order => 'created_at DESC')

    else

      where(['account_type = ?  ', "lawyer"]).uniq.paginate(:page => page_number,:order => 'created_at DESC')
    end
  end

  def full_name
    [first_name,last_name].join(' ')
  end

  def self.authenticate(email, password)
    user = self.find(:first, :conditions =>['email = ? and active = ?', email, 1])
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end


  def generate_activation_code
    self.activation_code = Digest::MD5.hexdigest(rand.to_s +  rand.to_s)
    if self.account_type == "user"
      self.approved = 1
    else
      self.approved = 0
    end
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def send_activation_mail
    if account_type=="lawyer" and approved==0
      Notifier.account_create_request_mail(self).deliver
    else
      Notifier.account_activation_mail(self).deliver
    end
  end

  def send_claim_account_activation_mail(password)
    Notifier.send_claim_account_activation_mail(self,password).deliver
  end

  def send_rejection_mail
    Notifier.send_rejection_mail(self).deliver

  end

  def send_password_recovery_mail
    Notifier.password_recovery(self).deliver
  end

  def password
    @password
  end

  def create_new_salt
    self.salt = Digest::MD5.hexdigest(rand.to_s)
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def self.random_string
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(10) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end


end

