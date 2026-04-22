import 'package:activity_tracker/view/homescreen/widget/activity_screen.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:activity_tracker/components/custom_button.dart';
import 'package:activity_tracker/view/homescreen/home_screen.dart'; // Dashboard
import 'package:activity_tracker/data/remote/response/api_response.dart';
import 'package:activity_tracker/components/responsive_layout.dart';
import 'package:activity_tracker/viewmodel/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:activity_tracker/components/custom_button.dart';
import 'package:activity_tracker/components/custom_textfield.dart';
import 'package:activity_tracker/data/remote/response/api_response.dart';
import 'package:go_router/go_router.dart'; 

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> with TickerProviderStateMixin {
  // Animations same as SendOtpScreen (copy kar lo)
  final List<FocusNode> _otpFocusNodes = List.generate(4, (index) => FocusNode());
late ActivityDashViewModel _activityViewModel; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lvm = context.read<LoginViewModel>();
      lvm.clearVerifyOtp();
      lvm.startTimer(); // Resend timer start
      _otpFocusNodes[0].requestFocus();
    });
  }
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
  void dispose() {
    for (var node in _otpFocusNodes) node.dispose();
    super.dispose();
  }

  Widget _buildOtpDigitBox(int index, LoginViewModel lvm) {
    return Container(
      width: 65, height: 75,
      decoration: BoxDecoration(color: const Color(0xFFF8F8FD), borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _otpFocusNodes[index].hasFocus ? const Color(0xFF2f3192) : const Color(0xFFEDEDF5)),
        boxShadow: _otpFocusNodes[index].hasFocus ? [BoxShadow(color: const Color(0xFF3D3BF3).withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))] : []),
      child: TextField(
        controller: TextEditingController(text: lvm.verifyOtpTextController.text.length > index ? lvm.verifyOtpTextController.text[index] : ''), // Sync with single controller
        focusNode: _otpFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2C)),
        decoration: const InputDecoration(counterText: '', border: InputBorder.none),
        onChanged: (value) {
          final otp = _otpFocusNodes.asMap().entries.map((e) => e.value.rect).join();
          lvm.verifyOtpTextController.value = TextEditingValue(text: otp);
          if (value.isNotEmpty) {
            if (index < 3) _otpFocusNodes[index + 1].requestFocus();
            else _otpFocusNodes[index].unfocus();
          } else if (index > 0) _otpFocusNodes[index - 1].requestFocus();
          if (otp.length == 4) _handleVerifyOtp();
          setState(() {});
        },
      ),
    );
  }

  // Header same as _buildHeaderText

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<LoginViewModel>(
        builder: (_, lvm, __) => ResponsiveLayout(
          mobile: _buildMobile(lvm),
          desktop: _buildMobile(lvm), tablet: _buildMobile(lvm),
        ),
      ),
    );
  }

  Widget _buildMobile(LoginViewModel lvm) {
    return SingleChildScrollView(child: Column(children: [
      // Image animation
      Padding(padding: const EdgeInsets.fromLTRB(30, 40, 30, 40), child: Column(children: [
        _buildHeaderText('Verify OTP', 'Enter the 4-digit code sent to your mobile'),
        const SizedBox(height: 40),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(4, (i) => _buildOtpDigitBox(i, lvm))),
        const SizedBox(height: 40),
        CustomButton(
          text: 'Verify OTP',
          onPressed: lvm.verifyOtpStatus.status == ApiResponse.loading ? null : _handleVerifyOtp,
          isLoading: lvm.verifyOtpStatus.status == ApiResponse.loading,
        ),
        const SizedBox(height: 10),
        TextButton(onPressed: () => context.go('/send-otp'), child: const Text('Change Mobile Number')),
        if (lvm.counter > 0) Text('Resend OTP in ${lvm.counter}s'), // Timer display
      ])),
    ]));
  }

  // Desktop similar with side image + card

  void _handleVerifyOtp() async {
    await context.read<LoginViewModel>().fetchVerifyOtp();
    final lvm = context.read<LoginViewModel>();
    if (lvm.verifyOtpStatus.status == ApiResponse.completed && lvm.isLoggedIn) {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ActivityTrackerDashboard()
    //   EditActivityScreen(vm: _activityViewModel,)
       ));
    } else if (lvm.verifyOtpStatus.status == ApiResponse.error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lvm.verifyOtpStatus.message ?? 'Error')));
    }
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
}