import 'package:provider/provider.dart';
import 'package:activity_tracker/viewmodel/login_view_model.dart';
import 'package:activity_tracker/data/remote/response/status.dart';
import 'package:activity_tracker/view/homescreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


enum LoginStep { mobile, otp }


// ── Resolution Portal Color Tokens ──────────────────────────
class _C {
  static const royalBlue = Color(0xFF3243E0);
  static const primaryDark = Color(0xFF2A1FA3);
  static const lightLavender = Color(0xFFF5F6FC);
  static const colorWhite = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF666666);
  static const borderGrey = Color(0xFFE0E0E0);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  LoginStep _currentStep = LoginStep.mobile;
  bool _isLoading = false;

  late AnimationController _mainAnimController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _mainAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(
      parent: _mainAnimController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _mainAnimController, curve: Curves.easeOutQuart),
    );

    _mainAnimController.forward();
  }

  @override
  void dispose() {
    _mainAnimController.dispose();
    _mobileController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var n in _otpFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _handleSendOtp() async {
    if (_mobileController.text.length < 10) {
      _showSnack('Please enter a valid 10-digit mobile number');
      return;
    }
    setState(() => _isLoading = true);
    
    final vm = context.read<LoginViewModel>();
    vm.sentOtpTextController.text = _mobileController.text;
    await vm.fetchSendOtp();
    
    if (mounted) setState(() => _isLoading = false);
    
    if (vm.sentOtpStatus.status == Status.completed) {
      if (mounted) setState(() => _currentStep = LoginStep.otp);
      Future.delayed(
        const Duration(milliseconds: 300),
        () => mounted ? _otpFocusNodes[0].requestFocus() : null,
      );
    } else if (vm.sentOtpStatus.status == Status.error) {
      if (mounted) _showSnack(vm.sentOtpStatus.message ?? 'Error sending OTP');
    }
  }

  void _handleVerifyOtp() async {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      _showSnack('Please enter the 4-digit OTP');
      return;
    }
    setState(() => _isLoading = true);
    
    final vm = context.read<LoginViewModel>();
    vm.verifyOtpTextController.text = otp;
    await vm.fetchVerifyOtp();
    
    if (mounted) setState(() => _isLoading = false);
    
    if (vm.verifyOtpStatus.status == Status.completed) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityTrackerDashboard(),
          ),
        );
      }
    } else if (vm.verifyOtpStatus.status == Status.error) {
      if (mounted) _showSnack(vm.verifyOtpStatus.message ?? 'Invalid OTP');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
        ),
        backgroundColor: _C.royalBlue,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: _C.lightLavender,
      body: isWeb ? _buildWebLayout() : _buildMobileLayout(),
    );
  }

  // ── WEB LAYOUT ─────────────────────────────────────────────
  Widget _buildWebLayout() {
    return Row(
      children: [
        // Left Panel — White with illustration
        Expanded(
          flex: 1,
          child: Container(
            color: _C.colorWhite,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo / Illustration area
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: _C.royalBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/log_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Activity Tracker',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: _C.royalBlue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Track. Manage. Grow.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _C.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Feature pills
                    _featurePill(Icons.bar_chart_rounded, 'Activity Dashboard'),
                    const SizedBox(height: 10),
                    _featurePill(
                        Icons.check_circle_outline_rounded, 'Track Status'),
                    const SizedBox(height: 10),
                    _featurePill(Icons.edit_note_rounded, 'Manage Records'),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Right Panel — Lavender with form
        Expanded(
          flex: 1,
          child: Container(
            color: _C.lightLavender,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: SizedBox(
                    width: 400,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.05, 0),
                                end: Offset.zero,
                              ).animate(anim),
                              child: child,
                            ),
                          ),
                          child: _currentStep == LoginStep.mobile
                              ? _buildLoginCard(key: const ValueKey('mobile'))
                              : _buildOtpCard(key: const ValueKey('otp')),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── MOBILE LAYOUT ──────────────────────────────────────────
  Widget _buildMobileLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // Mobile header
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: _C.royalBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/log_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Activity Tracker',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _C.royalBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to your account',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _C.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: child,
                    ),
                    child: _currentStep == LoginStep.mobile
                        ? _buildLoginCard(key: const ValueKey('m_mobile'))
                        : _buildOtpCard(key: const ValueKey('m_otp')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── LOGIN CARD ─────────────────────────────────────────────
  Widget _buildLoginCard({Key? key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _C.colorWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _C.royalBlue.withOpacity(0.09),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.login_rounded,
              color: _C.royalBlue,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome Back',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _C.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter your mobile number to continue',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: _C.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 28),

          // Phone field
          _buildPhoneField(),
          const SizedBox(height: 24),

          // Send OTP button
          _buildPrimaryButton(
            label: 'Get OTP',
            onTap: _isLoading ? null : _handleSendOtp,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  // ── OTP CARD ───────────────────────────────────────────────
  Widget _buildOtpCard({Key? key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _C.colorWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _C.royalBlue.withOpacity(0.09),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: _C.royalBlue,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Verify OTP',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _C.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter the 4-digit code sent to +91 ${_mobileController.text}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: _C.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),

          // OTP boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (i) => _buildOtpBox(i)),
          ),
          const SizedBox(height: 28),

          // Verify button
          _buildPrimaryButton(
            label: 'Verify OTP',
            onTap: _isLoading ? null : _handleVerifyOtp,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),

          // Change number
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _currentStep = LoginStep.mobile;
                  for (var c in _otpControllers) {
                    c.clear();
                  }
                });
              },
              child: Text(
                'Change Mobile Number',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: _C.royalBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Phone Field ───────────────────────────────────────────
  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: _C.lightLavender,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.borderGrey),
      ),
      child: TextField(
        controller: _mobileController,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: _C.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          counterText: '',
          hintText: '+91 Enter mobile number',
          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: _C.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(
            Icons.phone_outlined,
            color: _C.royalBlue,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ── Primary Button ────────────────────────────────────────
  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_C.royalBlue, _C.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: _C.royalBlue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // ── OTP Box ───────────────────────────────────────────────
  Widget _buildOtpBox(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 64,
      height: 68,
      decoration: BoxDecoration(
        color: _otpFocusNodes[index].hasFocus
            ? _C.royalBlue.withOpacity(0.06)
            : _C.lightLavender,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _otpFocusNodes[index].hasFocus
              ? _C.royalBlue
              : _C.borderGrey,
          width: _otpFocusNodes[index].hasFocus ? 2 : 1,
        ),
        boxShadow: _otpFocusNodes[index].hasFocus
            ? [
                BoxShadow(
                  color: _C.royalBlue.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Center(
        child: TextField(
          controller: _otpControllers[index],
          focusNode: _otpFocusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _C.textPrimary,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < 3) {
                _otpFocusNodes[index + 1].requestFocus();
              } else {
                _otpFocusNodes[index].unfocus();
                _handleVerifyOtp();
              }
            } else if (value.isEmpty && index > 0) {
              _otpFocusNodes[index - 1].requestFocus();
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  // ── Feature Pill ──────────────────────────────────────────
  Widget _featurePill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _C.lightLavender,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _C.royalBlue.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _C.royalBlue, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: _C.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
