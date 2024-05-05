class Budget < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true
end
