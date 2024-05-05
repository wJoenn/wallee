class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show]

  def index
    render json: Category.all, status: :ok
  end

  def show
    render json: @category, status: :ok
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
