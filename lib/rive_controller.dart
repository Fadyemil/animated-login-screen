import 'package:animated_login_screen/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart'; // needed for rootBundle

class RiveAnimationControllerManager {
  Artboard? riveArtboard;

  late RiveAnimationController controlleridle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerhandsUpUnShow;
  late RiveAnimationController controllerhandsUpshow;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;
  late RiveAnimationController controllerLookIdle;

  bool isLookingLeft = false;
  bool isLookingRight = false;

  FocusNode passwordFocusNode = FocusNode();
  String testEmail = "fady46t45f@gmail.com";
  String testPassword = "123456";

  void removeAllControllers() {
    riveArtboard?.artboard.removeController(controlleridle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerhandsUpUnShow);
    riveArtboard?.artboard.removeController(controllerhandsUpshow);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerLookDownLeft);
    riveArtboard?.artboard.removeController(controllerLookDownRight);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
    riveArtboard?.artboard.removeController(controllerLookIdle);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addSpecifcAnimationAction(
      RiveAnimationController<dynamic> neededAnimationAction) {
    removeAllControllers();
    riveArtboard?.artboard.addController(neededAnimationAction);
  }

  void checkForPasswordFocusNodeToChangeAnimationState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addSpecifcAnimationAction(controllerHandsUp);
      } else if (!passwordFocusNode.hasFocus) {
        addSpecifcAnimationAction(controllerHandsDown);
      }
    });
  }

   Future<void> loadRiveFileWithItsStates() async {
    await RiveFile.initialize(); // Initialize the Rive library
    final data = await rootBundle.load("assets/auth_teddy.riv");
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;
    artboard.addController(controlleridle);
    riveArtboard = artboard;
  }


  void validateEmailAndPassword(GlobalKey<FormState> formKey) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (formKey.currentState!.validate()) {
          addSpecifcAnimationAction(controllerSuccess);
        } else {
          addSpecifcAnimationAction(controllerFail);
        }
      },
    );
  }

  Future<void> initAnimations() async {
    controlleridle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerhandsUpUnShow =
        SimpleAnimation(AnimationEnum.hands_up_un_show.name);
    controllerhandsUpshow = SimpleAnimation(AnimationEnum.hands_up_show.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerLookDownRight =
        SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookIdle = SimpleAnimation(AnimationEnum.look_idle.name);

  await  loadRiveFileWithItsStates();
    checkForPasswordFocusNodeToChangeAnimationState();
  }
  
}
