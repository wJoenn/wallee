class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end
end
