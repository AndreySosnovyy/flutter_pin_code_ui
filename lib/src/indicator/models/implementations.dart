// TODO(Sosnovyy): update instructions
// To add a new animation, follow one of the instructions below:
//
// In case you want to add a new animation with already existing type:
// 1) Add a new enum value (yours animation name) to corresponding enum
//    implementing PinAnimationImplementation.
// 2) Create a new class that extends PinIndicatorAnimation where you configure
//    your new animation.
// 3) Create a new class in lib/src/widgets/animated_pin_indicators/ folder
//    with your animation visual implementation.
// 4) Add newly created class to static parsing method.
// 5) Add your animation to pin_indicator.dart in general switch statement
//    from where it will be displayed when called.
//
// In case you want to add a new type animation:
// 1) Add your new type in PinAnimationTypes enum.
// 2) Add a new enum class which implements PinAnimationImplementation.
// 3) Add a newly added type in static parsing method fromImpl.
// 4) Add a new method to PinIndicatorAnimationController that will be called
//    when you want to display your new animation.
// 5) (Optional) Add a getter to check if animation with your type is playing
// to PinIndicatorAnimationController (isAnimating<YourNewTypeName>)
// 6) Go through all steps from the instruction above.
//

enum PinAnimationTypes { input, loading, success, error, clear, erase, idle }

sealed class PinAnimationImplementation {}

enum PinInputAnimation implements PinAnimationImplementation {
  inflate,
  fall,
  fade,
}

enum PinLoadingAnimation implements PinAnimationImplementation {
  jump,
  // wave,
  // spin,
  travel,
}

enum PinSuccessAnimation implements PinAnimationImplementation {
  collapse,
  fill,
  // kick,
}

enum PinErrorAnimation implements PinAnimationImplementation {
  shake,
  // jiggle,
  // brownian,
  blink,
}

enum PinClearAnimation implements PinAnimationImplementation {
  drop,
  fade,
}

enum PinEraseAnimation implements PinAnimationImplementation {
  deflate,
  takeOff,
  fade,
}

enum PinIdleAnimation implements PinAnimationImplementation {
  wave,
  pulse,
  flash,
}
