require 'spec_helper'

RSpec.describe Togls::ToggleRegistry do
  let!(:feature_repository) do
    Togls::FeatureRepository.new([Togls::FeatureRepositoryDrivers::InMemoryDriver.new])
  end

  let!(:toggle_repository) do
    Togls::ToggleRepository.new([Togls::ToggleRepositoryDrivers::InMemoryDriver.new],
                                feature_repository)
  end

  subject { Togls::ToggleRegistry.new(feature_repository, toggle_repository) }

  describe "#initalize" do
    it "saves the given feature repository" do
      repository = subject.instance_variable_get(:@feature_repository)
      expect(repository).to eql feature_repository
    end

    it 'saves the given toggle repository' do
      repository = subject.instance_variable_get(:@toggle_repository)
      expect(repository).to eql toggle_repository
    end
  end

  describe "#expand" do
    it "instance evals the provided block" do
      expect(subject).to receive(:instance_eval)
      subject.expand do
        feature(:bar, "some other desc").on
      end
    end

    it "returns the feature toggle repository" do
      block = Proc.new {}
      expect(subject.expand(&block)).to eq(subject)
    end
  end

  describe "#feature" do
    it "verifies that the feature is unique" do
      Togls.default_feature_target_type :hoopty
      expect(subject).to receive(:verify_uniqueness_of_feature).with(:some_key)
      subject.feature(:some_key, "description")
    end

    it "creates a new feature object with the passed key and target type" do
      desc = double('feature desc')
      key = 'some_key'
      target_type = :some_target_type
      feature = Togls::Feature.new('some_feature_key', 'Some Feature Desc', :some_target_type)
      expect(Togls::Feature).to receive(:new).with(key, desc, target_type).and_return(feature)
      subject.feature(key, desc, target_type: :some_target_type)
    end

    it "creates a feature toggle with the created feature" do
      desc = double('feature desc')
      key = "some_key"
      feature = double(Togls::Feature)
      feature = Togls::Feature.new(:somekey, "some description", Togls::TargetTypes::NONE)
      allow(Togls::Feature).to receive(:new).and_return(feature)
      expect(Togls::Toggle).to receive(:new).with(feature).and_return(Togls::Toggle.new(feature))
      subject.feature(key, desc)
    end

    it "store the toggle" do
      toggle = double('toggle')
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      desc = double('feature desc')
      key = "some_key"
      allow(Togls::Feature).to receive(:new)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      expect(toggle_repository).to receive(:store).with(toggle)
      subject.feature(key, desc)
    end

    it "constructs a toggler" do
      Togls.default_feature_target_type :hoopty
      key = "some_key"
      desc = double('feature desc')
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      toggle = double('toggle')
      allow(toggle_repository).to receive(:store)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      expect(Togls::Toggler).to receive(:new).with(toggle_repository, toggle)
      subject.feature(key, desc)
    end

    it "returns the created toggler" do
      Togls.default_feature_target_type :hoopty
      key = "some_key"
      desc = double('feature desc')
      feature = Togls::Feature.new(key, desc, Togls::TargetTypes::NONE)
      toggle = Togls::Toggle.new(feature)
      toggler = double('toggler')
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      allow(Togls::Toggler).to receive(:new).and_return(toggler)
      expect(subject.feature(key, desc)).to eq(toggler)
    end
  end

  describe "#verify_uniqueness_of_feature" do
    context "when the feature exists" do
      it "raises a feature has already been defined error" do
        allow(feature_repository).to receive(:include?).and_return true
        expect { subject.verify_uniqueness_of_feature(:some_key) }
          .to raise_error Togls::FeatureAlreadyDefined, "Feature identified by 'some_key' has already been defined"
      end
    end

    context "when the feature doesn't exist" do
      it "does NOT raise a exception" do
        allow(feature_repository).to receive(:include?).and_return false
        expect { subject.verify_uniqueness_of_feature(:some_key) }.not_to raise_error
      end
    end
  end

  describe "#get" do
    it "attempts to fetch the toggle from the toggle repository" do
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      expect(toggle_repository).to receive(:get).with("some key")
      subject.get("some key")
    end

    it "returns the obtained feature toggle" do
      toggle = double('toggle')
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      allow(toggle_repository).to receive(:get).and_return(toggle)
      expect(subject.get("some key")).to eq(toggle)
    end
  end
end
