require 'spec_helper'

RSpec.describe Togls::Rule do
  describe '.title' do
    it 'raises NotImplemented exception' do
      klass = Class.new(Togls::Rule)
      expect { klass.title }.to raise_error(Togls::NotImplemented)
    end
  end

  describe '.description' do
    it 'raises NotImplemented exception' do
      klass = Class.new(Togls::Rule)
      expect { klass.description }.to raise_error(Togls::NotImplemented)
    end
  end

  describe '.target_type' do
    it 'returns the default of not set' do
      klass = Class.new(Togls::Rule)
      expect(klass.target_type).to eq(Togls::TargetTypes::NOT_SET)
    end
  end

  describe '#initialize' do
    context 'when given initialization data' do
      context 'when given target type' do
        it 'assigns the given type_id to an instance variable' do
          rule = Togls::Rule.new(:hoopty, double, target_type: :foo)
          expect(rule.instance_variable_get(:@type_id)).to eq(:hoopty)
        end

        it 'assigns the given data to an instance variable' do
          data = double('data')
          rule = Togls::Rule.new(:hoopty, data, target_type: :foo)
          expect(rule.instance_variable_get(:@data)).to eq(data)
        end

        it 'assigns the given target type to an instance variable' do
          rule = Togls::Rule.new(:hoopty, target_type: :some_target_type)
          expect(rule.instance_variable_get(:@target_type)).to eq(:some_target_type)
        end
      end

      context 'when not given target type' do
        context 'when rule type did not set target type' do
          it 'raises target type missing exception' do
            expect {
              rule = Togls::Rule.new(:hoopty)
            }.to raise_error(Togls::RuleMissingTargetType)
          end
        end

        context 'when rule type did set target type' do
          it 'return the rule types target type' do
            rule_klass = Class.new(Togls::Rule) do
              def self.target_type
                :foo
              end
            end

            data = double('data')
            rule = rule_klass.new(:hoopty, data)
            expect(rule.target_type).to eq(:foo)
          end
        end
      end
    end

    context 'when not given initialization data' do
      context 'when given target type' do
        it 'assigns the data instance variable to nil' do
          rule = Togls::Rule.new(:hoopty, target_type: :foo)
          expect(rule.instance_variable_get(:@data)).to be_nil
        end

        it 'assigns the given target type to an instance variable' do
          rule = Togls::Rule.new(:hoopty, target_type: :some_target_type)
          expect(rule.instance_variable_get(:@target_type)).to eq(:some_target_type)
        end
      end

      context 'when not given target type' do
        context 'when rule type did not set target type' do
          it 'raises target type missing exception' do
            expect {
              rule = Togls::Rule.new(:hoopty)
            }.to raise_error(Togls::RuleMissingTargetType)
          end
        end

        context 'when rule type did set target type' do
          it 'return the rule types target type' do
            rule_klass = Class.new(Togls::Rule) do
              def self.target_type
                :foo
              end
            end

            rule = rule_klass.new(:hoopty)
            expect(rule.target_type).to eq(:foo)
          end
        end
      end
    end
  end

  describe "#run" do
    it "raises NotImplemented exception" do
      rule = Togls::Rule.new(:hoopty, target_type: :foo)
      expect { rule.run(double('feature key')) }
        .to raise_error(Togls::NotImplemented)
    end
  end

  describe "#id" do
    it "gets the sha1 of the rule klass with the initializer data" do
      rule = Togls::Rules::Boolean.new(:boolean, true)
      expect(Togls::Helpers).to receive(:sha1).with(Togls::Rules::Boolean, true)
      rule.id
    end

    it "returns the sha1 it obtained" do
      rule = Togls::Rules::Boolean.new(:boolean, true)
      sha1 = double('sha1')
      allow(Togls::Helpers).to receive(:sha1).and_return(sha1)
      expect(rule.id).to eq(sha1)
    end
  end

  describe "#data" do
    it "returns the data it was initially initialized with" do
      rule = Togls::Rule.new(:hoopty, "test value", target_type: :foo)
      expect(rule.data).to eq("test value")
    end
  end

  describe '#target_type' do
    context 'when the rule instance has a target type' do
      it 'returns the rule instances target type' do
        rule = Togls::Rule.new(:jacked, target_type: :hoopty)
        expect(rule.target_type).to eq(:hoopty)
      end
    end

    context 'when the rule instance has NO target type or is NOT_SET' do
      context 'when the rule type target type is NOT nil' do
        it 'returns the rule type target type' do
          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :woot_woot
            end
          end

          rule = rule_klass.new(:jacked, 'some data')
          expect(rule.target_type).to eq(:woot_woot)
        end
      end
    end
  end

  describe '#missing_target_type?' do
    context 'when target type is set' do
      it 'returns false' do
        rule = Togls::Rule.new(:hoopty, target_type: :foo)
        expect(rule.missing_target_type?).to eq(false)
      end
    end

    context 'when target type is not set' do
      it 'returns true' do
        rule = Togls::Rule.new(:hoopty, target_type: :hoopty)
        rule.instance_variable_set(:@target_type, Togls::TargetTypes::NOT_SET)
        expect(rule.missing_target_type?).to eq(true)
      end
    end

    context 'when target type is nil' do
      it 'returns true' do
        rule = Togls::Rule.new(:hoopty, target_type: :hoopty)
        rule.instance_variable_set(:@target_type, nil)
        expect(rule.missing_target_type?).to eq(true)
      end
    end
  end
end
