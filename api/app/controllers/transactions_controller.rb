class TransactionsController < ApplicationController
  before_action :set_resource, only: %i[destroy show update]

  def index
    render json: current_user.transactions, status: :ok
  end

  def show
    render json: @resource, status: :ok
  end

  def create
    @resource = current_user.transactions.new(resource_params)

    if @resource.save
      render json: @resource, status: :created
    else
      render json: { errors: @resource.error_codes }, status: :unprocessable_entity
    end
  end

  def update
    if @resource.update(resource_params)
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

  def resource_params
    params.require(:transaction).permit(:account_id, :description, :transacted_at, :value)
  end

  def set_resource
    @resource = current_user.transactions.find(params[:id])
  end
end
