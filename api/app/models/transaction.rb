class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :sub_category, optional: true

  delegate :user, to: :account

  validates :value, presence: true, numericality: { allow_blank: true, other_than: 0 }
end
