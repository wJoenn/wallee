class TransactionsController < ApplicationController
  before_action :set_resource, only: %i[show]

  def index
    render json: current_user.transactions, status: :ok
  end

  def show
    render json: @resource, status: :ok
  end
end
