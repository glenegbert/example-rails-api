module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ArgumentError do |e|
      raise e if e.message != 'invalid date'
      json_response({ message: 'invalid date formatting' },
                    :unprocessable_entity)
    end
  end
end
