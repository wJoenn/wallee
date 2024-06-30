class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def limit
    params[:top]
  end

  def order
    return {} if params[:order].blank?

    order = JSON.parse(params[:order])
    order.to_h
  end

  def where
    return {} if params[:where].blank?

    where = JSON.parse(params[:where])
    where.map { |key, operator, value|
      parsed_value = case operator
      when "=" then value
      when "<" then (...value.to_time)
      when ">" then (value.to_time...)
      end

      [key.to_sym, parsed_value]
    }.to_h
  end
end
