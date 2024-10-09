import 'package:animated_login_screen/rive_controller.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final riveManager = RiveAnimationControllerManager();
  @override
  void initState() {
    super.initState();
    _initRiveAnimations(); // Call the async method
  }

  // Create a separate method for async initialization
  Future<void> _initRiveAnimations() async {
    await riveManager.initAnimations();
    setState(() {});
  }

  @override
  void dispose() {
    riveManager.passwordFocusNode.dispose();
    super.dispose();
  }

  bool isObscureText = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Animated Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width / 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height / 3,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(73, 33, 149, 243),
                      Colors.blueGrey,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: riveManager.riveArtboard == null
                      ? const SizedBox.shrink()
                      : rive.Rive(
                          artboard: riveManager.riveArtboard!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(
                height: size.height / 45,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      validator: (value) =>
                          value != riveManager.testEmail ? "Wrong email" : null,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            value.length < 16 &&
                            !riveManager.isLookingLeft) {
                          riveManager.addSpecifcAnimationAction(
                              riveManager.controllerLookDownLeft);
                        } else if (value.isNotEmpty &&
                            value.length > 16 &&
                            !riveManager.isLookingRight) {
                          riveManager.addSpecifcAnimationAction(
                              riveManager.controllerLookDownRight);
                        }
                      },
                    ),
                    SizedBox(
                      height: size.height / 25,
                    ),
                    TextFormField(
                      obscureText: isObscureText,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isObscureText = !isObscureText;
                              if (isObscureText) {
                                riveManager.addSpecifcAnimationAction(
                                    riveManager.controllerhandsUpUnShow);
                              } else {
                                riveManager.addSpecifcAnimationAction(
                                    riveManager.controllerhandsUpshow);
                              }
                            });
                          },
                          child: Icon(
                            isObscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      focusNode: riveManager.passwordFocusNode,
                      validator: (value) => value != riveManager.testPassword
                          ? "Wrong password"
                          : null,
                    ),
                    SizedBox(
                      height: size.height / 18,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width / 8,
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          riveManager.passwordFocusNode.unfocus();
                          riveManager.validateEmailAndPassword(formKey);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
