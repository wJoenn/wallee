RSpec.describe Transaction do
  let(:budget) { create(:budget) }
  let(:description) { "A transaction" }
  let(:sub_category) { create(:sub_category, user: budget.user) }
  let(:transacted_at) { 1.day.ago }
  let(:user) { budget.user }
  let(:value) { 1 }

  describe "associations" do
    it "belongs to a User" do
      transaction = described_class.create(budget:, description:, sub_category:, transacted_at:, user:, value:)
      expect(transaction.user).to be_a User
    end
  end

  describe "validations" do
    it "creates a new Transaction with proper params" do
      transaction = described_class.create(budget:, description:, sub_category:, transacted_at:, user:, value:)
      expect(transaction).to be_persisted
    end

    it "validates the presence of the value" do
      transaction = described_class.create(user:)

      expect(transaction).not_to be_persisted
      expect(transaction.error_codes).to eq({ value: %i[blank] })
    end

    it "validates that value not equal to 0" do
      transaction = described_class.create(user:, value: 0)

      expect(transaction).not_to be_persisted
      expect(transaction.error_codes).to eq({ value: %i[other_than_0] })
    end

    it "validates the presence of the User" do
      transaction = described_class.create(value:)

      expect(transaction).not_to be_persisted
      expect(transaction.error_codes).to eq({ user: %i[blank] })
    end
  end
end
