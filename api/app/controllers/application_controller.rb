class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
    render status: :not_found if @resource.respond_to?(:user) && @resource.user != current_user
  end
end
