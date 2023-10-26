RSpec.describe SuperAGI do
  it "has a version number" do
    expect(SuperAGI::VERSION).not_to be nil
  end

  describe "#configure" do
    let(:secret_key) { "abc123" }
    let(:api_version) { "v2" }
    let(:custom_uri_base) { "ghi789" }
    let(:custom_request_timeout) { 25 }
    let(:extra_headers) { { "User-Agent" => "SuperAGI Ruby Gem #{SuperAGI::VERSION}" } }

    before do
      SuperAGI.configure do |config|
        config.secret_key = secret_key
        config.api_version = api_version
        config.extra_headers = extra_headers
      end
    end

    it "returns the config" do
      expect(SuperAGI.configuration.secret_key).to eq(secret_key)
      expect(SuperAGI.configuration.api_version).to eq(api_version)
      expect(SuperAGI.configuration.uri_base).to eq("https://app.superagi.com/api/")
      expect(SuperAGI.configuration.request_timeout).to eq(120)
      expect(SuperAGI.configuration.extra_headers).to eq(extra_headers)
    end

    context "without an secret key" do
      let(:secret_key) { nil }

      it "raises an error" do
        expect { SuperAGI::Client.new.completions }.to raise_error(SuperAGI::ConfigurationError)
      end
    end

    context "with custom timeout and uri base" do
      before do
        SuperAGI.configure do |config|
          config.uri_base = custom_uri_base
          config.request_timeout = custom_request_timeout
        end
      end

      it "returns the config" do
        expect(SuperAGI.configuration.secret_key).to eq(secret_key)
        expect(SuperAGI.configuration.api_version).to eq(api_version)
        expect(SuperAGI.configuration.uri_base).to eq(custom_uri_base)
        expect(SuperAGI.configuration.request_timeout).to eq(custom_request_timeout)
        expect(SuperAGI.configuration.extra_headers).to eq(extra_headers)
      end
    end
  end
end
