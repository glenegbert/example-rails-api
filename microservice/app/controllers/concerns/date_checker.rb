module DateChecker
  def with_date_check
    begin
      yield
    rescue ArgumentError => e
      if e.message == "invalid date"
        return json_response({message: "invalid date formatting"},
                              :unprocessable_entity)
      else
        raise e
      end
    end
  end
end

