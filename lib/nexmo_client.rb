$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'json'
require 'rest_client'

require 'nexmo_client/exception'
require 'nexmo_client/message_response'

module NexmoClient
  def self.send(options)
    options = require_options!(options, *MESSAGE_SEND_PARAM_CHECKS)
    call :post, :sms, options
  end

private
  BOOLEAN_PARAMS = %w(status-report-req).map(&:to_sym)
  ENDPOINT = "https://rest.nexmo.com"
  MESSAGE_SEND_PARAM_CHECKS = [:from, :text, { :recipient => :to, :status_report_requested => :status_report_req }]
  
  class << self
  private
    def call(verb, method, params)
      url = "#{ENDPOINT}/#{method}/json"
      response = RestClient.send(verb, url, params)
      MessageResponse.new JSON.parse(response.to_str), params
    end

    def require_options!(hash, *keys)
      mappings = keys.last.is_a?(Hash) ? keys.pop : {}
      hash = hash.inject({}) do |res, (k, v)|
        res[k.to_s.tr('_', '-').to_sym] = v
        res
      end
      mappings.each do |from, to|
        from, to = from.to_sym, to.to_sym
        hash[to] = hash[from] unless hash[to]
      end
      (mappings.keys & BOOLEAN_PARAMS).each do |p|
        hash[p] = (hash[p] ? 1 : 0) if [true, false].include?(hash[p])
      end
      if (missing_keys = keys - hash.keys).size > 0
        raise Exception.new("Missing call options: #{keys.join(', ')}.")
      end
      hash[:username] = ENV['NEXMO_KEY'] unless hash[:username]
      hash[:password] = ENV['NEXMO_SECRET'] unless hash[:password]
      hash
    end
  end
end