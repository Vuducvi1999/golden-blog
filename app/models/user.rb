

class User < ApplicationRecord
  before_create :set_username

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  has_many :posts, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, dependent: :destroy 
  has_many :rates, dependent: :destroy
  has_many :sent_notifications, :class_name => 'Notification', :foreign_key => 'sender_id', dependent: :destroy
  has_many :received_notifications, :class_name => 'Notification', :foreign_key => 'recipient_id', dependent: :destroy

  has_one_attached :avatar, dependent: :destroy

  enum role: {
    :user => 0,
    :admin => 1
  }

  def get_likeable likeable
    self.likes.find_by(likeable_id: likeable.id, likeable_type: likeable.class.name)
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
    return user if user

    # Uncomment the section below if you want users to be created if they don't exist 
    unless user
      user = User.create(
        username: data['name'],
        email: data['email'],
        password: Devise.friendly_token[0,20]
      )
      user.confirmed_at = DateTime.now
    end
    user.access_token = access_token.credentials.token
    user 
  end

  def get_avatar 
    avatar.present? ? self.avatar : ActionController::Base.helpers.asset_path('avatar-default.png')
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(access_token)
  end

  private
  def set_username
    if User.find_by(username: self.username).present?
      self.username = self.email.split("@")[0]
    end
  end

end
