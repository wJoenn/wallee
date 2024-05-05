RSpec.describe Budget do
  let(:description) { "A budget to budgetise" }
  let(:name) { "My budget" }
  let(:user) { create(:user) }

  describe "associations" do
    it "belongs to a User" do
      budget = described_class.create(description:, name:, user:)
      expect(budget.user).to be_a User
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
end
