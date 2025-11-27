## 0.2.0

### Breaking Changes

* **PinpadExtraKey**: Changed `child` property to `builder` function with signature `Widget Function(bool isPressed, bool isPointed)` for proper press/point state handling
* **PinpadKey**: Changed `child` property to `builder` function with signature `Widget Function(bool isPressed, bool isPointed)`

### Bug Fixes

* Fixed null check error when interrupting idle animation in `PinIndicatorAnimationController`
* Fixed `LateInitializationError` crash in `SuccessKickPinIndicator` when widget disposed before animation initialized
* Fixed `LateInitializationError` crash in `SuccessFillLastPinIndicator` when widget disposed quickly
* Fixed `LateInitializationError` crash in `LoadingTravelPinIndicator` when widget disposed during initialization
* Fixed memory leak in `SuccessCollapsePinIndicator` where anonymous `AnimationController` was created but never disposed
* Fixed memory leak in `LoadingCollapsePinIndicator` with same anonymous controller issue
* Fixed `stop()` method ignoring `ignoreOnInterruptCallbacks` flag for currently playing animation
* Fixed `animateIdle()` calling `onComplete` callback on every repeat iteration instead of only the last one
* Fixed wrong decoration used for disabled pinpad keys (was using default instead of disabled)
* Fixed `PinIndicatorAnimationController` being unnecessarily created on every widget build when controller is null
* Fixed potential ID collision in animation identifier generation when multiple animations queued in same microsecond
* Fixed `initializeVibration()` throwing error when called multiple times

### Improvements

* Added `mounted` checks in wave animation widgets to prevent crashes when widget is disposed during animation
* Improved `PinpadKeyWrapper` to provide both `isPressed` and `isPointed` states to builder
* Updated `PointDetectorBuilder` with proper pointer exit handling and improved state management
* Refactored `PressDetectorBuilder` to call callbacks before `setState` for more predictable timing
* `PinpadTextKey` now requires both `isPressed && isPointed` to show pressed style (better UX when dragging finger)

### Documentation

* Added missing `Loading Wave Fade` animation to README animations table
* Added Table of Contents to README for easier navigation
* Fixed invalid Dart syntax in README code examples (changed `=` to `:` for named parameters)
* Fixed multiple typos: "myDecoratino", "contoller", "onInterruct", "Fell free", "backed", "smother", "stoped", "imminently", "staff"
* Fixed incomplete sentence in "Animations priority" section
* Fixed grammar issues in README

### Dependencies

* Updated `vibration` from ^2.0.0 to ^3.1.4
* Updated `flutter_lints` from ^4.0.0 to ^6.0.0

### Other

* Removed deprecated `package_api_docs` lint rule from analysis_options.yaml
* Removed unnecessary `library pin_ui;` declaration
* Replaced deprecated `withOpacity()` with `withValues(alpha:)` for Flutter 3.27+ compatibility

## 0.1.0+1

* Add another example project link

## 0.1.0

* Update README
* Fix controller's queue logic  
* Add loading wave fade animation

## 0.0.1

* Initial release: Pinpad and PinIndicator (24 animations)
