import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:menexus/bloc/google_login/google_login_cubit.dart';
import 'package:menexus/bloc/google_login/google_login_state.dart';
import 'package:menexus/screens/widgets/snackbar.dart';

import '../bloc/auth/login_cubit.dart';
import '../bloc/auth/login_state.dart';
import '../repository/user_repository.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<LoginCubit>(
        create: (context) {
          return LoginCubit(LoginInit(),
              userRepository: context.read<UserRepository>());
        },
      ),
      BlocProvider<GoogleLoginCubit>(
        create: (context) {
          return GoogleLoginCubit(context.read<UserRepository>());
        },
      ),
    ], child: const LoginScreenView());
  }
}

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({Key? key}) : super(key: key);

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  late bool hidePassword;
  late String emailAddress;
  late String password;
  bool? isLoading;

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      context
          .read<LoginCubit>()
          .loginUserByEmailPassword(emailAddress, password);
    } else {
      MessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
    }
  }

  onGoogleLogin() {
    context.read<GoogleLoginCubit>().signInWithGoogle();
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    hidePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  //reset all the values in the form to default (empty).
                  _formKey.currentState!.reset();

                  //go to  home screen
                  Navigator.pushReplacementNamed(context, '/home_screen');
                }

                if (state is LoginFailure) {
                  MessageHandler.showSnackBar(
                      _scaffoldKey, state.errorMessage.toString());
                }
              },
              builder: (context, state) => Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderPart(),
                    _buildForm(),
                    const SizedBox(
                      height: 28.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Are you new to App?,'),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text('Sign up here')),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                     _buildGoogleSignIn(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderPart() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      color: Colors.yellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.ac_unit_outlined,
            color: Colors.black,
            size: 80.0,
          ),
          Text(
            'Yellow'.toUpperCase(),
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 22.0,
                letterSpacing: 1.1),
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    InputDecoration decoration = const InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      labelStyle: TextStyle(color: Colors.black),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      errorStyle: TextStyle(color: Colors.grey),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Email:'),
              const SizedBox(
                width: 50.0,
              ),
              Flexible(
                child: TextFormField(
                  style: const TextStyle(fontSize: 14.0),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) => emailAddress = value!,
                  decoration: decoration.copyWith(
                    suffixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Password:'),
              const SizedBox(
                width: 24.0,
              ),
              Flexible(
                child: TextFormField(
                  style: const TextStyle(fontSize: 14.0),
                  obscureText: hidePassword,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your password' : null,
                  onSaved: (value) => password = value!,
                  decoration: decoration.copyWith(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ))),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 18.0,
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellow)),
            onPressed: signIn,
            child: const Text(
              'Log in',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGoogleSignIn() {
    return BlocConsumer<GoogleLoginCubit, GoogleLoginState>(
      listener: (context, state) {
        if (state is GoogleLoginInProgress) {
          setState(() {
            isLoading = true;
          });
          return;
        }
        if (state is GoogleLoginFailure) {
          isLoading = false;

          MessageHandler.showSnackBar(_scaffoldKey, state.error.toString());
          return;
        }
        if (state is GoogleLoginSuccess) {
          setState(() {
            isLoading = false;
          });

          Navigator.pushNamedAndRemoveUntil(
              context, '/home_screen', (route) => false);
        }
      },
      builder: (context, state) => FractionallySizedBox(
        widthFactor: 0.6,
        child: isLoading!
            ? const Center(child: CircularProgressIndicator())
            :ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white)),
          onPressed: onGoogleLogin,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              FaIcon(
                FontAwesomeIcons.google,
                color: Colors.grey,
              ),
              Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
