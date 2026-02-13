import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:search_cms/core/utils/constants.dart';
import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.6.h),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
        borderSide: const BorderSide(color: AppColors.danger, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<LoginCubit>().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Using sizer as much as possible an also trying to  keep max width close to the prototype
    final double maxCardWidth = math.min(90.w, AppDimens.cardMaxWidth);
    final double outerPad = (5.w).clamp(16.0, 48.0);

    final double cardPad = (4.w).clamp(18.0, AppDimens.cardPadding);

    final double logoSize = (18.sp).clamp(22.0, 30.0);
    final double titleSize = (16.sp).clamp(22.0, 30.0);
    final double subtitleSize = (10.sp).clamp(12.0, 14.0);
    final double labelSize = (11.sp).clamp(13.0, 16.0);
    final double buttonTextSize = (11.sp).clamp(13.0, 16.0);
    final double linkSize = (10.sp).clamp(12.0, 14.0);

    final double controlHeight = (6.h).clamp(44.0, AppDimens.controlHeight);

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxCardWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: Container(
                padding: EdgeInsets.all(cardPad),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimens.cardRadius),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: -1,
                      color: Color.fromRGBO(0, 0, 0, 0.10),
                    ),
                  ],
                ),
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    } else if (state is LoginSuccess) {
                      // No post-login route exists yet in routes.dart.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Signed in successfully')),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is LoginLoading;

                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: logoSize,
                                  height: 1.1,
                                  color: AppColors.mainText,
                                  letterSpacing: 1.0,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 's',
                                    style: TextStyle(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'EARCH',
                                    style: TextStyle(fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 0.8.h),
                          Center(
                            child: Text(
                              'Archaeological Data System',
                              style: TextStyle(
                                fontSize: subtitleSize,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mutedText,
                                height: 1.25,
                              ),
                            ),
                          ),

                          SizedBox(height: 3.h),

                          // Title
                          Text(
                            'System Authentication',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mainText,
                              height: 1.2,
                            ),
                          ),

                          SizedBox(height: 3.h),

                          // Email
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: labelSize,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mainText,
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: 0.8.h),
                          SizedBox(
                            height: controlHeight,
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration(),
                              style: TextStyle(
                                fontSize: labelSize,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mainText,
                                height: 1.2,
                              ),
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return 'Email is required';
                                if (!value.contains('@')) return 'Enter a valid email';
                                return null;
                              },
                            ),
                          ),

                          SizedBox(height: 2.5.h),

                          // Password
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: labelSize,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mainText,
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: 0.8.h),
                          SizedBox(
                            height: controlHeight,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: _inputDecoration(
                                suffixIcon: IconButton(
                                  splashRadius: 18,
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: labelSize,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mainText,
                                height: 1.2,
                              ),
                              validator: (v) {
                                final value = (v ?? '');
                                if (value.isEmpty) return 'Password is required';
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _onSubmit(context),
                            ),
                          ),

                          SizedBox(height: 3.h),

                          // Submit
                          SizedBox(
                            height: controlHeight,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : () => _onSubmit(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                disabledBackgroundColor:
                                    AppColors.primaryBlue.withOpacity(0.6),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppDimens.fieldRadius),
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      height: 2.2.h,
                                      width: 2.2.h,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Access System',
                                      style: TextStyle(
                                        fontSize: buttonTextSize,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: 2.2.h),

                          // Requesting Access to be done with Huai
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Request Account Access (TODO)'),
                                      ),
                                    );
                                  },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryBlue,
                              textStyle: TextStyle(
                                fontSize: linkSize,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                            child: const Text('Request Account Access'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
