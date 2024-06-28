class Transaction < ApplicationRecord
  scope :executed, -> { where("transacted_at < ?", Time.zone.tomorrow) }
  scope :planned, -> { where("transacted_at >= ?", Time.zone.tomorrow) }

  belongs_to :account

  delegate :user, to: :account

  validates :value, presence: true, numericality: { allow_blank: true, other_than: 0 }
end
