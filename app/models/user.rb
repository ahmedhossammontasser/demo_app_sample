# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#

class User < ActiveRecord::Base
	def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, :to => :ability
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email , :password, :password_confirmation, :remember_me
	# attr_accessible , :email, :password, :password_confirmation
	# has_secure_password
	has_many :microposts, dependent: :destroy 
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship",dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	before_save { |user| user.email = email.downcase }
	# before_save :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true , format: { with: VALID_EMAIL_REGEX } , uniqueness: { case_sensitive: false }
	# validates :password, presence: true, length: { minimum: 6 }
	# validates :password_confirmation, presence: true
	def feed
		Micropost.from_users_followed_by(self)
	end
	def following?(other_user)
		relationships.find_by_followed_id(other_user.id)
	end
	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end
	def unfollow!(other_user)
		relationships.find_by_followed_id(other_user.id).destroy
	end

	private
	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
	end
end
