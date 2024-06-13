class AccountsController < ApplicationController
  before_action :set_resource, only: %i[destroy show update]

  def index
    accounts = current_user.accounts.includes(:transactions)
    render json: accounts.map(&:serialize), status: :ok
  end

  def show
    render json: @resource.serialize(true), status: :ok
  end

  def create
    @resource = current_user.accounts.new(account_params)

    if @resource.save
      render json: @resource.serialize, status: :created
    else
      render json: { errors: @resource.error_codes }, status: :unprocessable_entity
    end
  end

  def update
    if @resource.update(account_params)
      render json: @resource.serialize(true), status: :ok
    else
      render json: { errors: @resource.error_codes }, status: :unprocessable_entity
    end
  end

  def destroy
    raise if @resource.main

    @resource.destroy!
    render status: :ok
  end

  private

  def account_params
    params.require(:account).permit(:description, :name)
  end
end