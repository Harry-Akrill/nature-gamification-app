# frozen_string_literal: true

Sentry.init do |config|
  # Sentry is only enabled when the dsn is set.
  config.dsn = "https://67b349f804b72c02786d1aea5a301859@sentry.shefcompsci.org.uk/365" unless Rails.env.development? || Rails.env.test?
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.before_send = lambda {|event, _hint|
    ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters).filter(event.to_hash)
  }
  config.excluded_exceptions += [
    "ActionController::BadRequest",
    "ActionController::UnknownFormat",
    "ActionController::UnknownHttpMethod",
    "ActionDispatch::Http::MimeNegotiation::InvalidType",
    "CanCan::AccessDenied",
    "Mime::Type::InvalidMimeType",
    "Rack::QueryParser::InvalidParameterError",
    "Rack::QueryParser::ParameterTypeError",
    "SystemExit",
    "URI::InvalidURIError"
  ]
end
