# frozen_string_literal: true

module Mirah
  # The result of a create or update operation.
  #
  # @example Create a new patient
  #   result = client.push_patient(external_id: 'mrn001', given_name: 'Henry', family_name: 'Jones',
  #                                birth_date: Date.parse('1983-03-20'))
  #     => #<Mirah::PushResult:... @given_name="Henry", @family_name="Jones", @birth_date=#<Date: 1983-03-20>
  #   result.status # => "UPDATED"
  #   result.result.given_name # => "Henry"
  class PushResult
    def initialize(status:, result:, errors:, input:)
      @result = result
      @status = status
      @errors = errors
      @input = input
    end

    # The status of the request. It can be one of:
    #  * CREATED: A new resource was created
    #  * UPDATED: An existing resource was updated
    #  * SKIPPED: The record was understood but not processed.
    #  * ERROR: An error occured.
    # @return ["CREATED", "UPDATED", "ERROR", "SKIPPED"]
    attr_reader :status

    # The result, where executed successfully.
    # @return [Data, nil] the appropriate data type, if the result was successful
    attr_reader :result

    # Any errors that occurred in processing
    # @return [Array<Error>] any errors that occurred.
    attr_reader :errors

    # The input parameters used
    # @return [Input] the input object
    attr_reader :input
  end
end
