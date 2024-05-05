class SubCategoriesController < ApplicationController
  before_action :set_resource, only: %i[destroy show update]

  def index
    render json: current_user.sub_categories, status: :ok
  end

  def show
    render json: @resource, status: :ok
  end

  def create
    @resource = current_user.sub_categories.new(sub_category_params)

    if @resource.save
      render json: @resource, status: :created
    else
      render json: { errors: @resource.error_codes }, status: :unprocessable_entity
    end
  end

  def update
    if @resource.update(sub_category_params)
      render json: @resource, status: :ok
    else
      render json: { errors: @resource.error_codes }, status: :unprocessable_entity
    end
  end

  def destroy
    @resource.destroy!
    render status: :ok
  end

  private

  def sub_category_params
    params.require(:sub_category).permit(:category_id, :name)
  end
end