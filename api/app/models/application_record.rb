class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def error_codes
    errors.group_by_attribute.each do |_attribute, errors|
      errors.map! { |error| error.details[:error] }
    end
  end
end
