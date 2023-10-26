module SuperAGI
  class Agent

    # '{"loc":["body","constraints"],"msg":"field
    #     required","type":"value_error.missing"},{"loc":["body","tools"],"msg":"field
    #     required","type":"value_error.missing"},{"loc":["body","iteration_interval"],"msg":"field
    #     required","type":"value_error.missing"},{"loc":["body","max_iterations"],"msg":"field
    #     required","type":"value_error.missing"}]}'


    def initialize(client:)
      @client = client
    end

    def create(parameters:)
      parameters = valid_parameters(parameters: parameters)
      @client.json_post(path: "/agent", parameters: parameters)
    end

    # def update(id:, parameters: {})
    # end

    # def pause(id:)
    # end

    # def resume(id:)
    # end

    # def delete(id:)
    # end

    # def status(id:)
    # end

    # def resources(id:)
    # end

    private

    DEFAULT_PARAMETERS = {
      agent_workflow: "Goal Based Workflow",
      model: "gpt-4",
    }.freeze
    ARRAY_PARAMETERS = %w[
      constraints
      goal
      tools
    ].freeze
    REQUIRED_PARAMETERS = (%w[
      description
      instruction
      iteration_interval
      max_iterations
      name
    ] + ARRAY_PARAMETERS +  DEFAULT_PARAMETERS.keys).freeze

    def valid_parameters(parameters:)
      parameters = DEFAULT_PARAMETERS.merge(parameters)
      validate_presence(parameters: parameters)
      validate_arrays(parameters: parameters)
      parameters
    end

    def validate_presence(parameters:)
      REQUIRED_PARAMETERS.each do |key|
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
