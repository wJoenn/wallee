class SubCategoriesController < ApplicationController
  before_action :set_sub_category, only: %i[show]

  def index
    render json: current_user.sub_categories, status: :ok
  end

  def show
    render json: @sub_category, status: :ok
  end

  def create
    @sub_category = current_user.sub_categories.new(sub_category_params)

    if @sub_category.save
      render json: @sub_category, status: :created
    else
      render json: { errors: @sub_category.error_codes }, status: :unprocessable_entity
    end
  end

  private

  def set_sub_category
    @sub_category = SubCategory.find(params[:id])
  end

  def sub_category_params
    params.require(:sub_category).permit(:category_id, :name)
  end
end
