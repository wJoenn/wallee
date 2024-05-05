class BudgetsController < ApplicationController
  before_action :set_budget, only: %i[destroy update]

  def index
    render json: current_user.budgets, status: :ok
  end

  def create
    @budget = current_user.budgets.new(budget_params)

    if @budget.save
      render json: @budget, status: :created
    else
      render json: { errors: @budget.error_codes }, status: :unprocessable_entity
    end
  end

  def update
    if @budget.update(budget_params)
      render json: @budget, status: :ok
    else
      render json: { errors: @budget.error_codes }, status: :unprocessable_entity
    end
  end

  def destroy
    @budget.destroy!
    render status: :ok
  end

  private

  def budget_params
    params.require(:budget).permit(:description, :name)
  end

  def set_budget
    @budget = current_user.budgets.find_by(id: params[:id])
  end
end
