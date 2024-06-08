class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user

  def create
    self.resource = warden.authenticate(auth_options)

    if resource.present?
      sign_in(resource_name, resource)
      render json: resource, status: :ok
    else
      render json: { errors: { user: ["invalid_email_or_password"] } }, status: :unauthorized
    end
  end

  def destroy
    # Nothing happens here because `Warden::JWTAuth::Middleware` takes care of revoking the user's token after visiting
    # a route that matches `DELETE /users/sign_out`
    render status: :ok
  end
end
