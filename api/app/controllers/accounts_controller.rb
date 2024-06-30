class AccountsController < ApplicationController
  before_action :set_resource, only: %i[destroy show update]

  def index
    accounts = current_user.accounts.includes(:executed_transactions, :planned_transactions)
      .where(where)
      .order(order)
      .limit(limit)

    render json: accounts.map(&:serialize), status: :ok
  end

  def show
    render json: @resource.serialize, status: :ok
  end

  def create
    @resource = current_user.accounts.new(resource_params)

    if @resource.save
      render json: @resource.serialize, status: :created
    else
      render json: { errors: @resource.error_codes }, status: :unprocessable_entity
    end
  end

  def update
    if @resource.update(resource_params)
      render json: @resource.serialize, status: :ok
    else
      render json: { errors: @resource.error_codes }, status: :unprocessable_entity
    end
  end

  def destroy
    if @resource.main?
      render status: :method_not_allowed
    else
      @resource.destroy!
      render status: :ok
    end
  end

  private

  def resource_params
    params.require(:account).permit(:category, :description, :name)
  end

  def set_resource
    @resource = current_user.accounts.find(params[:id])
  end
end
