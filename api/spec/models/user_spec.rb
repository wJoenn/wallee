RSpec.describe User do
  let(:email) { "user@example.com" }
  let(:password) { "password" }

  describe "associations" do
    let(:user) { create(:user) }

    context "with accounts" do
      before do
        create(:account, user:)
      end

      it "has many Account" do
        expect(user.accounts).to all be_a Account
      end

      it "destroys accounts on destroy" do
        user.destroy
        expect(Account.count).to be 0
      end
    end

    context "with transactions" do
      before do
        create(:transaction, account: create(:account, user:))
      end

      it "has many Transaction" do
        expect(user.transactions).to all be_a Transaction
      end

      it "destroys transactions on destroy" do
        user.destroy
        expect(Transaction.count).to be 0
      end
    end
  end

  describe "validations" do
    it "creates a User with proper params" do
      user = described_class.create(email:, password:)
      expect(user).to be_persisted
    end

    it "validates the presence of the email" do
      user = described_class.create(password:)

      expect(user).not_to be_persisted
      expect(user.error_codes).to eq({ email: %i[blank] })
    end

    it "validates the format of the email" do
      user = described_class.create(email: "error@example", password:)

      expect(user).not_to be_persisted
      expect(user.error_codes).to eq({ email: %i[invalid] })
    end

    it "validates the uniqueness of the email" do
      described_class.create(email:, password:)
      user = described_class.create(email:, password:)

      expect(user).not_to be_persisted
      expect(user.error_codes).to eq({ email: %i[taken] })
    end

    it "validates the presence of the password" do
      user = described_class.create(email:)

      expect(user).not_to be_persisted
      expect(user.error_codes).to eq({ password: %i[blank] })
    end

    it "validates the similarity of the password_confirmation and the password" do
      user = described_class.create(email:, password:, password_confirmation: "error")

      expect(user).not_to be_persisted
      expect(user.error_codes).to eq({ password_confirmation: %i[confirmation] })
    end
  end

  describe "hooks" do
    let(:user) { create(:user) }

    it "creates a main Account after beign created" do
      expect(user.accounts.first).to be_a Account
    end
  end
end
