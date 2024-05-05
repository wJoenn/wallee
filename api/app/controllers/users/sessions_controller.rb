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
    return render status: :unauthorized if all_signed_out?

    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render status: :ok
  end
end
