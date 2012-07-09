require 'time'

module NexmoClient
  class DeliveryReport
    # Official fields
    attr_reader :to, :network_code, :message_id, :msisdn, :status, :err_code, :scts, :message_timestamp, :client_ref
    
    # Aliases
    # CHECK: :to semantics ("Sender ID of the message?!")
    alias_method :recipient, :msisdn
    alias_method :error_code, :err_code
    alias_method :notified_at, :scts
    alias_method :reported_at, :message_timestamp
    
    def initialize(hash)
      hash = hash || {}
      @to                 = hash['to'] # CHECK semantics…
      @network_code       = hash['network-code']
      @message_id         = hash['messageId']
      @msisdn             = hash['msisdn']
      @status             = hash['status'].to_sym
      @err_code           = convert_error_code(hash['err_code'])
      @scts               = convert_scts(hash['scts'])
      @message_timestamp  = convert_stamp(hash['to'])
      @client_ref         = hash['to']
    end
    
    def delivered?
      :delivered == error_code
    end
    
    alias_method :success?, :delivered?
    
  private
    ERROR_CODES = [:delivered, :unknown, :temporary_absent_subscriber, :permanently_absent_subscriber, :call_barred_by_user,
      :portability_error, :anti_spam_rejection, :handset_busy, :network_error, :illegal_number, :invalid_message, :unroutable]
    ERROR_CODES[99] = :general_error
    
    def convert_error_code(code)
      code = code.to_i if code.to_s[/\A\d+\Z/]
      ERROR_CODES[code] || code
    end
    
    def convert_scts(scts)
      y, m, d, hr, mn = (scts.to_s.scan(/(..)(..)(..)(..)(..)/).first || []).map(&:to_i)
      return scts unless y > 0 && m > 0 && d > 0
      Time.utc(y + 2000, m, d, hr, mn, 0).localtime
      # FIXME: check Ruby 1.9 compat for this
    end
    
    def convert_stamp(stamp)
      Time.parse(stamp) rescue stamp
      # FIXME: check timezone, parse result, and Ruby 1.9 compat for this
    end
  end
end
