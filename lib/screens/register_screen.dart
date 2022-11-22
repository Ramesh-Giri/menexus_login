import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menexus/screens/widgets/snackbar.dart';

import '../bloc/auth/register/register_cubit.dart';
import '../bloc/auth/register/register_state.dart';
import '../repository/user_repository.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return RegisterCubit(RegisterInit(), context.read<UserRepository>());
      },
      child: const RegisterScreenView(),
    );
  }
}

class RegisterScreenView extends StatefulWidget {
  const RegisterScreenView({Key? key}) : super(key: key);

  @override
  State<RegisterScreenView> createState() => _RegisterScreenViewState();
}

class _RegisterScreenViewState extends State<RegisterScreenView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  late bool hidePassword;
  late String name;
  late String emailAddress;
  late String password;

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      context
          .read<RegisterCubit>()
          .registerUserUsingEmailPassword(name, emailAddress, password);
    } else {
      MessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  void initState() {
    super.initState();
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  //reset all the values in the form to default (empty).
                  _formKey.currentState!.reset();
                  MessageHandler.showSnackBar(
                      _scaffoldKey, 'User created successfully!');
                  //go to  home screen
                  Navigator.pushReplacementNamed(context, '/login');
                }
                if (state is RegisterFailure) {
                  MessageHandler.showSnackBar(_scaffoldKey, state.errorMessage);
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
                        const Text('Already have a account?,'),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text('Sign in,')),
                        ),
                      ],
                    )
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
    return Column(
      children: [
        CircleAvatar(
          radius: 60.0,
          backgroundColor: Colors.yellow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.ac_unit_outlined,
                color: Colors.black,
              ),
              Text(
                'Yellow',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        const Text(
          'Welcome to App',
          style: TextStyle(fontSize: 20.0),
        )
      ],
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            validator: (value) =>
                value!.isEmpty ? 'Please enter your name' : null,
            onSaved: (value) => name = value!,
            decoration: decoration.copyWith(
              suffixIcon: const Icon(Icons.person_pin_outlined),
              labelText: 'Name',
              hintText: 'Enter your full name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              } else {
                return null;
              }
            },
            onSaved: (value) => emailAddress = value!,
            decoration: decoration.copyWith(
              suffixIcon: const Icon(Icons.person_pin),
              labelText: 'Email',
              hintText: 'Enter an email address',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            obscureText: hidePassword,
            maxLength: 20,
            validator: (value) =>
                value!.isEmpty ? 'Please enter your password' : null,
            onSaved: (value) => password = value!,
            decoration: decoration.copyWith(
                labelText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.keyboard_alt_outlined
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ))),
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        InkWell(
          onTap: signUp,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
                border: Border.all(width: 2.0),
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(8.0)),
            child: const Text(
              'Next',
              style: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
