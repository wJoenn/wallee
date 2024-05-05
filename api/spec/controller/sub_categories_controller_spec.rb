RSpec.describe SubCategoriesController, type: :request do
  let(:user) { create(:user) }

  describe "GET /sub_categories" do
    context "when a User is authenticated" do
      before do
        create(:sub_category, user:)
        sign_in user
        get "/sub_categories"
      end

      it "returns a JSON array" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to all have_key "id"
      end

      it "returns a list of SubCategory" do
        data = response.parsed_body

        data.each do |sub_category|
          %w[id name].each do |key|
            expect(sub_category).to have_key key
          end
        end
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/sub_categories"

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
