class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :recoverable, :rememberable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  UNSAFE_ATTRIBUTES_FOR_SERIALIZATION << :jti

  has_many :budgets, dependent: :destroy
end
