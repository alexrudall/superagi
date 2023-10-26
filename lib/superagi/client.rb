module SuperAGI
  class Client
    include SuperAGI::HTTP

    CONFIG_KEYS = %i[
      api_type
      api_version
      secret_key
      uri_base
      request_timeout
      extra_headers
    ].freeze
    attr_reader *CONFIG_KEYS

    def initialize(config = {})
      CONFIG_KEYS.each do |key|
        # Set instance variables like api_type & secret_key. Fall back to global config
        # if not present.
        instance_variable_set("@#{key}", config[key] || SuperAGI.configuration.send(key))
      end
    end

    def agent
      @agent ||= SuperAGI::Agent.new(client: self)
    end
  end
end
