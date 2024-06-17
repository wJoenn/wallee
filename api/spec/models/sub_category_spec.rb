RSpec.describe SubCategory do
  let(:category) { create(:category) }
  let(:name) { "My sub category" }
  let(:user) { create(:user) }

  describe "associations" do
    it "belongs to a category" do
      sub_category = described_class.create(category:, name:, user:)
      expect(sub_category.category).to be_a Category
    end

    it "belongs to a User" do
      sub_category = described_class.create(category:, name:, user:)
      expect(sub_category.user).to be_a User
    end

    context "with transactions" do
      let(:sub_category) { create(:sub_category, user:) }
      let!(:transaction) { create(:transaction, account: create(:account, user:), sub_category:) }

      it "has many Transaction" do
        expect(sub_category.transactions).to all be_a Transaction
      end

      it "nullifies transactions on destroy" do
        sub_category.destroy
        expect(transaction.reload.sub_category).to be_nil
      end
    end
  end

  describe "validations" do
    it "creates a new SubCategory with proper params" do
      sub_category = described_class.create(category:, name:, user:)
      expect(sub_category).to be_persisted
    end

    it "validates the presence of the name" do
      sub_category = described_class.create(category:, user:)

      expect(sub_category).not_to be_persisted
      expect(sub_category.error_codes).to eq({ name: %i[blank] })
    end

    it "validates the uniqueness of the name" do
      described_class.create(category:, name:, user:)
      sub_category = described_class.create(category:, name:, user:)

      expect(sub_category).not_to be_persisted
      expect(sub_category.error_codes).to eq({ name: %i[taken] })
    end

    it "validates the presence of the Category" do
      sub_category = described_class.create(name:, user:)

      expect(sub_category).not_to be_persisted
      expect(sub_category.error_codes).to eq({ category: %i[blank] })
    end

    it "validates the presence of the User" do
      sub_category = described_class.create(category:, name:)

      expect(sub_category).not_to be_persisted
      expect(sub_category.error_codes).to eq({ user: %i[blank] })
    end
  end
end
