class Transaction < ApplicationRecord
  belongs_to :budget, optional: true
  belongs_to :user
  belongs_to :sub_category, optional: true

  validates :value, presence: true, numericality: { allow_blank: true, other_than: 0 }
end
