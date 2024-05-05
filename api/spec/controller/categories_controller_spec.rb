RSpec.describe CategoriesController, type: :request do
  let(:user) { create(:user) }
  let!(:category) { create(:category) }

  describe "GET /categories" do
    context "when a User is authenticated" do
      before do
        sign_in user
        get "/categories"
      end

      it "returns a JSON array" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to all have_key "id"
      end

      it "returns a list of Category" do
        data = response.parsed_body

        data.each do |category|
          %w[id name].each do |key|
            expect(category).to have_key key
          end
        end
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/categories"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "GET /categories/:id" do
    context "when a User is authenticated" do
      before do
        sign_in user
        get "/categories/#{category.id}"
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "id"
      end

      it "returns the instance of Category" do
        data = response.parsed_body
        expect(data["id"]).to eq category.id
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/categories/#{category.id}"
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
