module DateChecker
  def with_date_check
    yield
  rescue ArgumentError => e
    raise e if e.message != 'invalid date'
      json_response({ message: 'invalid date formatting' },
                    :unprocessable_entity)
  end
end
