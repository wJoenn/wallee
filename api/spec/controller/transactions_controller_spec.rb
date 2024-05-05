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
end
