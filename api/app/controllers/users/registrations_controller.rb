class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    if resource.save
      sign_in(resource_name, resource)
      render json: resource, status: :created
    else
      render json: { errors: resource.error_codes }, status: :unprocessable_entity
    end
  end
end
