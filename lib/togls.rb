require "togls/version"
require "togls/errors"
require "togls/helpers"
require "togls/toggle_repository_drivers"
require "togls/toggle_repository_drivers/in_memory_driver"
require "togls/toggle_repository_drivers/env_override_driver"
require "togls/feature_repository_drivers"
require "togls/feature_repository_drivers/in_memory_driver"
require "togls/rule_repository_drivers"
require "togls/rule_repository_drivers/in_memory_driver"
require "togls/toggler"
require "togls/feature_toggle_registry"
require "togls/feature_repository"
require "togls/rule_repository"
require "togls/toggle_repository"
require "togls/feature"
require "togls/toggle"
require "togls/null_toggle"
require "togls/rule"
require "togls/rules"
require "logger"

module Togls
  def self.features(&block)
    if @feature_toggle_registry
      if block.nil?
        return @feature_toggle_registry
      else
        @feature_toggle_registry.expand(&block)
      end
    else
      if block.nil?
        raise Togls::NoFeaturesError, "Need to define features before you can get them"
      else
        @feature_toggle_registry = FeatureToggleRegistry.create(&block)
      end
    end
  end

  def self.features=(feature_toggle_registry)
    @feature_toggle_registry = feature_toggle_registry
  end
  
  def self.feature(key)
    return @feature_toggle_registry.get(key)
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
