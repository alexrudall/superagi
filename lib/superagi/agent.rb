module SuperAGI
  class Agent
    include SuperAGI::AgentValidation

    def initialize(client:)
      @client = client
    end

    def create(parameters:)
      parameters = valid_parameters(method: :create, parameters: parameters)
      @client.json_post(path: "/agent", parameters: parameters)
    end

    def update(id:, parameters:)
      parameters = valid_parameters(method: :update, parameters: parameters)
      @client.json_put(path: "/agent/#{id}", parameters: parameters)
    end

    def run(id:)
      @client.json_post(path: "/agent/#{id}/run", parameters: {})
    end

    def pause(id:)
      @client.json_post(path: "/agent/#{id}/pause", parameters: {})
    end

    def resume(id:)
      @client.json_post(path: "/agent/#{id}/resume", parameters: {})
    end

    def status(id:)
      @client.json_post(path: "/agent/#{id}/run-status", parameters: {})
    end

    def resources(parameters:)
      parameters = valid_parameters(method: :resources, parameters: parameters)
      @client.json_post(path: "/agent/resources/output", parameters: parameters)
    end
  end
end
