require 'nexmo_client/message_result'

module NexmoClient
  class MessageResponse
    attr_reader :message_count, :messages
    
    alias_method :count, :message_count
    
    def initialize(hash, sending_hash = {})
      hash ||= {}
      @message_count = hash['message-count'].to_i
      @messages = (hash['messages'] || []).map { |h| MessageResult.new(h, sending_hash) }
    end
  end
end