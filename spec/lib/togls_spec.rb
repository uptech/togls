require_relative '../spec_helper'

describe Togls do
  describe ".features" do
    context "when features have NOT been defined" do
      context "when given a block" do
        it "creates a new feature toggle registry with passed block" do
          b = Proc.new {}
          expect(Togls::FeatureToggleRegistry).to receive(:create).and_yield(&b)
          Togls.features(&b)
        end
      end
      
      context "when NOT given a block" do
        it "raises an error telling the user they must first define features" do
          expect { Togls.features }.to raise_error(Togls::NoFeaturesError)
        end
      end
    end

    context "when features HAVE been defined" do
      before do
        @registry = Togls.features do
          feature(:test1, "test1 readable description").on
          feature(:test2, "test2 readable description").off
          feature(:test3, "test3 readable description")
        end
      end

      context "when given a block" do
        it "expands the feature registry with a new block" do
          b = Proc.new {}
          expect(@registry).to receive(:expand)
          Togls.features(&b)
        end
      end

      context "when NOT given a block" do
        it "returns the feature toggle registry" do
          block = Proc.new {}
          feature_toggle_registry = Togls.features(&block)
          expect(Togls.features).to eq(feature_toggle_registry)
        end
      end
    end
  end

  describe ".features=" do
    it "assigns the given feature toggle registry to @feature_toggle_registry" do
      feature_toggle_registry = double('feature toggle registry')
      Togls.features = feature_toggle_registry
      expect(Togls.features).to eq(feature_toggle_registry)
    end
  end

  describe ".feature" do
    it "returns the feature toggle identified by the key" do
      feature_registry = instance_double Togls::FeatureToggleRegistry 
      Togls.instance_variable_set(:@feature_toggle_registry, feature_registry)
      expect(feature_registry).to receive(:get).with("key")
      Togls.feature("key")
    end
  end

  describe ".logger" do
    it "memoizes a new logger instance" do
      logger = double('logger')
      Togls.instance_variable_set(:@logger, nil)
      allow(Logger).to receive(:new).with(STDOUT).and_return(logger)
      expect(Togls.logger).to eq(logger)
      expect(Togls.logger).to eq(logger)
    end
  end
end
