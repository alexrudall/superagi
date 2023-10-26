RSpec.describe SuperAGI::HTTP do
  describe "with an aggressive timeout" do
    let(:timeout_errors) { [Faraday::ConnectionFailed, Faraday::TimeoutError] }
    let(:timeout) { 0 }

    # We disable VCR and WebMock for timeout specs, otherwise VCR will return instant
    # responses when using the recorded responses and the specs will fail incorrectly.
    # The timeout is set to 0, so these specs will never actually hit the API and
    # therefore are still fast and deterministic.
    before do
      VCR.turn_off!
      WebMock.allow_net_connect!
      SuperAGI.configuration.request_timeout = timeout
    end

    after do
      VCR.turn_on!
      WebMock.disable_net_connect!
      SuperAGI.configuration.request_timeout = SuperAGI::Configuration::DEFAULT_REQUEST_TIMEOUT
    end

    # describe ".get" do
    #   let(:response) { SuperAGI::Client.new.agent.status(id:) }

    #   it "times out" do
    #     expect { response }.to raise_error do |error|
    #       expect(timeout_errors).to include(error.class)
    #     end
    #   end
    # end

    describe ".json_post" do
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

      it "times out" do
        expect { response }.to raise_error do |error|
          expect(timeout_errors).to include(error.class)
        end
      end
    end

    # describe ".delete" do
    #   let(:response) do
    #     SuperAGI::Client.new.agent.delete(id:)
    #   end

    #   it "times out" do
    #     expect { response }.to raise_error do |error|
    #       expect(timeout_errors).to include(error.class)
    #     end
    #   end
    # end
  end

  describe ".to_json" do
    context "with a jsonl string" do
      let(:body) { "{\"prompt\":\":)\"}\n{\"prompt\":\":(\"}\n" }
      let(:parsed) { SuperAGI::Client.new.send(:to_json, body) }

      it { expect(parsed).to eq([{ "prompt" => ":)" }, { "prompt" => ":(" }]) }
    end
  end

  describe ".uri" do
    let(:path) { "/agent" }
    let(:uri) { SuperAGI::Client.new.send(:uri, path: path) }

    it { expect(uri).to eq("https://app.superagi.com/api/v1/agent") }

    context "uri_base without trailing slash" do
      before do
        SuperAGI.configuration.uri_base = "https://app.superagi.com/api"
      end

      after do
        SuperAGI.configuration.uri_base = "https://app.superagi.com/api/"
      end

      it { expect(uri).to eq("https://app.superagi.com/api/v1/agent") }
    end
  end

  describe ".headers" do
    before do
      SuperAGI.configuration.api_type = :nil
    end

    let(:headers) { SuperAGI::Client.new.send(:headers) }

    it {
      expect(headers).to eq({ "X-api-key" => SuperAGI.configuration.secret_key,
                              "Content-Type" => "application/json" })
    }
  end
end
