import 'package:activity_tracker/components/responsive_layout.dart';
import 'package:activity_tracker/viewmodel/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:activity_tracker/components/custom_button.dart';
import 'package:activity_tracker/components/custom_textfield.dart';
import 'package:activity_tracker/data/remote/response/api_response.dart';
import 'package:go_router/go_router.dart'; // Navigation ke liye
// Aapke utils/app_utils.dart, res etc.

class SendOtpScreen extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen>
    with TickerProviderStateMixin {
  // Aapke saare animations copy-paste (same as first code)
  late AnimationController _mainAnimController;
  late Animation<double> _imageFade;
  late Animation<Offset> _imageSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtextFade;
  late Animation<Offset> _subtextSlide;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();
    // Exact same animation initState as your first code
    _mainAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    const curve = Curves.easeOutQuart;
    _imageFade = CurvedAnimation(
      parent: _mainAnimController,
      curve: const Interval(0.0, 0.4, curve: curve),
    );
    // ... baaki same
    _mainAnimController.forward();
  }

  @override
  void dispose() {
    _mainAnimController.dispose();
    super.dispose();
  }

  Widget _buildHeaderText(String title, String subtitle) {
    // Exact same as your first code
    return Column(
      children: [
        FadeTransition(
          opacity: _titleFade,
          child: SlideTransition(
            position: _titleSlide,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1E2C),
                letterSpacing: -1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FadeTransition(
          opacity: _subtextFade,
          child: SlideTransition(
            position: _subtextSlide,
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7D7D8F),
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  SnackBar _buildSnackBar(String message) {
    // Your existing snackbar
    return SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFF3D3BF3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: SendOtpScreen._formKey,
        child: ResponsiveLayout(
          mobile: _buildMobile(),
          desktop: _buildDesktop(), tablet: _buildDesktop(),
        ),
      ),
    );
  }

  Widget _buildMobile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Your image FadeTransition + SlideTransition exact same
          FadeTransition(
            opacity: _imageFade,
            child: SlideTransition(
              position: _imageSlide,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.42,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F8FD),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/log_icon.png',
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Consumer<LoginViewModel>(
            builder: (_, lvm, __) => Padding(
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
              child: Column(
                children: [
                  _buildHeaderText(
                    'Welcome',
                    'Enter your mobile number to continue',
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: lvm.sentOtpTextController,
                    hint: 'Mobile Number',
                    icon: Icons.phone_android_rounded,
                    keyboardType: TextInputType.phone,
                    
                    // maxLength: 10,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Send OTP',
                    onPressed: lvm.sentOtpStatus.status == ApiResponse.loading
                        ? null
                        : _handleSendOtp,
                    isLoading: lvm.sentOtpStatus.status == ApiResponse.loading,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildDesktop() {
  //   return Center(
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Image.asset('assets/images/desktop_bg.png'),
  //         ), // Side image
  //         Container(
  //           width: 500,
  //           padding: const EdgeInsets.all(40),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             boxShadow: [BoxShadow(blurRadius: 10)],
  //           ),
  //           child: Consumer<LoginViewModel>(
  //             builder: (_, lvm, __) => Column(
  //               children: [
  //                 Image.asset('assets/images/log_icon.png', height: 160),
  //                 _buildHeaderText('Welcome', 'Enter your mobile number'),
  //                 const SizedBox(height: 40),
  //                 CustomTextField(
  //                   controller: lvm.sentOtpTextController,
  //                   hint: 'Mobile Number',
  //                   icon: Icons.phone_android_rounded,
  //                   keyboardType: TextInputType.phone,
  //                 ),
  //                 const SizedBox(height: 30),
  //                 CustomButton(
  //                   text: 'Send OTP',
  //                   onPressed: lvm.sentOtpStatus.status == ApiResponse.loading
  //                       ? null
  //                       : _handleSendOtp,
  //                   isLoading: lvm.sentOtpStatus.status == ApiResponse.loading,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildDesktop() {
  return Container(
    color: Colors.white,
    child: Row(
      children: [
        // 🔥 LEFT SIDE (Gradient Branding)
        Expanded(
          flex: 5,
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3D3BF3), Color(0xFF6A6AFB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/log_icon.png',
                    height: 180,
                  ),
                  const SizedBox(height: 40),

                  const Text(
                    "Welcome to\nActivity Tracker",
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Track your activities, manage tasks,\nand boost productivity 🚀",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 💼 RIGHT SIDE (LOGIN FORM)
        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Consumer<LoginViewModel>(
                  builder: (_, lvm, __) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/log_icon.png',
                        height: 120,
                      ),

                      const SizedBox(height: 20),

                      _buildHeaderText(
                        'Welcome',
                        'Enter your mobile number to continue',
                      ),

                      const SizedBox(height: 40),

                      CustomTextField(
                        controller: lvm.sentOtpTextController,
                        hint: 'Mobile Number',
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 30),

                      CustomButton(
                        text: 'Send OTP',
                        onPressed:
                            lvm.sentOtpStatus.status == ApiResponse.loading
                                ? null
                                : _handleSendOtp,
                        isLoading:
                            lvm.sentOtpStatus.status == ApiResponse.loading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  void _handleSendOtp() async {
    if ((SendOtpScreen._formKey.currentState?.validate() ?? false) &&
        (context.read<LoginViewModel>().sentOtpTextController.text.length >=
            10)) {
      await context.read<LoginViewModel>().fetchSendOtp();
      final lvm = context.read<LoginViewModel>();
      if (lvm.sentOtpStatus.status == ApiResponse.completed) {
        if (mounted) context.push('/verify-otp');
      } else if (lvm.sentOtpStatus.status == ApiResponse.error &&
          lvm.sentOtpStatus.message != null) {
        if (mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(_buildSnackBar(lvm.sentOtpStatus.message!));
      }
    }
  }
}
