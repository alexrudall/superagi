RSpec.describe SuperAGI::Client do
  describe "#agent", :vcr do
    describe "#create" do
      let(:cassette) { "agent create" }
      let(:parameters) do
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
      let(:response) { SuperAGI::Client.new.agent.create(parameters: parameters) }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response["agent_id"]).to be_a(Integer)
        end
      end
    end
  end
end
