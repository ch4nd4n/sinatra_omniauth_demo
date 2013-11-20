require 'omniauth/identity'
class User < OmniAuth::Identity::Models::ActiveRecord
  attr_accessible :email, :name, :password, :password_confirmation

  has_many :authentications

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence   => true,
            :format     => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }

  def self.create_with_omniauth(info)
    create(name: auth['info']['name'])
  end
end