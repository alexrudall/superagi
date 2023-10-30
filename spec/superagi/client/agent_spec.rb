RSpec.describe SuperAGI::Client do
  describe "#agent", :vcr do
    let(:create_params) do
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
        SuperAGI::Client.new.agent.create(parameters: create_params)
      end["agent_id"]
    end
    let(:paused_agent_id) do
      VCR.use_cassette("#{cassette} setup paused agent") do
        SuperAGI::Client.new.agent.pause(id: agent_id)
      end
      agent_id
    end
    let(:run_id) do
      VCR.use_cassette("#{cassette} setup run") do
        SuperAGI::Client.new.agent.run(id: agent_id)
      end["run_id"]
    end

    describe "#create" do
      let(:cassette) { "agent create" }
      let(:response) { SuperAGI::Client.new.agent.create(parameters: create_params) }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response["agent_id"]).to be_a(Integer)
        end
      end
    end

    describe "#update" do
      let(:update_params) { { name: "Updated Name" } }
      let(:cassette) { "agent update" }
      let(:response) { SuperAGI::Client.new.agent.update(id: agent_id, parameters: update_params) }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response["agent_id"]).to be_a(Integer)
        end
      end
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
      let(:cassette) { "agent pause" }
      let(:response) { SuperAGI::Client.new.agent.pause(id: agent_id) }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response["result"]).to eq("success")
        end
      end
    end

    describe "#resume" do
      let(:cassette) { "agent resume" }
      let(:response) { SuperAGI::Client.new.agent.resume(id: paused_agent_id) }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response["result"]).to eq("success")
        end
      end
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

    describe "#resources" do
      let(:cassette) { "agent resources" }
      let(:response) { SuperAGI::Client.new.agent.resources(parameters: { run_ids: [run_id] }) }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response).to be_a(Hash)
        end
      end
    end
  end
end
