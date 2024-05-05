class TransactionsController < ApplicationController
  def index
    render json: current_user.transactions, status: :ok
  end
end
