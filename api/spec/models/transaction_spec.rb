RSpec.describe Transaction do
  let(:account) { create(:account) }
  let(:description) { "A transaction" }
  let(:transacted_at) { 1.day.ago }
  let(:user) { account.user }
  let(:value) { 1 }

  describe "associations" do
    it "belongs to an Account" do
      transaction = described_class.create(account:, description:, transacted_at:, value:)
      expect(transaction.account).to be_an Account
    end
  end

  describe "validations" do
    it "creates a new Transaction with proper params" do
      transaction = described_class.create(account:, description:, transacted_at:, value:)
      expect(transaction).to be_persisted
    end

    it "validates the presence of the value" do
      transaction = described_class.create(account:)

      expect(transaction).not_to be_persisted
      expect(transaction.error_codes).to eq({ value: %i[blank] })
    end

    it "validates that value not equal to 0" do
      transaction = described_class.create(account:, value: 0)

      expect(transaction).not_to be_persisted
      expect(transaction.error_codes).to eq({ value: %i[other_than_0] })
    end

    it "validates the presence of the Account" do
      transaction = described_class.create(value:)

      expect(transaction).not_to be_persisted
      expect(transaction.error_codes).to eq({ account: %i[blank] })
    end
  end
end
