import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/auth/presentation/bloc/auth_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isOtpSent = false;
  late final AnimationController _animController;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _itemCount = 6;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnims = List.generate(_itemCount, (i) {
      final start = i * 0.1;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _slideAnims = List.generate(_itemCount, (i) {
      final start = i * 0.1;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _animatedItem(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(position: _slideAnims[index], child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthForgotPasswordSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: const TextStyle(color: Colors.black)),
              backgroundColor: AppColors.primaryBlue,
            ),
          );
          setState(() => _isOtpSent = true);
        } else if (state is AuthForgotPasswordFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthResetPasswordSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Password reset successfully!",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Go back to login screen
          context.read<AuthBloc>().add(AuthLoginPageEvent());
          Navigator.pop(context);
        } else if (state is AuthResetPasswordFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Password reset unsuccessful: ${state.message}",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          // Go back to authpage
          context.read<AuthBloc>().add(AuthReturnHomeEvent());
          Navigator.pop(context);
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_isOtpSent) {
            setState(() => _isOtpSent = false);
          } else {
            context.read<AuthBloc>().add(AuthReturnHomeEvent());
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              const Wallpaper(),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              _animatedItem(
                                0,
                                IconButton(
                                  onPressed: () {
                                    if (_isOtpSent) {
                                      setState(() => _isOtpSent = false);
                                    } else {
                                      context.read<AuthBloc>().add(AuthReturnHomeEvent());
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                                ),
                              ),
                              const SizedBox(height: 30),
                              _animatedItem(
                                1,
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Color(0xff8BB2FF), Color(0xff2A6AE8)],
                                  ).createShader(bounds),
                                  child: Text(
                                    _isOtpSent ? "Reset Password" : "Forgot Password",
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              _animatedItem(
                                2,
                                Text(
                                  _isOtpSent
                                      ? "Enter the OTP sent to ${_emailController.text} and your new password."
                                      : "Enter your registered email address and we'll send you an OTP to reset your password.",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textTertiary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              if (!_isOtpSent) ...[
                                _animatedItem(3, _buildLabel("Email")),
                                const SizedBox(height: 5),
                                _animatedItem(4, _buildTextField(_emailController, "example@mail.com", TextInputType.emailAddress)),
                                const SizedBox(height: 40),
                                _animatedItem(
                                  5,
                                  _buildButton(
                                    "Send OTP",
                                    () {
                                      if (_emailController.text.isNotEmpty) {
                                        context.read<AuthBloc>().add(
                                              AuthForgotPasswordEvent(email: _emailController.text.trim()),
                                            );
                                      }
                                    },
                                  ),
                                ),
                              ] else ...[
                                _animatedItem(3, _buildLabel("OTP")),
                                const SizedBox(height: 5),
                                _animatedItem(4, _buildTextField(_otpController, "Enter OTP", TextInputType.number)),
                                const SizedBox(height: 20),
                                _animatedItem(5, _buildLabel("New Password")),
                                const SizedBox(height: 5),
                                _animatedItem(5, _buildTextField(_passwordController, "••••••••", TextInputType.visiblePassword, obscure: true)),
                                const SizedBox(height: 40),
                                _animatedItem(
                                  5,
                                  _buildButton(
                                    "Reset Password",
                                    () {
                                      if (_otpController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                                        context.read<AuthBloc>().add(
                                              AuthResetPasswordEvent(
                                                email: _emailController.text.trim(),
                                                otp: _otpController.text.trim(),
                                                newPassword: _passwordController.text.trim(),
                                              ),
                                            );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
    ),
  ),
);
}

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, TextInputType type, {bool obscure = false}) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.cardSecondaryBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardSecondaryBorder, width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        obscureText: obscure,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthForgotPasswordLoadingState || state is AuthResetPasswordLoadingState;
        return Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
