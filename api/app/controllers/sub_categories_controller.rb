class SubCategoriesController < ApplicationController
  def index
    render json: current_user.sub_categories, status: :ok
  end
end
