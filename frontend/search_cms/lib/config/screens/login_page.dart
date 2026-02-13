import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
  bool _isSubmitting = false;

  // ===== Design Tokens (from Figma Make from Yousif) =====
  static const Color _bg = Color(0xFFF9FAFB); // gray-50
  static const Color _cardBorder = Color(0xFFE5E7EB); // gray-200
  static const Color _inputBorder = Color(0xFFD1D5DB); // gray-300
  static const Color _primaryBlue = Color(0xFF1E40AF);
  static const Color _primaryBlueHover = Color(0xFF1E3A8A);
  static const Color _mutedText = Color(0xFF6B7280); // gray-500
  static const Color _mainText = Color(0xFF111827); // gray-900

  static const double _cardRadius = 8.0; // rounded-lg
  static const double _fieldRadius = 6.0; // rounded-md

  static const double _cardMaxWidth = 448.0; // 28rem
  static const double _cardPadding = 32.0; // p-8
  static const double _controlHeight = 48.0; // h-12

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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius),
        borderSide: const BorderSide(color: _inputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius),
        borderSide: const BorderSide(color: _primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }

  Future<void> _submit() async {
    // Feature #67: Email + Password + Submit button UI (UI-only for now, keeping the auth logic for later from Huai)
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login UI wired (auth has not been connected yet)'),
        ),
      );

      // routing
      // states
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using Sizer for responsive spacing while still respecting design tokens from figma make
    // Keeping card max width exact (448px) as per design tokens
    final horizontalPad = (5.w).clamp(16.0, 40.0);

    return Scaffold(
      backgroundColor: _bg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPad),
            child: Container(
              padding: const EdgeInsets.all(_cardPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_cardRadius),
                border: Border.all(color: _cardBorder, width: 1),
                boxShadow: const [
                  // shadow-md: 0 4px 6px -1px rgba(0,0,0,0.1)
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 6,
                    spreadRadius: -1,
                    color: Color.fromRGBO(0, 0, 0, 0.10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Center(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 30,
                            height: 1.1,
                            color: _mainText,
                            letterSpacing: 1.0,
                          ),
                          children: [
                            TextSpan(
                              text: 's',
                              style: TextStyle(
                                color: _primaryBlue,
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
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Archaeological Data System',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: _mutedText,
                          height: 1.25,
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Title
                    const Text(
                      'System Authentication',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: _mainText,
                        height: 1.2,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Email
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _mainText,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: _controlHeight,
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: _mainText,
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

                    SizedBox(height: 3.h),

                    // Password
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _mainText,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: _controlHeight,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration(
                          suffixIcon: IconButton(
                            splashRadius: 18,
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: _mutedText,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: _mainText,
                          height: 1.2,
                        ),
                        validator: (v) {
                          final value = (v ?? '');
                          if (value.isEmpty) return 'Password is required';
                          if (value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Button
                    SizedBox(
                      height: _controlHeight,
                      child: _HoverButton(
                        isDisabled: _isSubmitting,
                        onPressed: _isSubmitting ? null : _submit,
                        child: Text(
                          _isSubmitting ? 'Submitting...' : 'Access System',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.5.h),

                    // Link (no route exists for now yet, so keeping it safe)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Request Account Access (TODO)')),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _primaryBlue,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                      child: const Text('Request Account Access'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Hover button for web/desktop
class _HoverButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isDisabled;

  const _HoverButton({
    required this.onPressed,
    required this.child,
    required this.isDisabled,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _hovering = false;

  static const Color _primaryBlue = Color(0xFF1E40AF);
  static const Color _primaryBlueHover = Color(0xFF1E3A8A);
  static const double _fieldRadius = 6.0;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDisabled
        ? _primaryBlue.withOpacity(0.6)
        : (_hovering ? _primaryBlueHover : _primaryBlue);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: _primaryBlue.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_fieldRadius),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
