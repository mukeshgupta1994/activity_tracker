import 'package:activity_tracker/view/homescreen/home_screen.dart';
import 'package:activity_tracker/data/remote/response/api_response.dart';
import 'package:activity_tracker/components/responsive_layout.dart';
import 'package:activity_tracker/viewmodel/login_view_model.dart';
import 'package:activity_tracker/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen>
    with TickerProviderStateMixin {

  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(4, (_) => FocusNode());

  // ✅ All animations properly declared
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

    _mainAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    const curve = Curves.easeOutQuart;

    _imageFade = CurvedAnimation(
      parent: _mainAnimController,
      curve: const Interval(0.0, 0.4, curve: curve),
    );
    _imageSlide =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.0, 0.4, curve: curve),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _mainAnimController,
      curve: const Interval(0.2, 0.6, curve: curve),
    );
    _titleSlide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.2, 0.6, curve: curve),
      ),
    );

    _subtextFade = CurvedAnimation(
      parent: _mainAnimController,
      curve: const Interval(0.3, 0.7, curve: curve),
    );
    _subtextSlide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.3, 0.7, curve: curve),
      ),
    );

    _formFade = CurvedAnimation(
      parent: _mainAnimController,
      curve: const Interval(0.4, 1.0, curve: curve),
    );
    _formSlide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.4, 1.0, curve: curve),
      ),
    );

    _mainAnimController.forward();

    // Focus first OTP box + timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginViewModel>().clearVerifyOtp();
      context.read<LoginViewModel>().startTimer();
      _otpFocusNodes[0].requestFocus();
    });

    // Rebuild on focus change for border highlight
    for (final node in _otpFocusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _mainAnimController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final n in _otpFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  // ─── OTP BOX ────────────────────────────────
  Widget _buildOtpDigitBox(int index) {
    final isFocused = _otpFocusNodes[index].hasFocus;
    return Container(
      width: 65,
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFocused
              ? const Color(0xFF2f3192)
              : const Color(0xFFEDEDF5),
          width: 2,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF3D3BF3).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E1E2C),
          ),
          decoration: const InputDecoration(
            counterText: "",
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

  // ─── HEADER ─────────────────────────────────
  Widget _buildHeaderText(String title, String subtitle) {
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

  // ─── BUILD ──────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<LoginViewModel>(
        builder: (_, lvm, __) => ResponsiveLayout(
          mobile: _buildMobile(lvm),
          tablet: _buildDesktop(lvm),
          desktop: _buildDesktop(lvm),
        ),
      ),
    );
  }

  // ─── MOBILE ─────────────────────────────────
  Widget _buildMobile(LoginViewModel lvm) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Image section with animation
          FadeTransition(
            opacity: _imageFade,
            child: SlideTransition(
              position: _imageSlide,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
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
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          FadeTransition(
            opacity: _formFade,
            child: SlideTransition(
              position: _formSlide,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
                child: Column(
                  children: [
                    _buildHeaderText(
                      'Verify OTP',
                      'Enter the 4-digit code sent to your mobile',
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          4, (i) => _buildOtpDigitBox(i)),
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: 'Verify OTP',
                      onPressed:
                          lvm.verifyOtpStatus.status == ApiResponse.loading
                              ? null
                              : _handleVerifyOtp,
                      isLoading:
                          lvm.verifyOtpStatus.status == ApiResponse.loading,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/send-otp'),
                      child: const Text(
                        'Change Mobile Number',
                        style: TextStyle(
                          color: Color(0xFF7D7D8F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (lvm.counter > 0)
                      Text(
                        'Resend OTP in ${lvm.counter}s',
                        style: const TextStyle(
                          color: Color(0xFF3D3BF3),
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── DESKTOP ────────────────────────────────
  Widget _buildDesktop(LoginViewModel lvm) {
    return Row(
      children: [
        // Left branding
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
                  Image.asset('assets/images/log_icon.png', height: 180),
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
                        fontSize: 16, color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Right OTP form
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
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/log_icon.png', height: 100),
                    const SizedBox(height: 20),
                    _buildHeaderText(
                      'Verify OTP',
                      'Enter the 4-digit code sent to your mobile',
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (i) => _buildOtpDigitBox(i)),
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: 'Verify OTP',
                      onPressed:
                          lvm.verifyOtpStatus.status == ApiResponse.loading
                              ? null
                              : _handleVerifyOtp,
                      isLoading:
                          lvm.verifyOtpStatus.status == ApiResponse.loading,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/send-otp'),
                      child: const Text(
                        'Change Mobile Number',
                        style: TextStyle(
                          color: Color(0xFF7D7D8F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (lvm.counter > 0)
                      Text(
                        'Resend OTP in ${lvm.counter}s',
                        style: const TextStyle(
                          color: Color(0xFF3D3BF3),
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── VERIFY HANDLER ─────────────────────────
  void _handleVerifyOtp() async {
    // Sync controllers → viewmodel's single controller
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 4-digit OTP')),
      );
      return;
    }

    // Put combined OTP into viewmodel controller
    context.read<LoginViewModel>().verifyOtpTextController.text = otp;

    await context.read<LoginViewModel>().fetchVerifyOtp();

    final lvm = context.read<LoginViewModel>();

    if (lvm.verifyOtpStatus.status == ApiResponse.completed &&
        lvm.isLoggedIn) {
      if (mounted) {
        // ✅ GoRouter — goes to dashboard, clears back stack
        context.go('/dashboard');
      }
    } else if (lvm.verifyOtpStatus.status == ApiResponse.error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lvm.verifyOtpStatus.message ?? 'Invalid OTP'),
            backgroundColor: const Color(0xFF3D3BF3),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }
}


// import 'package:activity_tracker/view/homescreen/widget/activity_screen.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:activity_tracker/components/custom_button.dart';
// import 'package:activity_tracker/view/homescreen/home_screen.dart'; // Dashboard
// import 'package:activity_tracker/data/remote/response/api_response.dart';
// import 'package:activity_tracker/components/responsive_layout.dart';
// import 'package:activity_tracker/viewmodel/login_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:activity_tracker/components/custom_button.dart';
// import 'package:activity_tracker/components/custom_textfield.dart';
// import 'package:activity_tracker/data/remote/response/api_response.dart';
// import 'package:go_router/go_router.dart'; 

// class VerifyOtpScreen extends StatefulWidget {
//   const VerifyOtpScreen({super.key});

//   @override
//   State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
// }

// class _VerifyOtpScreenState extends State<VerifyOtpScreen> with TickerProviderStateMixin {
//   // Animations same as SendOtpScreen (copy kar lo)
//   final List<FocusNode> _otpFocusNodes = List.generate(4, (index) => FocusNode());
// late ActivityDashViewModel _activityViewModel; 

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final lvm = context.read<LoginViewModel>();
//       lvm.clearVerifyOtp();
//       lvm.startTimer(); // Resend timer start
//       _otpFocusNodes[0].requestFocus();
//     });
//   }
//     late AnimationController _mainAnimController;
//   late Animation<double> _imageFade;
//   late Animation<Offset> _imageSlide;
//   late Animation<double> _titleFade;
//   late Animation<Offset> _titleSlide;
//   late Animation<double> _subtextFade;
//   late Animation<Offset> _subtextSlide;
//   late Animation<double> _formFade;
//   late Animation<Offset> _formSlide;

//   @override
//   void dispose() {
//     for (var node in _otpFocusNodes) node.dispose();
//     super.dispose();
//   }

//   Widget _buildOtpDigitBox(int index, LoginViewModel lvm) {
//     return Container(
//       width: 65, height: 75,
//       decoration: BoxDecoration(color: const Color(0xFFF8F8FD), borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: _otpFocusNodes[index].hasFocus ? const Color(0xFF2f3192) : const Color(0xFFEDEDF5)),
//         boxShadow: _otpFocusNodes[index].hasFocus ? [BoxShadow(color: const Color(0xFF3D3BF3).withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))] : []),
//       child: TextField(
//         controller: TextEditingController(text: lvm.verifyOtpTextController.text.length > index ? lvm.verifyOtpTextController.text[index] : ''), // Sync with single controller
//         focusNode: _otpFocusNodes[index],
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2C)),
//         decoration: const InputDecoration(counterText: '', border: InputBorder.none),
//         onChanged: (value) {
//           final otp = _otpFocusNodes.asMap().entries.map((e) => e.value.rect).join();
//           lvm.verifyOtpTextController.value = TextEditingValue(text: otp);
//           if (value.isNotEmpty) {
//             if (index < 3) _otpFocusNodes[index + 1].requestFocus();
//             else _otpFocusNodes[index].unfocus();
//           } else if (index > 0) _otpFocusNodes[index - 1].requestFocus();
//           if (otp.length == 4) _handleVerifyOtp();
//           setState(() {});
//         },
//       ),
//     );
//   }

//   // Header same as _buildHeaderText

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Consumer<LoginViewModel>(
//         builder: (_, lvm, __) => ResponsiveLayout(
//           mobile: _buildMobile(lvm),
//           desktop: _buildMobile(lvm), tablet: _buildMobile(lvm),
//         ),
//       ),
//     );
//   }

//   Widget _buildMobile(LoginViewModel lvm) {
//     return SingleChildScrollView(child: Column(children: [
//       // Image animation
//       Padding(padding: const EdgeInsets.fromLTRB(30, 40, 30, 40), child: Column(children: [
//         _buildHeaderText('Verify OTP', 'Enter the 4-digit code sent to your mobile'),
//         const SizedBox(height: 40),
//         Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(4, (i) => _buildOtpDigitBox(i, lvm))),
//         const SizedBox(height: 40),
//         CustomButton(
//           text: 'Verify OTP',
//           onPressed: lvm.verifyOtpStatus.status == ApiResponse.loading ? null : _handleVerifyOtp,
//           isLoading: lvm.verifyOtpStatus.status == ApiResponse.loading,
//         ),
//         const SizedBox(height: 10),
//         TextButton(onPressed: () => context.go('/send-otp'), child: const Text('Change Mobile Number')),
//         if (lvm.counter > 0) Text('Resend OTP in ${lvm.counter}s'), // Timer display
//       ])),
//     ]));
//   }

//   // Desktop similar with side image + card

//   void _handleVerifyOtp() async {
//     await context.read<LoginViewModel>().fetchVerifyOtp();
//     final lvm = context.read<LoginViewModel>();
//     if (lvm.verifyOtpStatus.status == ApiResponse.completed && lvm.isLoggedIn) {
//       if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ActivityTrackerDashboard()
//     //   EditActivityScreen(vm: _activityViewModel,)
//        ));
//     } else if (lvm.verifyOtpStatus.status == ApiResponse.error) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lvm.verifyOtpStatus.message ?? 'Error')));
//     }
//   }

//   Widget _buildHeaderText(String title, String subtitle) {
//     // Exact same as your first code
//     return Column(
//       children: [
//         FadeTransition(
//           opacity: _titleFade,
//           child: SlideTransition(
//             position: _titleSlide,
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.w900,
//                 color: Color(0xFF1E1E2C),
//                 letterSpacing: -1,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         FadeTransition(
//           opacity: _subtextFade,
//           child: SlideTransition(
//             position: _subtextSlide,
//             child: Text(
//               subtitle,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF7D7D8F),
//                 height: 1.5,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }