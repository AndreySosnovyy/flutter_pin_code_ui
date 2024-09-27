/// Empty class to be implemented by other enums, so they have one type.
/// Necessary for parsing them when a developer call animations from controller.
sealed class PinAnimationImplementation {}

enum PinInputAnimation implements PinAnimationImplementation {
  inflate,
  fall,
  fade,
}

enum PinLoadingAnimation implements PinAnimationImplementation {
  jump,
  waveInflate,
  waveDeflate,
  collapse,
  travel,
}

enum PinSuccessAnimation implements PinAnimationImplementation {
  collapse,
  fill,
  fillLast,
  kick,
}

enum PinErrorAnimation implements PinAnimationImplementation {
  shake,
  jiggle,
  brownian,
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
