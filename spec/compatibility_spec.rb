RSpec.describe "compatibility" do
  context "for moved constants" do
    describe "::Ruby::SuperAGI::VERSION" do
      it "is mapped to ::SuperAGI::VERSION" do
        expect(Ruby::SuperAGI::VERSION).to eq(SuperAGI::VERSION)
      end
    end

    describe "::Ruby::SuperAGI::Error" do
      it "is mapped to ::SuperAGI::Error" do
        expect(Ruby::SuperAGI::Error).to eq(SuperAGI::Error)
        expect(Ruby::SuperAGI::Error.new).to be_a(SuperAGI::Error)
        expect(SuperAGI::Error.new).to be_a(Ruby::SuperAGI::Error)
      end
    end

    describe "::Ruby::SuperAGI::ConfigurationError" do
      it "is mapped to ::SuperAGI::ConfigurationError" do
        expect(Ruby::SuperAGI::ConfigurationError).to eq(SuperAGI::ConfigurationError)
        expect(Ruby::SuperAGI::ConfigurationError.new).to be_a(SuperAGI::ConfigurationError)
        expect(SuperAGI::ConfigurationError.new).to be_a(Ruby::SuperAGI::ConfigurationError)
      end
    end

    describe "::Ruby::SuperAGI::Configuration" do
      it "is mapped to ::SuperAGI::Configuration" do
        expect(Ruby::SuperAGI::Configuration).to eq(SuperAGI::Configuration)
        expect(Ruby::SuperAGI::Configuration.new).to be_a(SuperAGI::Configuration)
        expect(SuperAGI::Configuration.new).to be_a(Ruby::SuperAGI::Configuration)
      end
    end
  end
end
