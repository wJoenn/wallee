class CategoriesController < ApplicationController
  before_action :set_resource, only: %i[show]

  def index
    render json: Category.all, status: :ok
  end

  def show
    render json: @resource, status: :ok
  end
end
