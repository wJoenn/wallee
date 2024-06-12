class BudgetsController < ApplicationController
  before_action :set_resource, only: %i[destroy show update]

  def index
    budgets = current_user.budgets.includes(:transactions)
    render json: budgets.map(&:serialize), status: :ok
  end

  def show
    render json: @resource.serialize, status: :ok
  end

  def create
    @resource = current_user.budgets.new(budget_params)

    if @resource.save
      render json: @resource.serialize, status: :created
    else
      render json: { errors: @resource.error_codes }, status: :unprocessable_entity
    end
  end

  def update
    if @resource.update(budget_params)
      render json: @resource.serialize, status: :ok
    else
      render json: { errors: @resource.error_codes }, status: :unprocessable_entity
    end
  end

  def destroy
    @resource.destroy!
    render status: :ok
  end

  private

  def budget_params
    params.require(:budget).permit(:description, :name)
  end
end
