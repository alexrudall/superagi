module SuperAGI
  class Agent
    def initialize(client:)
      @client = client
    end

    def create(parameters:)
      parameters = valid_parameters(method: :create, parameters: parameters)
      @client.json_post(path: "/agent", parameters: parameters)
    end

    def update(id:, parameters:)
      parameters = DEFAULT_UPDATE_PARAMETERS.merge(parameters)
      @client.json_put(path: "/agent/#{id}", parameters: parameters)
    end

    def run(id:)
      @client.json_post(path: "/agent/#{id}/run", parameters: {})
    end

    def pause(id:)
      @client.json_post(path: "/agent/#{id}/pause", parameters: {})
    end

    # def resume(id:)
      # @client.json_post(path: "/agent/#{id}/resume", parameters: {})
    # end

    def status(id:)
      @client.json_post(path: "/agent/#{id}/run-status", parameters: {})
    end

    # def resources(id:)
      # @client.json_post(path: "/agent/resources/output", parameters: {})
    # end

    private

    ARRAY_PARAMETERS = %w[
      constraints
      goal
      tools
    ].freeze

    DEFAULT_CREATE_PARAMETERS = {
      agent_workflow: "Goal Based Workflow",
      model: "gpt-4"
    }.freeze
    REQUIRED_CREATE_PARAMETERS = (%w[
      description
      instruction
      iteration_interval
      max_iterations
      name
    ] + ARRAY_PARAMETERS + DEFAULT_CREATE_PARAMETERS.keys).freeze

    # Update parameters need to always include any List types, even if they are empty,
    # otherwise the API will return a NoneType error.
    DEFAULT_UPDATE_PARAMETERS = {
      constraints: [],
      goal: [],
      tools: []
    }.freeze
    REQUIRED_UPDATE_PARAMETERS = DEFAULT_UPDATE_PARAMETERS.keys.freeze

    def valid_parameters(method:, parameters:)
      parameters = default_parameters(method: method, parameters: parameters)
      validate_presence(method: method, parameters: parameters)
      validate_arrays(parameters: parameters)
      parameters
    end

    def default_parameters(method:, parameters:)
      case method
      when :create then DEFAULT_CREATE_PARAMETERS.merge(parameters)
      when :update then DEFAULT_UPDATE_PARAMETERS.merge(parameters)
      end
    end

    def validate_presence(method:, parameters:)
      required_parameters = case method
                            when :create then REQUIRED_CREATE_PARAMETERS
                            when :update then REQUIRED_UPDATE_PARAMETERS
                            end
      required_parameters.each do |key|
        raise ArgumentError, "#{key} is required" unless parameters[key.to_sym]
      end
    end

    def validate_arrays(parameters:)
      ARRAY_PARAMETERS.each do |key|
        raise ArgumentError, "#{key} must be an array" unless parameters[key.to_sym].is_a?(Array)
      end
    end
  end
end
