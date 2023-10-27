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
    let(:agent_id) do
      VCR.use_cassette("#{cassette} setup agent") do
        SuperAGI::Client.new.agent.create(parameters: create_parameters)
      end["agent_id"]
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

    describe "#update" do
      pending
    end

    describe "#run" do
      let(:cassette) { "agent run" }
      let(:response) { SuperAGI::Client.new.agent.run(id: agent_id) }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response["run_id"]).to be_an(Integer)
        end
      end
    end

    describe "#pause" do
      pending
    end

    describe "#resume" do
      pending
    end

    describe "#status" do
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
