import 'package:demo_prc_skynet_tech/core/session/session_manager.dart';
import 'package:demo_prc_skynet_tech/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:demo_prc_skynet_tech/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo_prc_skynet_tech/features/auth/presentation/bloc/auth_event.dart';
import 'package:demo_prc_skynet_tech/features/auth/presentation/bloc/auth_state.dart';
import 'package:demo_prc_skynet_tech/features/auth/presentation/screen/home/auth_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepositoryImpl()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            await SessionManager.saveLogin(state.user.email);
            if (!context.mounted) {
              return;
            }
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (_) => AuthHomeScreen(userEmail: state.user.email),
              ),
              (_) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: const Color(0xFF2949C7),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final isSmall = width < 380;
                  final isTablet = width >= 700;

                  final maxFormWidth = isTablet ? 520.0 : 430.0;
                  final horizontalPadding = isSmall ? 16.0 : 24.0;
                  final iconSize = isSmall ? 68.0 : 82.0;
                  final titleSize = isSmall ? 34.0 : 42.0;
                  final fieldFontSize = isSmall ? 18.0 : 22.0;
                  final buttonFontSize = isSmall ? 20.0 : 24.0;
                  final textSize = isSmall ? 16.0 : 20.0;

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxFormWidth),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 20,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: isSmall ? 20 : 24),
                              Icon(
                                Icons.person_add_alt_1_outlined,
                                size: iconSize,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign Up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: titleSize,
                                ),
                              ),
                              SizedBox(height: isSmall ? 30 : 46),
                              _WhiteBorderField(
                                child: TextFormField(
                                  controller: email,
                                  enabled: !isLoading,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration(
                                    'Email',
                                    fieldFontSize,
                                  ),
                                  validator: (value) {
                                    final text = (value ?? '').trim();
                                    if (text.isEmpty) {
                                      return 'Email is required';
                                    }
                                    if (!text.contains('@')) {
                                      return 'Enter valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _WhiteBorderField(
                                child: TextFormField(
                                  controller: password,
                                  enabled: !isLoading,
                                  obscureText: _hidePassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration:
                                      _inputDecoration(
                                        'Password',
                                        fieldFontSize,
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _hidePassword = !_hidePassword;
                                            });
                                          },
                                          icon: Icon(
                                            _hidePassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  validator: (value) {
                                    final text = (value ?? '').trim();
                                    if (text.isEmpty) {
                                      return 'Password is required';
                                    }
                                    if (text.length < 6) {
                                      return 'Minimum 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _WhiteBorderField(
                                child: TextFormField(
                                  controller: confirmPassword,
                                  enabled: !isLoading,
                                  obscureText: _hideConfirmPassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration:
                                      _inputDecoration(
                                        'Confirm Password',
                                        fieldFontSize,
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _hideConfirmPassword =
                                                  !_hideConfirmPassword;
                                            });
                                          },
                                          icon: Icon(
                                            _hideConfirmPassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  validator: (value) {
                                    final text = (value ?? '').trim();
                                    if (text.isEmpty) {
                                      return 'Confirm password';
                                    }
                                    if (text != password.text.trim()) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 22),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmall ? 8 : 24,
                                ),
                                child: SizedBox(
                                  height: 56,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFDFDFE2),
                                      foregroundColor: const Color(0xFF2949C7),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            if (!(_formKey.currentState
                                                    ?.validate() ??
                                                false)) {
                                              return;
                                            }
                                            context.read<AuthBloc>().add(
                                              RegisterEvent(
                                                email: email.text.trim(),
                                                password: password.text.trim(),
                                              ),
                                            );
                                          },
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xFF2949C7),
                                            ),
                                          )
                                        : Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              fontSize: buttonFontSize,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 26),
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: textSize,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: isLoading
                                        ? null
                                        : () {
                                            Navigator.pop(context);
                                          },
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: textSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, double fontSize) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white, fontSize: fontSize),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      errorStyle: const TextStyle(color: Color(0xFFFFE6E6), fontSize: 13),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }
}

class _WhiteBorderField extends StatelessWidget {
  final Widget child;

  const _WhiteBorderField({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
