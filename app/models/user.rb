class User < ApplicationRecord

  before_create :set_role_user, :set_username

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :rates, dependent: :destroy

  has_one_attached :avatar, dependent: :destroy

  acts_as_voter

  ROLES = {
    :admin => 1,
    :user => 0
  }

  def is_admin?
    self.role == User::ROLES[:admin]
  end

  def get_rate_with post
    self.rates.find_by(post_id: post.id)
  end

  def is_author_of? post
    self.id == post.user.id
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(
          username: data['name'],
          email: data['email'],
          password: Devise.friendly_token[0,20]
        )
    end
    user.confirmed_at = DateTime.now
    user
  end

  private 
  def set_role_user 
    self.role = ROLES[:user]
  end
  
  def set_username
    if User.find_by(username: self.username).present?
      self.username = self.email.split("@")[0]
    end
  end

end
