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

  describe "GET /sub_categories/:id" do
    let(:sub_category) { create(:sub_category, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
        get "/sub_categories/#{sub_category.id}"
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "id"
      end

      it "returns the instance of SubCategory" do
        data = response.parsed_body
        expect(data["id"]).to eq sub_category.id
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/sub_categories/#{sub_category.id}"
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "POST /sub_categories" do
    let(:category) { create(:category) }
    let(:name) { "My sub category" }

    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "with proper params" do
        before do
          post "/sub_categories", params: { sub_category: { category_id: category.id, name: } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "id"
        end

        it "creates an instance of SubCategory" do
          expect(SubCategory.count).to eq 1
        end

        it "returns the new instance of SubCategory" do
          data = response.parsed_body
          expect(data).to include({
            "name" => name
          })
        end

        it "returns a created HTTP status" do
          expect(response).to have_http_status :created
        end
      end

      context "without proper params" do
        before do
          post "/sub_categories", params: { sub_category: { category_id: nil, name: nil } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "errors"
        end

        it "does not create an instance of SubCategory" do
          expect(SubCategory.count).to eq 0
        end

        it "returns a list of error messages" do
          data = response.parsed_body
          expect(data["errors"]).to eq({
            "category" => %w[blank],
            "name" => %w[blank]
          })
        end

        it "returns a unprocessable_entity HTTP status" do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        post "/sub_categories", params: { sub_category: { category_id: category.id, name: } }
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
