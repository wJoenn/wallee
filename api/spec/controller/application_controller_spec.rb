RSpec.describe ApplicationController, type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user, email: "another@user.com") }

  before do
    sign_in user
  end

  describe "#set_resource" do
    it "returns the user's given resource" do
      get "/accounts/#{user.main_account.id}"
      expect(response.parsed_body["id"]).to be user.main_account.id
    end

    it "does not return another user's given resource" do
      get "/accounts/#{another_user.main_account.id}"
      expect(response).to have_http_status :not_found
    end
  end
end
