RSpec.describe SuperAGI::Client do
  context "with clients with different secret keys" do
    before do
      SuperAGI.configure do |config|
        config.extra_headers = { "test" => "X-Default" }
      end
    end

    after do
      # Necessary otherwise the dummy config bleeds into other specs
      # that actually hit the API and causes them to fail.
      SuperAGI.configure do |config|
        config.extra_headers = nil
      end
    end

    let!(:c0) { SuperAGI::Client.new }
    let!(:c1) do
      SuperAGI::Client.new(
        secret_key: "secret_key1",
        request_timeout: 60,
        uri_base: "https://oai.hconeai.com/",
        extra_headers: { "test" => "X-Test" }
      )
    end
    let!(:c2) do
      SuperAGI::Client.new(
        secret_key: "secret_key2",
        request_timeout: 1,
        uri_base: "https://example.com/"
      )
    end

    it "does not confuse the clients" do
      expect(c0.secret_key).to eq(ENV.fetch("SUPERAGI_SECRET_KEY", "dummy-token"))
      expect(c0.request_timeout).to eq(SuperAGI::Configuration::DEFAULT_REQUEST_TIMEOUT)
      expect(c0.uri_base).to eq(SuperAGI::Configuration::DEFAULT_URI_BASE)
      expect(c0.send(:headers).values).to include(c0.secret_key)
      expect(c0.send(:conn).options.timeout).to eq(SuperAGI::Configuration::DEFAULT_REQUEST_TIMEOUT)
      expect(c0.send(:uri, path: "")).to include(SuperAGI::Configuration::DEFAULT_URI_BASE)
      expect(c0.send(:headers).values).to include("X-Default")
      expect(c0.send(:headers).values).not_to include("X-Test")

      expect(c1.secret_key).to eq("secret_key1")
      expect(c1.request_timeout).to eq(60)
      expect(c1.uri_base).to eq("https://oai.hconeai.com/")
      expect(c1.send(:headers).values).to include(c1.secret_key)
      expect(c1.send(:conn).options.timeout).to eq(60)
      expect(c1.send(:uri, path: "")).to include("https://oai.hconeai.com/")
      expect(c1.send(:headers).values).not_to include("X-Default")
      expect(c1.send(:headers).values).to include("X-Test")

      expect(c2.secret_key).to eq("secret_key2")
      expect(c2.request_timeout).to eq(1)
      expect(c2.uri_base).to eq("https://example.com/")
      expect(c2.send(:headers).values).to include(c2.secret_key)
      expect(c2.send(:conn).options.timeout).to eq(1)
      expect(c2.send(:uri, path: "")).to include("https://example.com/")
      expect(c2.send(:headers).values).to include("X-Default")
      expect(c2.send(:headers).values).not_to include("X-Test")
    end

    context "hitting other classes" do
      let(:parameters) do
        {
          agent_workflow: "Goal Based Workflow",
          constraints: [],
          description: "Generates motivational quotes",
          goal: ["I need a motivational quote"],
          instruction: ["Write a new motivational quote"],
          iteration_interval: 500,
          max_iterations: 2,
          model: "gpt-4",
          name: "Motivational Quote Generator",
          tools: []
        }
      end

      after do
        c0.agent.create(parameters: parameters)
        c1.agent.create(parameters: parameters)
        c2.agent.create(parameters: parameters)
      end

      it "does not confuse the clients" do
        expect(c0).to receive(:json_post).with(path: "/agent", parameters: parameters).once
        expect(c1).to receive(:json_post).with(path: "/agent", parameters: parameters).once
        expect(c2).to receive(:json_post).with(path: "/agent", parameters: parameters).once
      end
    end
  end
end
