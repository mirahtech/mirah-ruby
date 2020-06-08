# frozen_string_literal: true

module ClientHelpers
  # Make a client with the appropriate credentials for VCR recording, or with dummy credentials for normal playback.
  def authorized_client
    Mirah::Client.new(
      host: ENV['VCR_HOST'] || 'http://localhost:3000',
      user_id: ENV['VCR_USER_ID'] || 'example_user_id',
      access_token: ENV['VCR_TOKEN'] || 'example_token'
    )
  end
end
