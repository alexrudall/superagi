RSpec.describe SuperAGI::Client do
  describe "#agent", :vcr do
    let(:create_parameters) do
      {
        name: "Motivational Quote Generator",
        description: "Generates motivational quotes",
        goal: ["I need a motivational quote"],
        instruction: ["Write a new motivational quote"],
        iteration_interval: 500,
        max_iterations: 2,
        constraints: [],
        tools: []
      }
    end

    describe "#create" do
      let(:cassette) { "agent create" }
      let(:response) { SuperAGI::Client.new.agent.create(parameters: create_parameters) }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response["agent_id"]).to be_a(Integer)
        end
      end
    end

    describe "#status" do
      let(:agent_id) do
        VCR.use_cassette("#{cassette} setup") do
          SuperAGI::Client.new.agent.create(parameters: create_parameters)
        end["agent_id"]
      end
      let(:cassette) { "agent status" }
      let(:response) { SuperAGI::Client.new.agent.status(id: agent_id) }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response.first["status"]).to eq("CREATED")
        end
      end
    end
  end
end
