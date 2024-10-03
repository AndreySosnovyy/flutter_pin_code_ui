## How to add a new animation?

Currently, **pin_ui** package doesn't allow developers to add new animations with
its API via public classes. So in case you still want to add your own animation
you have to either fork this project or suggest it in [GitHub](https://github.com/AndreySosnovyy/flutter_pin_code_ui)
issue/pull request.

### Add a new animation with existing type:

If your animation have a type already existing in PinAnimationTypes enum
PinAnimationTypes from lib/src/indicator/models/animation_data.dart, follow
this instruction. 

1) Add a new enum value (yours animation name) to the corresponding enum
   implementing `PinAnimationImplementation` in **lib/src/indicator/models/implementations.dart**.
2) Create a new class that extends `PinIndicatorAnimationData` where you configure
   your new animation. You better add it somewhere around existing animations
   with same type to avoid messing it all. If you are not sure about some animation
   parameters, just copy them from any animation with same type and set your desired
   `duration`.
3) Add newly created class to static parsing method `fromImpl` in the same file.
4) Create a new class in **lib/src/widgets/animated_pin_indicators/** folder
   with your animation visual implementation. Make anything you want inside this
   class, actual implementation doesn't matter. But you can check any other animation
   sources to get inspiration or take something from there. Take attention that you
   must add vibration logic in this class if you want to use it.
5) Add your animation to **lib/src/indicator/widgets/pin_indicator.dart**
   in general `switch` statement from where it will be displayed when called.
   You better also add it in order of types to remain it clean.
6) Now you can call your animation with `PinIndicatorAnimationController`!
   No need to add or configure any methods inside controller, it will handle your
   animation by itself.

### Add a new animation with a new type:

1) Add your new type to `PinAnimationTypes` enum in
   **lib/src/indicator/models/animation_data.dart**.
2) Add a newly added type in static parsing method `fromImpl`.
3) Add a new enum class which implements `PinAnimationImplementation` in
   **lib/src/indicator/models/implementations.dart**.
4) Add a new method to `PinIndicatorAnimationController` that will be called
   when you want to display your new animation. Save naming rules from other
   methods in controller to make it clean and readable.
5) (Optional) Add a getter to check if animation with your type is playing
   to `PinIndicatorAnimationController` (isAnimating*YourNewTypeName*).
6) Go through all the steps from the [instruction above](#add-a-new-animation-with-existing-type)
   to add a new animation with a new type you created.

### How to implement a new animation:

There are no limitations on how to exactly implement animation for **pin_ui**.
Any approach you best with can be used: AnimationController, Tween, AnimatedContainer,
any pre-made staff or even other third party solutions.

How does it work?

Every animation in **pin_ui** is absolutely independent and package know nothing
about their implementation.</br>
There is a core widget which is `PinIndicatorBuilder`. Its only role is to manage
what animation should be shown at this moment depending on current `value` from
associated `PinIndicatorAnimationController`. So implementation doesn't matter.
If you added a new animation which lasts for 3 seconds, and it was called, core
widget will display it, give 3 seconds to play an animation, and then it will be
replaced with a next one from the queue (or earlier if animation is interruptible)
or with a static Pin Indicator if there are no any. The only limitation in this
case is animation duration, but it is also configured by you in advance. 
</br>
</br>
</br>