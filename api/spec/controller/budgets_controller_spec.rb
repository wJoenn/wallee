RSpec.describe BudgetsController, type: :request do
  let(:user) { create(:user) }

  describe "GET /budgets" do
    context "when a User is authenticated" do
      before do
        create(:budget, user:)
        sign_in user
        get "/budgets"
      end

      it "returns a JSON array" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to all have_key "id"
      end

      it "returns a list of Budget" do
        data = response.parsed_body

        data.each do |budget|
          %w[id name].each do |key|
            expect(budget).to have_key key
          end
        end
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/budgets"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "POST /budgets" do
    let(:description) { "A budget to budgetise" }
    let(:name) { "My budget" }

    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "with proper params" do
        before do
          post "/budgets", params: { budget: { description:, name: } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "id"
        end

        it "creates an instance of Budget" do
          expect(Budget.count).to eq 1
        end

        it "returns the new instance of Budget" do
          data = response.parsed_body
          expect(data).to include({
            "description" => description,
            "name" => name
          })
        end

        it "returns a created HTTP status" do
          expect(response).to have_http_status :created
        end
      end

      context "without proper params" do
        before do
          post "/budgets", params: { budget: { name: nil } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "errors"
        end

        it "does not create an instance of Budget" do
          expect(Budget.count).to eq 0
        end

        it "returns a list of error messages" do
          data = response.parsed_body
          expect(data["errors"]).to eq({ "name" => %w[blank] })
        end

        it "returns a unprocessable_entity HTTP status" do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        post "/budgets", params: { budget: { description:, name: } }
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "PATCH /budgets/:id" do
    let(:budget) { create(:budget, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "with proper params" do
        before do
          patch "/budgets/#{budget.id}", params: { budget: { name: "New budget name" } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "id"
        end

        it "returns the instance of Budget" do
          data = response.parsed_body
          expect(data["id"]).to be budget.id
        end

        it "updates the Budget" do
          expect(budget.reload.name).to eq "New budget name"
        end

        it "returns a ok HTTP status" do
          expect(response).to have_http_status :ok
        end
      end

      context "without proper params" do
        before do
          patch "/budgets/#{budget.id}", params: { budget: { name: nil } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "errors"
        end

        it "returns a list of error messages" do
          data = response.parsed_body
          expect(data["errors"]).to eq({ "name" => ["blank"] })
        end

        it "returns a unprocessable_entity HTTP status" do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        patch "/budgets/#{budget.id}"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "DELETE /budgets/:id" do
    let(:budget) { create(:budget, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
        delete "/budgets/#{budget.id}"
      end

      it "destroys the instance of Budget" do
        expect(Budget.count).to be 0
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        delete "/budgets/#{budget.id}"

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
