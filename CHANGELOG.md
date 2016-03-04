# ChangeLog

The following are lists of the notable changes included with each release.
This is intended to help keep people informed about notable changes between
versions, as well as provide a rough history.

#### Next Release

* Added Togls::TestToggleRegistry class for initializing test state
* Added ability to create additional toggle registries

### v2.1.1

* Fixed issue #21, env variable override wasn't falling through to in
  code defined memory value.

### v2.1.0

* Fixed #19, exceptions happened on evaluation after setting
  `Togls.features = nil`

### v2.0.0

* Add ability to create empty feature toggle set via `Togls.features`
* Add toggle definition expansion with multiple `Togls.features` blocks
* Add set FeatureToggleRegistry instance, `Togls.features = toggle_registry`
* Change `Togls.features` to return FeatureToggleRegistry instance
  rather than an Array of Toggle objects.

#### v1.1.0

* Add `off?` method for asking if a defined feature is off
* Add feature toggle overrides
* Rearchitect to support concept of repositories and datastores allowing
  further growth in the future

#### v1.0.0

* Require human readable description to define a feature toggle
* Add rake task that outputs all the feature toggles states (on, off, ? -
  unknown due to Compex Rule), keys, and human readable descritpions

#### v0.1.0

* Add concept of Groups as a provided rule
* Add concept of Rules and Custom Rules, allowing users to have more dynamic
  feature toggles
* Add basic feature toggles able to be switched on/off