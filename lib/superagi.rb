require "faraday"
require "faraday/multipart"

require_relative "superagi/http"
require_relative "superagi/client"
require_relative "superagi/agent"

module SuperAGI
  class Error < StandardError; end
  class ConfigurationError < Error; end

  class Configuration
    attr_writer :secret_key
    attr_accessor :api_type, :api_version, :uri_base, :request_timeout,
                  :extra_headers

    DEFAULT_API_VERSION = "v1".freeze
    DEFAULT_URI_BASE = "https://app.superagi.com/api/".freeze
    DEFAULT_REQUEST_TIMEOUT = 120

    def initialize
      @secret_key = nil
      @api_type = nil
      @api_version = DEFAULT_API_VERSION
      @uri_base = DEFAULT_URI_BASE
      @request_timeout = DEFAULT_REQUEST_TIMEOUT
      @extra_headers = nil
    end

    def secret_key
      return @secret_key if @secret_key

      error_text = "SuperAGI secret key missing! See https://github.com/alexrudall/superagi#usage"
      raise ConfigurationError, error_text
    end
  end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= SuperAGI::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
