Gem::Specification.new do |s|
  s.name        = 'nexmo_client'
  s.version     = '0.1.0'
  s.date        = '2012-07-09'
  s.summary     = 'Full-featured client library for the Nexmo SMS service'
  s.description = 'This gem aims to provide easy-to-use support for the entire Developer API of the Nexmo SMS-related SaaS.  This also supports Ruby 1.8.x, not just Ruby 1.9+.'
  s.authors     = ['Christophe Porteneuve']
  s.email       = 'tdd@tddsworld.com'
  s.files       = [
    'lib/nexmo_client.rb',
    'lib/nexmo_client/delivery_report.rb',
    'lib/nexmo_client/exception.rb',
    'lib/nexmo_client/message_response.rb',
    'lib/nexmo_client/message_result.rb',
  ]
  s.homepage    = 'https://github.com/tdd/nexmo_client'
  s.license     = 'MIT'
  
  s.add_runtime_dependency 'json_pure'
  s.add_runtime_dependency 'rest-client', '~> 1.6.7'
end
