// ignore_for_file: public_member_api_docs

/// Empty class to be implemented by other enums, so they have one type.
/// Necessary for parsing them when a developer call animations from controller.
sealed class PinAnimationImplementation {}

/// Enum with all input animations that can be played via controller in Pin indicator.
///
/// Input animations are used when user enters pin code's symbol.
enum PinInputAnimation implements PinAnimationImplementation {
  inflate,
  fall,
  fade,
}

/// Enum with all loading animations that can be played via controller in Pin indicator.
///
/// Loading animations are played when you need to delay async operations or
/// show visual representation of loading state.
enum PinLoadingAnimation implements PinAnimationImplementation {
  jump,
  waveInflate,
  waveDeflate,
  // waveFade,
  collapse,
  travel,
}

/// Enum with all success animations that can be played via controller in Pin indicator.
///
/// Success animations are used when user enters correct pin code to delay
/// async operations and show that pin code entering attempt was successful.
enum PinSuccessAnimation implements PinAnimationImplementation {
  collapse,
  fill,
  fillLast,
  kick,
}

/// Enum with all error animations that can be played via controller in Pin indicator.
///
/// Error animations are used when user enters wrong pin code.
enum PinErrorAnimation implements PinAnimationImplementation {
  shake,
  jiggle,
  brownian,
  blink,
}

/// Enum with all clear animations that can be played via controller in Pin indicator.
///
/// Clear animation are used when user clears entire pin code or to clear it
/// when other logic triggers clearing.
enum PinClearAnimation implements PinAnimationImplementation {
  drop,
  fade,
}

/// Enum with all erase animations that can be played via controller in Pin indicator.
///
/// Erase animations are used when user erases single symbol from pin code.
enum PinEraseAnimation implements PinAnimationImplementation {
  deflate,
  takeOff,
  fade,
}

/// Enum with all idle animations that can be played via controller in Pin indicator.
///
/// Idle animations are used when user don't interact with app for some time
/// to instigate them to do an action and show that the app is still alive.
enum PinIdleAnimation implements PinAnimationImplementation {
  wave,
  pulse,
  flash,
}
