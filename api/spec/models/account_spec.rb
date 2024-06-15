RSpec.describe Account do
  let(:description) { "A generic account" }
  let(:name) { "My account" }
  let(:user) { create(:user) }

  describe "associations" do
    it "belongs to a User" do
      account = described_class.create(description:, name:, user:)
      expect(account.user).to be_a User
    end

    it "has many Transaction" do
      account = create(:account, user:)
      create(:transaction, account:, user:)

      expect(account.transactions).to all be_a Transaction
    end
  end

  describe "validations" do
    it "creates a new account with proper params" do
      account = described_class.create(description:, name:, user:)
      expect(account).to be_persisted
    end

    it "validates the presence of the name" do
      account = described_class.create(user:)

      expect(account).not_to be_persisted
      expect(account.error_codes).to eq({ name: %i[blank] })
    end

    it "validates the uniqueness of the name for this user" do
      described_class.create(name:, user:)
      account = described_class.create(name:, user:)

      expect(account).not_to be_persisted
      expect(account.error_codes).to eq({ name: %i[taken] })

      account = described_class.create(name:, user: create(:user, email: "another@user.com"))
      expect(account).to be_persisted
    end

    it "validates the presence of the User" do
      account = described_class.create(name:)

      expect(account).not_to be_persisted
      expect(account.error_codes).to eq({ user: %i[blank] })
    end
  end

  describe "hooks" do
    context "when Account is main" do
      it "destroys transactions" do
        create(:transaction, account: user.main_account, user:)
        expect { user.main_account.destroy }.to change(Transaction, :count).by(-1)
      end
    end

    context "when Account is not main" do
      let(:account) { create(:account, user:) }
      let!(:transaction) { create(:transaction, account:, user:) }

      it "reassigns transactions to main account if it exists" do
        account.destroy
        expect(transaction.reload.account_id).to be user.main_account.id
      end

      it "destroys transactions if main account doesn't exist" do
        user.main_account.destroy
        expect { account.destroy }.to change(Transaction, :count).by(-1)
      end
    end
  end

  describe "#balance" do
    let(:account) { create(:account) }

    before do
      create(:transaction, account:, user: account.user, value: 100_00)
      create(:transaction, account:, user: account.user, value: -200_00)
    end

    it "returns the sum of its Transactions value" do
      expect(account.balance).to be(-100_00)
    end
  end

  describe "#serialize" do
    let(:account) { create(:account) }
    let!(:transaction) { create(:transaction, account:, user: account.user) }

    it "returns a account as an hash" do
      serialized = account.serialize

      expect(serialized).to include(
        balance: 1,
        description: nil,
        name: "My account"
      )

      expect(serialized[:transactions]).to be_nil
    end

    it "includes transactions when Truthy argument is used" do
      expect(account.serialize(true)).to include(
        transactions: [transaction]
      )
    end
  end
end
