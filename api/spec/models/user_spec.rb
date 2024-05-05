RSpec.describe User do
  let(:email) { "user@example.com" }
  let(:password) { "password" }

  describe "associations" do
    let(:user) { create(:user) }

    context "with budgets" do
      before do
        create(:budget, user:)
      end

      it "has many Budget" do
        expect(user.budgets).to all be_a Budget
      end

      it "destroys budgets on destroy" do
        user.destroy
        expect(Budget.count).to be 0
      end
    end

    context "with sub_categories" do
      before do
        create(:sub_category, user:)
      end

      it "has many SubCategory" do
        expect(user.sub_categories).to all be_a SubCategory
      end

      it "destroys sub_categories on destroy" do
        user.destroy
        expect(SubCategory.count).to be 0
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
end
