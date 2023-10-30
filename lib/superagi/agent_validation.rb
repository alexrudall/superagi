module SuperAGI
  module AgentValidation
    private

    ARRAY_CREATE_PARAMETERS = %w[
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
    ] + ARRAY_CREATE_PARAMETERS + DEFAULT_CREATE_PARAMETERS.keys).freeze

    # Update parameters need to always include any List types, even if they are empty,
    # otherwise the API will return a NoneType error.
    DEFAULT_UPDATE_PARAMETERS = {
      constraints: [],
      goal: [],
      tools: []
    }.freeze
    REQUIRED_UPDATE_PARAMETERS = DEFAULT_UPDATE_PARAMETERS.keys.freeze

    REQUIRED_RESOURCES_PARAMETERS = %w[run_ids].freeze

    def valid_parameters(method:, parameters:)
      parameters = default_parameters(method: method, parameters: parameters)
      validate_presence(method: method, parameters: parameters)
      validate_arrays(method: method, parameters: parameters)
      parameters
    end

    def default_parameters(method:, parameters:)
      case method
      when :create then DEFAULT_CREATE_PARAMETERS.merge(parameters)
      when :update then DEFAULT_UPDATE_PARAMETERS.merge(parameters)
      else parameters
      end
    end

    def validate_presence(method:, parameters:)
      required_parameters = case method
                            when :create then REQUIRED_CREATE_PARAMETERS
                            when :update then REQUIRED_UPDATE_PARAMETERS
                            when :resources then REQUIRED_RESOURCES_PARAMETERS
                            end
      required_parameters.each do |key|
        raise ArgumentError, "#{key} is required" unless parameters[key.to_sym]
      end
    end

    def validate_arrays(method:, parameters:)
      array_parameters = case method
                         when :create, :update then ARRAY_CREATE_PARAMETERS
                         when :resources then REQUIRED_RESOURCES_PARAMETERS
                         end
      array_parameters.each do |key|
        raise ArgumentError, "#{key} must be an array" unless parameters[key.to_sym].is_a?(Array)
      end
    end
  end
end
