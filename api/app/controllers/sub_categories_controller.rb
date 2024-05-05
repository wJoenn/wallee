class SubCategoriesController < ApplicationController
  before_action :set_sub_category, only: %i[show]

  def index
    render json: current_user.sub_categories, status: :ok
  end

  def show
    render json: @sub_category, status: :ok
  end

  private

  def set_sub_category
    @sub_category = SubCategory.find(params[:id])
  end
end
