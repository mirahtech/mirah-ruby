# frozen_string_literal: true

module Mirah
  module Data
    # Invitations represent the Mirah system's intent for a given person to take an assessment during a given time
    # period as part of a given measurement. It tracks when the user can take it and the notifications associated with
    # such an invitation.
    class Invitation < BaseObject
      # @!attribute [r] id
      #   @return [string] The internal Mirah identifier
      attribute :id

      # @!attribute [r] phase
      #   @return ["BEFORE", "DURING", "AFTER"] The phase this invitation should be taken as part of.
      attribute :phase

      # @!attribute [r] status
      #   @return ["FUTURE","NEW","SCHEDULED","SENT","BEGUN","COMPLETE","LOCKED_OUT"] The status of the invitation.
      attribute :status

      # @!attribute [r] notification_status
      #   @return ["SENT", "SCHEDULED", "FORBIDDEN", "MISSING_DETAILS", "NOT_NEEDED"] The status of the invitation.
      attribute :notification_status

      # @!attribute [r] last_notification_date
      #   @return [Date] The date the latest notification was sent at
      attribute :last_notification_date, serializer: Serializers::DateTimeSerializer.new
    end
  end
end
