class Budget < ApplicationRecord
  belongs_to :user

  has_many :transactions, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  def serialize
    { description:, id:, name:, transactions: }
  end
end
