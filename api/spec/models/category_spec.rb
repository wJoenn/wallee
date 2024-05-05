RSpec.describe Category do
  let(:name) { "A category" }

  describe "associations" do
    let(:category) { create(:category) }

    it "has many SubCategory" do
      create(:sub_category, category:)
      expect(category.sub_categories).to all be_a SubCategory
    end
  end

  describe "validations" do
    it "creates a new Category with proper params" do
      category = described_class.create(name:)
      expect(category).to be_persisted
    end

    it "validates the presence of the name" do
      category = described_class.create

      expect(category).not_to be_persisted
      expect(category.error_codes).to eq({ name: %i[blank] })
    end

    it "validates the uniqueness of the name" do
      described_class.create(name:)
      category = described_class.create(name:)

      expect(category).not_to be_persisted
      expect(category.error_codes).to eq({ name: %i[taken] })
    end
  end
end
