class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def filters
    return {} if params[:filters].blank?

    filters = JSON.parse(params[:filters])
    filters.map { |key, operator, value|
      parsed_value = case operator
      when "=" then value
      when "<" then (...value.to_time)
      when ">" then (value.to_time...)
      end

      [key.to_sym, parsed_value]
    }.to_h
  end
end
