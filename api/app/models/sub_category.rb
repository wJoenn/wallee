class SubCategory < ApplicationRecord
  belongs_to :category
  belongs_to :user

  has_many :transactions, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
