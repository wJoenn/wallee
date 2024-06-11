RSpec.describe Budget do
  let(:description) { "A budget to budgetise" }
  let(:name) { "My budget" }
  let(:user) { create(:user) }

  describe "associations" do
    it "belongs to a User" do
      budget = described_class.create(description:, name:, user:)
      expect(budget.user).to be_a User
    end

    context "with transactions" do
      let(:budget) { create(:budget, user:) }
      let!(:transaction) { create(:transaction, budget:, user:) }

      it "has many Transaction" do
        expect(budget.transactions).to all be_a Transaction
      end

      it "nullifies transactions on destroy" do
        budget.destroy
        expect(transaction.reload.budget).to be_nil
      end
    end
  end

  describe "validations" do
    it "creates a new Budget with proper params" do
      budget = described_class.create(description:, name:, user:)
      expect(budget).to be_persisted
    end

    it "validates the presence of the name" do
      budget = described_class.create(user:)

      expect(budget).not_to be_persisted
      expect(budget.error_codes).to eq({ name: %i[blank] })
    end

    it "validates the uniqueness of the name" do
      described_class.create(name:, user:)
      budget = described_class.create(name:, user:)

      expect(budget).not_to be_persisted
      expect(budget.error_codes).to eq({ name: %i[taken] })
    end

    it "validates the presence of the User" do
      budget = described_class.create(name:)

      expect(budget).not_to be_persisted
      expect(budget.error_codes).to eq({ user: %i[blank] })
    end
  end

  describe "#serialize" do
    let(:budget) { create(:budget) }

    before do
      create(:transaction, budget:, user: budget.user)
    end

    it "returns a Budget as an hash" do
      expect(budget.serialize).to be_a Hash
    end

    it "includes an array of Transaction" do
      expect(budget.serialize[:transactions]).to all be_a Transaction
    end
  end
end
