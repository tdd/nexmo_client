module NexmoClient
  class MessageResult
    attr_reader :message_id, :remaining_balance, :message_price, :to, :status, :error_text
    
    alias_method :id, :message_id
    alias_method :balance, :remaining_balance
    alias_method :price, :message_price
    alias_method :recipient, :to
    alias_method :errors, :error_text
    
    # Copied from the sending operation
    attr_reader :from, :type, :text, :status_report_req, :client_ref, :network_code, :vcard, :vcal, :ttl
    alias_method :status_report_requested, :status_report_req
    
    def initialize(hash, sending_hash = nil)
      hash ||= {}
      sending_hash ||= {}
      @message_id = hash['message-id']
      @remaining_balance = hash['remaining-balance'].to_f
      @message_price = hash['message-price'].to_f
      @to = hash['to']
      @status = convert_status(hash['status'])
      @error_text = hash['error-text']
      %w(from type text client-ref network-code vcard vcal ttl).each do |k|
        instance_variable_set "@#{k.tr('-', '_')}", sending_hash[k.to_sym]
      end
      @status_report_req = true if 1 == sending_hash[:'status-report-req']
    end
    
    def success?
      :success == status
    end
    
  private
    STATUSES = [
      :success, :throttled, :missing_params, :invalid_params, :invalid_credentials, :internal_error, :invalid_message,
      :number_barred, :partner_account_barred, :partner_quota_exceeded, :too_many_existing_binds, :account_not_enabled_for_rest,
      :message_too_long, :invalid_sender_address, :invalid_ttl
    ]
  
    def convert_status(code)
      code = code.to_i if code.to_s[/\A\d+\Z/]
      STATUSES[code] || code
    end
  end
end