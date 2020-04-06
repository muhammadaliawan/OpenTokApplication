class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  def username
    return email.split('@')[0].capitalize
  end

  has_one :message

  enum role: %i[admin client]
end
