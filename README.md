The **pin_ui** package is responsible for fast layout of advanced PIN code related
screens in Flutter applications. It provides 2 core widgets:

1) **Pinpad.** Highly customizable numeric keyboard for entering PIN code.
2) **Pin Indicator.** Obscured (or not) field for visualizing entered PIN code status
   with lots of pre-made animations to choose from.

<p align="left">
<a href="https://pub.dev/packages/pin_ui"><img src="https://img.shields.io/pub/v/flutter_pin_code_ui.svg?style=flat&colorB=blue&label=pin_ui pub" alt="Pub"></a>
<a href="https://github.com/AndreySosnovyy/flutter_pin_code_ui"><img src="https://img.shields.io/github/stars/andreysosnovyy/flutter_pin_code_ui.svg?&style=flat&logo=github&color=red&label=pin_ui" alt="Star on Github"></a>
</p>

## Pinpad

**Pinpad** is a numeric keyboard with 2 extra key slots. Usually they place
*"Forgot PIN"* and *Biometrics* buttons there.

<img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/pinpad.png" alt="drawing" width="360"/>

### Customization

- 0-9 keys can be decorated with Flutter's `BoxDecoration` class to change its
  appearance: background color, border radius, border, shadows, etc. There are 3 states:
  default, pressed and disabled. Each is customizable on its own, so you can make
  them look different. Provide `keyDefaultDecoration`, `keyPressedDecoration` and
  `keyDisabledDecoration` to set it in a way you prefer.
- 0-9 keys has a `TextStyle` property. There are also 3 states: default, pressed
  and disabled. Set `keyDefaultTextStyle`, `keyPressedTextStyle` and `keyDisabledTextStyle`
  to style digits inside the keys.
- Resize keys with `keyHeight` and `keyWidth`.
- Spacing between keys can be changed with `horizontalSpacing` and `verticalSpacing`
  properties. By default, these values will be calculated depending on the screen size. 
- You can disable or make pinpad invisible by setting `enabled` and `isVisible`.
  Making it invisible will not change actual size of the keyboard.
- Vibration can be enabled with `vibrationEnabled` property. It will make a slight
  vibration feedback when a key is pressed.
- To add extra keys to the left and right of 0 key, provide `leftExtraKey` and `rightExtraKey`.
  These parameters have `PinpadExtraKey` type. It is a wrapper above your child widget
  where you add onTap callback. Child can be any widget, but also you can use
  `PinpadKey` or `PinpadTextKey` provided by this package to make all buttons look
  the same.

```dart
Pinpad(
  onKeyTap: myKeyTapHandler,
  keyDefaultDecoration: myDecoration,
  keyPressedDecoration: myDecoratino.copyWith(color: blue),
  keyDisabledDecoration: myDecoration,
  keyDefaultTextStyle: myTextStyle,
  keyPressedTextStyle: myTextStyle.copyWith(fontWeight: FontWeight.w700),
  keyDisabledTextStyle: myTextStyle.copyWith(color: grey),
  leftExtraKey: PinpadExtraKey(
    onTap: handleForgotPinTap,
    child: myForgotPinButton,
  ),
  rightExtraKey: PinpadExtraKey(
    onTap: handleEraseTap,
    child: myEraseButton,
  ),
  horizontalSpacing: x,
  verticalSpacing: y,
  keyWidth: m,
  keyHeight: n,
  enabled: myEnableCondition,
  isVisible: myVisibleCondition,
  vibrationEnabled: true,
)
```

## </br>Pin Indicator

**Pin Indicator** is a widget that provides visual representation of PIN code:
how many digits are entered, is there an error, was an attempt successful and so on.</br>
The simplest variants of Pin Indicator is a line of colored dots or obscured stars.

### Customization

There are 2 widgets to layout Pin Indicator in your apps: `PinIndicator` and
`PinIndicatorBuilder`. They have mostly the same set of parameters, the main
difference is that by using Builder version you can provide any widgets as items.
So it more customizable. If you don't need this customization level, just use
`PinIndicator`. It provides simple items that can be decorated with Flutter's
`BoxDecoration`.

- **Items** inside both `PinIndicator` and `PinIndicatorBuilder` have 4 states: **Default** represents not entered PIN
  code digits, **Input** represents entered PIN code digits, **Error ** indicates
  that there is something wrong happened (wrong PIN entered), **Success**
  indicates that user entered correct PIN code.</br>
  So there are 4 different parameters to customize your Pin Indicator.</br>
  For **PinIndicatorBuilder** 4 required parameters: `defaultItemBuilder`,
  `inputItemBuilder`, `errorItemBuilder` and `successItemBuilder`.</br>
  For **PinIndicator**: `defaultDecoration`, `inputDecoration`,
  `errorDecoration` and `successDecoration`. These parameters are not required.
  If not provided, pre-made decorations will be used instead.</br>
- `length` is total number of digits in PIN code. It can be anything starting from 3,
  but usually it is 4, 5 or 6.
- `currentLength` represents number of already entered digits by user.
- `isError` – error state enabler.
- `isSuccess` – success state enabler.
- `spacing` – distance between items.
- `size` – size of item. It resizes items for `PinIndicator`, but for
  `PinIndicatorBuilder` it used in some calculations for animations.
- `loadingCollapseAnimationChild` – widget used in Loading Collapse animation.
- `successCollapseAnimationChild` – widget used in Success Collapse animation.

```dart
PinIndicatorBuilder(
  errorItemBuilder: (i) => myErrorItemBuilder(i),
  successItemBuilder: (i) => mySuccessItemBuilder(i),
  inputItemBuilder: (i) => myInputItemBuilder(i),
  defaultItemBuilder: (i) => myDefaultItemBuilder(i),
  length = 4,
  currentLength = pin.length,
  isError = isPinError,
  isSuccess = isPinSuccess,
  controller = myController,
  spacing = 24,
  size = 14,
  loadingCollapseAnimationChild = myLoadingCollapsedWidget,
  successCollapseAnimationChild = mySuccessCollapsedWidget,
)

PinIndicator(
  errorDecoration = myErrorDecoration,
  successDecoration = mySuccessDecoration,
  inputDecoration = myInputDecoration,
  defaultDecoration = myDefaultDecoration,
  length = 4,
  currentLength = pin.length,
  isError = isPinError,
  isSuccess = isPinSuccess,
  controller = myController,
  spacing = 24,
  size = 14,
  loadingCollapseAnimationChild = myLoadingCollapsedWidget,
  successCollapseAnimationChild = mySuccessCollapsedWidget,
)
```

### Animations

Animations are core features of **pin_ui** package. It contains lots of
pre-made animations for several scenarios when user interact with your app.</br>
**Why use animations?** First of all, it looks much nicer. Second thing is that they
can take user's attention while some async backed requests or other
initialization processes will happen in background. Usually it's done with boring
loading indicators or shimmers. But a good sequences of cool animations can
handle this task much better!

Pin Indicator can be animated in such ways:

- **Input.** Animate input when user enters a digit of PIN code.
- **Loading.** Animate loading when you need to hide long-lasting async operation
  or to make animations flow more smooth and obvious to user.
- **Success.** Animate success when user enters correct PIN code to also hide
  long-lasting async operation after loading animation. And to demonstrate user
  that they entered correct PIN code and no more actions required from their side.
- **Error.** Animate error when user entered wrong PIN code to show them that
  entered PIN code is incorrect.
- **Clear.** Animate clear when user clears entire PIN code at once if there are
  such function or when other logic triggers clearing of entire PIN code, such
  as tapping "Forget PIN" button or requesting biometrics.
- **Erase.** Animate erase when user erases a digit from PIN code.
- **Idle.** Animate idle when user was inactive for a while to instigate them for
  an action and show that app is still alive and waits for an action from user's
  side.

Each of these animation types has a set of already implemented animations to
chose from. Here is the table with all of them plus useful information and
recommendations.

| Type    | Name         | Demo                                                                                                                                           | Notes and Recommendations                                                                                                                                                                                                                                                                                                                                                                                                                   | Vibration |
|---------|--------------|------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|
| Input   | Inflate      | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/input_inflate.gif" alt="" width="320"/>       | • Default Input animation<br/>• Recommended to be used in pair with Erase Deflate animation                                                                                                                                                                                                                                                                                                                                                 | +         |
| Input   | Fall         | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/input_fall.gif" alt="" width="320"/>          | • Recommended to be used in pair with Erase Take Off animation                                                                                                                                                                                                                                                                                                                                                                              | -         |
| Input   | Fade         | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/input_fade.gif" alt="" width="320"/>          | • Recommended to be used in pair with Erase Fade animation                                                                                                                                                                                                                                                                                                                                                                                  | -         |
| Loading | Jump         | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/loading_jump.gif" alt="" width="320"/>        | • Default Loading animation<br/>• Good at combining with Success Fill Last animation<br/>• Add delays if you want to repeat this animation                                                                                                                                                                                                                                                                                                  | +         |
| Loading | Wave Inflate | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/loading_waveInflate.gif" alt="" width="320"/> |                                                                                                                                                                                                                                                                                                                                                                                                                                             | -         |
| Loading | Wave Deflate | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/loading_waveDeflate.gif" alt="" width="320"/> |                                                                                                                                                                                                                                                                                                                                                                                                                                             | -         |
| Loading | Collapse     | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/loading_collapse.gif" alt="" width="320"/>    | • You can provide own animation indicator in `PinIndicator` or `PinIndicatorBuilder` via `loadingCollapseAnimationChild` parameter<br/>• Animation will end right after collapsing, so you have to configure time to show the loader by setting `delayAfter`<br/>• Recommended not to use any Success animation right after this one as it will require to Pin Indicator items appear imminently from nowhere and only then start animating | -         |
| Loading | Travel       | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/loading_travel.gif" alt="" width="320"/>      |                                                                                                                                                                                                                                                                                                                                                                                                                                             | -         |
| Success | Collapse     | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/success_collapse.gif" alt="" width="320"/>    | • Default Success animation<br/>• You can provide own child which is displayed after collapse in `PinIndicator` or `PinIndicatorBuilder` via `successCollapseAnimationChild` parameter                                                                                                                                                                                                                                                      | -         |
| Success | Fill         | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/success_fill.gif" alt="" width="320"/>        | • This one is great when you make navigation without animation (in `onComplete` callback) to a screen which has a background color same as fill color of animation, so it looks like seconds splash screen for your app<br/>• This animation will have the same play time for any screen size or any start position (position of Pin Indicator on the screen) because it dynamically calculates fill speed when built                       | -         |
| Success | Fill last    | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/success_fillLast.gif" alt="" width="320"/>    | • Same as Success Fill animation, but this one is perfect for combining with Loading Jump animation                                                                                                                                                                                                                                                                                                                                         | -         |
| Success | Kick         | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/success_kick.gif" alt="" width="320"/>        |                                                                                                                                                                                                                                                                                                                                                                                                                                             | +         |
| Error   | Shake        | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/error_shake.gif" alt="" width="320"/>         | • Default Error animation                                                                                                                                                                                                                                                                                                                                                                                                                   | +         |
| Error   | Jiggle       | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/error_jiggle.gif" alt="" width="320"/>        | • Jiggle effect will only be visible for non-circle Pin Indicator items                                                                                                                                                                                                                                                                                                                                                                     | +         |
| Error   | Brownian     | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/error_brownian.gif" alt="" width="320"/>      | • Items randomly move around and then returns to the start point                                                                                                                                                                                                                                                                                                                                                                            | -         |
| Error   | Blink        | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/error_blink.gif" alt="" width="320"/>         |                                                                                                                                                                                                                                                                                                                                                                                                                                             | -         |
| Clear   | Drop         | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/clear_drop.gif" alt="" width="320"/>          |                                                                                                                                                                                                                                                                                                                                                                                                                                             | -         |
| Clear   | Fade         | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/clear_fade.gif" alt="" width="320"/>          | • Default Clear animation<br/>• Recommended to be used after Error animations if you need so (like in the [example](https://github.com/AndreySosnovyy/flutter_pin_code_ui/tree/main/example)), to not overload it with unnecessary moving staff on screen                                                                                                                                                                                   | -         |
| Erase   | Deflate      | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/erase_deflate.gif" alt="" width="320"/>       | • Default Erase animation<br/>• Recommended to be used in pair with Input Inflate animation                                                                                                                                                                                                                                                                                                                                                 | +         |
| Erase   | Take off     | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/erase_takeOff.gif" alt="" width="320"/>       | • Recommended to be used in pair with Input Fall animation                                                                                                                                                                                                                                                                                                                                                                                  | -         |
| Erase   | Fade         | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/erase_fade.gif" alt="" width="320"/>          | • Recommended to be used in pair with Input Fade animation                                                                                                                                                                                                                                                                                                                                                                                  | -         |
| Idle    | Wave         | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/idle_wave.gif" alt="" width="320"/>           | • Default Idle animation                                                                                                                                                                                                                                                                                                                                                                                                                    | -         |
| Idle    | Pulse        | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/idle_pulse.gif" alt="" width="320"/>          |                                                                                                                                                                                                                                                                                                                                                                                                                                             | -         |
| Idle    | Flash        | <img src="https://raw.githubusercontent.com/AndreySosnovyy/flutter_pin_code_ui/refs/heads/assets/idle_flash.gif" alt="" width="320"/>          | • Items randomly inflate and deflate                                                                                                                                                                                                                                                                                                                                                                                                        | -         |

Seeing alone, some animations may look raw at first, but by combining them
together and adding delays before and after, good sequences can be created!</br>

You can try it out in the [example project](#-examples)
and use it as a playground to test your ideas. Also, it can be a great start point
to begin with where you can copy some code for your application.

### Controller

Animations are called via `PinIndicatorAnimationController` provided by this package.
Associate a controller with `PinIndicator` or `PinIndicatorBuilder` by passing it
in `controller` parameter. After that you can call animation methods and Indicator
will be animated in a way you said it to.

```dart
final controller = PinIndicatorAnimationController();
        
PinIndicator(
  controller: controller,
  ...
)
```

**Controller** is responsible for managing animations. It is done with Queue, so
all animation calls are **synchronous** operations. In queue animations can go
one by one, or they can interrupt other not important animations. More on this in
[Animations priority section](#animations-priority).

To start playing a desired animation just call appropriate method from controller.
```dart
controller.animateLoading();
```

Simple call does not contain any parameters. In this case default animation
will be played without any other modifications.
But you can slightly modify animation call by passing necessary parameters.
List of available parameters differs from one method to another. Here is 
description for them:
- `animation` – is a variant of animation you want to play (check table above).
- `delayBefore` and `delayAfter` – delays to be set before and after this animation.
  They are useful for making a sequences of animations or adding extra time for
  animation to last longer in some cases.
- `onComplete` and `onInterrupt` – useful callbacks for any cases: staring one
  animation after another, reacting to user input during interruptible animations,
  navigating or triggering other needed logic.
- `animationSpeed` – animation speed multiplier. Useful in some cases because
  all animation have preconfigured duration.
- `vibration` – enables vibration for animation (not all animation will vibrate!).
  More in [Vibration section](#vibration).
- `repeatCount` – a way to avoid calling an animation multiple times.

</br>You may want to update your UI when animations starts or ends.
This can be done by listening to controller via `ValueListenableBuilder`. It will
return a value with `PinIndicatorAnimation` type containing service information about
current animation or `null` if no animation is playing. You can avoid using this
and in case you need to check what animation is now playing appeal to getters in
controller.</br>
Listening to controller may be useful in some cases. For example, if you want to
disable `Pinpad` or make it invisible when **loading** or **success** animation
are in progress to show user that something is happening in background and no
more actions required. Or if you want to update `Scaffold` background color
depending on current animation.</br>
In this code snippet it listens to the controller and disables or hides Pinpad
when needed:

```dart
return ValueListenableBuilder(
  valueListenable: controller,
  builder: (context, value, child) {
    return Column(
      children: [
        PinIndicator(
          contoller: controller,
          ...
        ),
        Pinpad(
          // Disable keyboard when important animation is playing
          enabled: !controller.isAnimatingNonInterruptible,
          // Hide keyboard when Success animation is playing
          isVisible: !controller.isAnimatingSuccess,
          ...
        ),
      ],
    );  
  },
);
```

</br>All the animations works with any allowed number of items (> 3). But if you have
too many items animations will look fast because they have fixed play time. So
animation speed can be adjusted to make any of them a bit faster of slower via
`animationSpeed` parameter when calling the animation:

```dart
controller.animateSuccess(
  animation: PinSuccessAnimation.fillLast,
  animationSpeed: 2, // <-- animation will be played at 2x speed
  // animationSpeed: 0.33, // <-- this will make animation 3 times slower

  // Both delays won't be affected with animationSpeed value
  delayBefore: Duration(milliseconds: 240),
  delayAfter: Duration(seconds: 1),
);
```

</br>When starting a new animation you may want to replace items of Pin Indicator with
different widget or at least change their colors, so animation looks more natural
and easily understandable for user. To do so you don't need to add any extra
conditions or update your builders' code. Pin Indicator widget will handle it all
by reading `isError` and `isSuccess` values for these two states. And for handling
default and input states it will depend on `length` and `currentLength` to decide
what builder or decoration apply for each item.

Managing Error and Success states is easy via `onComplete` and `onInterruct`
callbacks. `onComplete` triggers when animation and delay after (if set) is over,
`onInterrupt` triggers when animation is stopped (by user with `stop()`or
by other more important animation). These callbacks can be set when calling
animation in controller:

```dart
// Your Pin Indicator widget
PinIndicator(
  controller: controller,
  length: 4,
  currentLength: pin.length,
  isError: isPinError,
  isSuccess: isPinSuccess,
)

________________________________________________________________________________


// In case user entered correct PIN code
controller.animateLoading(
  onComplete: () => setState(() => isPinSuccess = true),
);
controller.animateSuccess(
  onComplete: () { /* Perform navigation or any other necessary logic here */ },
);

________________________________________________________________________________


// In case user entered wrong PIN code     
setState(() => isPinError = true); // Set Error state
controller.animateError(
  onInterrupt: clear,
);
controller.animateClear(
  onComplete: clear,
  onInterrupt: clear,
);

void clear() => setState(() {
  pin = ''; // Clean current entered pin variable
  isPinError = false; // Go back to Default state for a new attempt
});
```

### Animations priority

Animations queue designed that way so animation can interrupt other one if it is 
possible. Interruptibility of every animation is preconfigured. As long as 
role to interrupt other animations. Here is the list of all animation types with
their properties:

| Type    | Can interrupt | Is interruptible |
|---------|---------------|------------------|
| Input   | True          | True             |
| Loading | False         | False            |
| Success | False         | False            |
| Error   | False         | True             |
| Clear   | False         | True             |
| Erase   | True          | True             |
| Idle    | False         | True             |

So take that in mind when designing logic and animation sequences.</br>
Normally animations goes like this:
- First there are **Inputs** and **Erases**
- If PIN is correct, one or a few **Loadings** and one **Success**
- If PIN in wrong, one **Error** and one **Clear**
- **Idles** can start anytime

Follow these rules and you won't meet any troubles.

### Vibration

Some of the animation have a vibration feature! You can check if it is available
in the [table](#animations).

To enable vibration feature you have to add this to your Android Manifest:

```manifest
<uses-permission android:name="android.permission.VIBRATE"/>
```

Then initialize controller with `initializeVibration()` async method. Otherwise,
it will throw an exception when animation with vibration called!

After preparation, you can call animations and enable vibration feature:

```dart
controller.animateLoading(
  animation: PinLoadingAnimation.jump,
  vibration: true,
);
```

If animation was called with vibration enabled, but it is not implemented for some
reason, nothing bad will happen.

## Additional information

### 👀 See also: [pin](https://pub.dev/packages/pin)

[pin package](https://pub.dev/packages/pin) focused on PIN code's backend part.
It fully covers all the necessary logic of storing, updating, validating PIN,
setting and handling timeouts, calling biometrics, and some other options for
better user experience.</br>
**pin_ui + pin** are perfect to work together in pair. Combining these two may
save you days of development and the result will be already perfect even out of
the box.

<p align="left">
<a href="https://pub.dev/packages/pin"><img src="https://img.shields.io/pub/v/pin.svg?style=flat&colorB=blue&label=pin pub" alt="Pub"></a>
<a href="https://github.com/AndreySosnovyy/flutter_pin_code"><img src="https://img.shields.io/github/stars/andreysosnovyy/flutter_pin_code.svg?&style=flat&logo=github&color=red&label=pin" alt="Star on Github"></a>
</p>

### 📱 Examples

This package has a brief but complex enough [example](https://github.com/AndreySosnovyy/flutter_pin_code_ui/tree/main/example).
Feel free to use it  as a playground or a template for your applications!

You can also [share your own examples](#-contributing) for this section. 

### ✨ Adding new animations or customizing existing ones

Before adding a new animation read an [instruction](add_new_animation.md) on how
to do it in a way it is intended to.

**pin_ui** package is designed to be easily extendable in terms of adding
new animations for Pin Indicator, but currently there are no such API provided.
You can still add own animations by
forking [source code repository of this package](https://github.com/AndreySosnovyy/flutter_pin_code_ui)
or [contribute by suggesting something useful for others](#-contributing).

### 🛠 Contributing

You have an interesting open source example to share with community? Or found a bug,
have a great ready to go new animation or want to suggest an idea for new animation,
you're always welcome! Fell free to open
an [issue](https://github.com/AndreySosnovyy/flutter_pin_code_ui/issues)
or [pull request](https://github.com/AndreySosnovyy/flutter_pin_code_ui/pulls)
in [GitHub repository](https://github.com/AndreySosnovyy/flutter_pin_code_ui)!
</br>
</br>
</br>