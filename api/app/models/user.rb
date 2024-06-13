class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :recoverable, :rememberable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  UNSAFE_ATTRIBUTES_FOR_SERIALIZATION << :jti

  has_many :accounts, dependent: :destroy
  has_many :sub_categories, dependent: :destroy
  has_many :transactions, dependent: :destroy

  after_create :create_main_account

  def main_account
    accounts.find_by(main: true)
  end

  private

  def create_main_account
    accounts.create(name: I18n.t("accounts.main_account_default_name"), main: true)
  end
end
