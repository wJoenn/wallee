RSpec.describe TransactionsController, type: :request do
  let(:user) { create(:user) }

  describe "GET /transactions" do
    context "when a User is authenticated" do
      before do
        create(:transaction, user:)
        sign_in user
        get "/transactions"
      end

      it "returns a JSON array" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to all have_key "id"
      end

      it "returns a list of Transaction" do
        data = response.parsed_body

        data.each do |transaction|
          %w[id value].each do |key|
            expect(transaction).to have_key key
          end
        end
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/transactions"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "GET /transactions/:id" do
    let(:transaction) { create(:transaction, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
        get "/transactions/#{transaction.id}"
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "id"
      end

      it "returns the instance of Transaction" do
        data = response.parsed_body
        expect(data["id"]).to eq transaction.id
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/transactions/#{transaction.id}"
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "POST /transactions" do
    let(:budget_id) { create(:budget, user:).id }
    let(:description) { "A description" }
    let(:sub_category_id) { create(:sub_category, user:).id }
    let(:transacted_at) { 2.days.ago }
    let(:value) { 1 }

    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "with proper params" do
        before do
          post "/transactions", params: {
            transaction: {
              budget_id:,
              description:,
              sub_category_id:,
              transacted_at:,
              value:
            }
          }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "id"
        end

        it "creates an instance of Transaction" do
          expect(Transaction.count).to eq 1
        end

        it "returns the new instance of Transaction" do
          data = response.parsed_body
          expect(data).to include({
            "budget_id" => budget_id,
            "description" => description,
            "sub_category_id" => sub_category_id,
            "transacted_at" => transacted_at.floor,
            "user_id" => user.id,
            "value" => value
          })
        end

        it "returns a created HTTP status" do
          expect(response).to have_http_status :created
        end
      end

      context "without proper params" do
        before do
          post "/transactions", params: { transaction: { value: nil } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "errors"
        end

        it "does not create an instance of Transaction" do
          expect(Transaction.count).to eq 0
        end

        it "returns a list of error messages" do
          data = response.parsed_body
          expect(data["errors"]).to eq({
            "value" => %w[blank]
          })
        end

        it "returns a unprocessable_entity HTTP status" do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        post "/transactions", params: {
          transaction: {
            budget_id:,
            description:,
            sub_category_id:,
            transacted_at:,
            value:
          }
        }
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "PATCH /transactions/:id" do
    let(:transaction) { create(:transaction, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "with proper params" do
        before do
          patch "/transactions/#{transaction.id}", params: { transaction: { value: 2 } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "id"
        end

        it "returns the instance of Transaction" do
          data = response.parsed_body
          expect(data["id"]).to be transaction.id
        end

        it "updates the Transaction" do
          expect(transaction.reload.value).to be 2
        end

        it "returns a ok HTTP status" do
          expect(response).to have_http_status :ok
        end
      end

      context "without proper params" do
        before do
          patch "/transactions/#{transaction.id}", params: { transaction: { value: nil } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "errors"
        end

        it "returns a list of error messages" do
          data = response.parsed_body
          expect(data["errors"]).to eq({ "value" => %w[blank] })
        end

        it "returns a unprocessable_entity HTTP status" do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        patch "/transactions/#{transaction.id}"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "DELETE /transactions/:id" do
    let(:transaction) { create(:transaction, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
        delete "/transactions/#{transaction.id}"
      end

      it "destroys the instance of Transaction" do
        expect(Transaction.count).to be 0
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        delete "/transactions/#{transaction.id}"

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
