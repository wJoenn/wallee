class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate(auth_options)

    if resource.present?
      sign_in(resource_name, resource)
      render json: resource, status: :ok
    else
      render json: { errors: { user: ["invalid_email_or_password"] } }, status: :unauthorized
    end
  end
end
