RSpec.describe Account do
  let(:category) { :budget }
  let(:description) { "A generic account" }
  let(:name) { "My account" }
  let(:user) { create(:user) }

  describe "associations" do
    it "belongs to a User" do
      account = create(:account, user:)
      expect(account.user).to be_a User
    end

    it "has many Transaction" do
      account = create(:account, user:)
      create(:transaction, account:)

      expect(account.transactions).to all be_a Transaction
    end
  end

  describe "validations" do
    it "creates a new account with proper params" do
      account = described_class.create(category:, description:, name:, user:)
      expect(account).to be_persisted
    end

    it "validates the presence of the category" do
      account = described_class.create(name:, user:)

      expect(account).not_to be_persisted
      expect(account.error_codes).to eq({ category: %i[blank] })
    end

    it "validates uniqueness of the category: :main account for this user" do
      user.accounts.destroy_all # :main account already exists: User#create_main_account
      described_class.create(category: :main, name:, user:)
      account = described_class.create(category: :main, name: "another-name", user:)

      expect(account).not_to be_persisted
      expect(account.error_codes).to eq({ category: %i[taken] })

      another_user = create(:user, email: "another@user.com")
      another_user.accounts.destroy_all # :main account already exists: User#create_main_account
      account = described_class.create(category: :main, name:, user: another_user)
      expect(account).to be_persisted
    end

    it "validates the presence of the name" do
      account = described_class.create(category:, user:)

      expect(account).not_to be_persisted
      expect(account.error_codes).to eq({ name: %i[blank] })
    end

    it "validates the uniqueness of the name for this user" do
      described_class.create(category:, name:, user:)
      account = described_class.create(category:, name:, user:)

      expect(account).not_to be_persisted
      expect(account.error_codes).to eq({ name: %i[taken] })

      account = described_class.create(category:, name:, user: create(:user, email: "another@user.com"))
      expect(account).to be_persisted
    end

    it "validates the presence of the User" do
      account = described_class.create(category:, name:)

      expect(account).not_to be_persisted
      expect(account.error_codes).to eq({ user: %i[blank] })
    end
  end

  describe "hooks" do
    context "when Account is main" do
      it "destroys transactions" do
        create(:transaction, account: user.main_account)
        expect { user.main_account.destroy }.to change(Transaction, :count).by(-1)
      end
    end

    context "when Account is not main" do
      let(:account) { create(:account, category: :budget, user:) }
      let!(:transaction) { create(:transaction, account:) }

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
      create(:transaction, account:, value: 100_00)
      create(:transaction, account:, value: -200_00)
      create(:transaction, account:, transacted_at: Time.zone.tomorrow, value: 100_00)
    end

    it "returns the sum of its completed Transactions value" do
      expect(account.balance).to be(-100_00)
    end
  end

  describe "#serialize" do
    let(:account) { create(:account) }
    let!(:executed_transaction) { create(:transaction, account:) }
    let!(:planned_transaction) { create(:transaction, account:, transacted_at: Time.zone.tomorrow) }

    it "returns a account as an hash" do
      serialized = account.serialize

      expect(serialized).to include(
        balance: 1,
        description: nil,
        executed_transactions: [executed_transaction],
        name: "My account",
        planned_transactions: [planned_transaction]
      )

      expect(serialized[:transactions]).to be_nil
    end
  end
end
