RSpec.describe Transaction do
  let(:account) { create(:account) }
  let(:description) { "A transaction" }
  let(:sub_category) { create(:sub_category, user: account.user) }
  let(:transacted_at) { 1.day.ago }
  let(:user) { account.user }
  let(:value) { 1 }

  describe "associations" do
    it "belongs to a User" do
      transaction = described_class.create(account:, description:, sub_category:, transacted_at:, user:, value:)
      expect(transaction.user).to be_a User
    end
  end

  describe "validations" do
    it "creates a new Transaction with proper params" do
      transaction = described_class.create(account:, description:, sub_category:, transacted_at:, user:, value:)
      expect(transaction).to be_persisted
    end

    it "validates the presence of the value" do
      transaction = described_class.create(account:, user:)

      expect(transaction).not_to be_persisted
      expect(transaction.error_codes).to eq({ value: %i[blank] })
    end

    it "validates that value not equal to 0" do
      transaction = described_class.create(account:, user:, value: 0)

      expect(transaction).not_to be_persisted
      expect(transaction.error_codes).to eq({ value: %i[other_than_0] })
    end

    it "validates the presence of the Account" do
      transaction = described_class.create(user:, value:)

      expect(transaction).not_to be_persisted
      expect(transaction.error_codes).to eq({ account: %i[blank] })
    end

    it "validates the presence of the User" do
      transaction = described_class.create(account:, value:)

      expect(transaction).not_to be_persisted
      expect(transaction.error_codes).to eq({ user: %i[blank] })
    end
  end
end
