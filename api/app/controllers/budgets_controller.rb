class BudgetsController < ApplicationController
  def create
    @budget = current_user.budgets.new(budget_params)

    if @budget.save
      render json: @budget, status: :created
    else
      render json: { errors: @budget.error_codes }, status: :unprocessable_entity
    end
  end

  private

  def budget_params
    params.require(:budget).permit(:description, :name)
  end
end
