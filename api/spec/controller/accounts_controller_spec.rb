RSpec.describe AccountsController, type: :request do
  let(:user) { create(:user) }

  describe "GET /accounts" do
    context "when a User is authenticated" do
      before do
        create(:account, user:)
        sign_in user
        get "/accounts"
      end

      it "returns a JSON array" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to all have_key "id"
      end

      it "returns a list of Account" do
        data = response.parsed_body

        data.each do |account|
          %w[id name].each do |key|
            expect(account).to have_key key
          end
        end
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/accounts"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "GET /accounts/:id" do
    let(:account) { create(:account, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
        get "/accounts/#{account.id}"
      end

      it "returns a JSON object" do
        expect(response.body).to be_a String
        expect(response.parsed_body).to have_key "id"
      end

      it "returns the instance of Account" do
        data = response.parsed_body
        expect(data["id"]).to eq account.id
      end

      it "returns a ok HTTP status" do
        expect(response).to have_http_status :ok
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        get "/accounts/#{account.id}"
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "POST /accounts" do
    let(:description) { "A generic account" }
    let(:name) { "My account" }

    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "with proper params" do
        it "returns a JSON object" do
          post "/accounts", params: { account: { description:, name: } }

          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "id"
        end

        it "creates an instance of Account" do
          expect { post "/accounts", params: { account: { description:, name: } } }.to change(Account, :count).by(1)
        end

        it "returns the new instance of Account" do
          post "/accounts", params: { account: { description:, name: } }
          data = response.parsed_body

          expect(data).to include({
            "description" => description,
            "name" => name
          })
        end

        it "returns a created HTTP status" do
          post "/accounts", params: { account: { description:, name: } }
          expect(response).to have_http_status :created
        end
      end

      context "without proper params" do
        it "returns a JSON object" do
          post "/accounts", params: { account: { name: nil } }

          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "errors"
        end

        it "does not create an instance of Account" do
          expect { post "/accounts", params: { account: { name: nil } } }.not_to change(Account, :count)
        end

        it "returns a list of error messages" do
          post "/accounts", params: { account: { name: nil } }
          data = response.parsed_body

          expect(data["errors"]).to eq({ "name" => %w[blank] })
        end

        it "returns a unprocessable_entity HTTP status" do
          post "/accounts", params: { account: { name: nil } }
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        post "/accounts", params: { account: { description:, name: } }
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "PATCH /accounts/:id" do
    let(:account) { create(:account, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "with proper params" do
        before do
          patch "/accounts/#{account.id}", params: { account: { name: "New account name" } }
        end

        it "returns a JSON object" do
          expect(response.body).to be_a String
          expect(response.parsed_body).to have_key "id"
        end

        it "returns the instance of Account" do
          data = response.parsed_body
          expect(data["id"]).to be account.id
        end

        it "updates the Account" do
          expect(account.reload.name).to eq "New account name"
        end

        it "returns a ok HTTP status" do
          expect(response).to have_http_status :ok
        end
      end

      context "without proper params" do
        before do
          patch "/accounts/#{account.id}", params: { account: { name: nil } }
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
        patch "/accounts/#{account.id}"

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "DELETE /accounts/:id" do
    let!(:account) { create(:account, user:) }

    context "when a User is authenticated" do
      before do
        sign_in user
      end

      context "when the Account is the user's main account" do
        it "does not destroy the instance of Account" do
          expect { delete "/accounts/#{user.main_account.id}" }.not_to change(Account, :count)
        end

        it "returns a method_not_allowed HTTP status" do
          delete "/accounts/#{user.main_account.id}"
          expect(response).to have_http_status :method_not_allowed
        end
      end

      context "when the Account is not the user's main account" do
        it "destroys the instance of Account" do
          expect { delete "/accounts/#{account.id}" }.to change(Account, :count).by(-1)
        end

        it "returns a ok HTTP status" do
          delete "/accounts/#{account.id}"
          expect(response).to have_http_status :ok
        end
      end
    end

    context "when a User is not authenticated" do
      it "returns a unauthorized HTTP status" do
        delete "/accounts/#{account.id}"

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
