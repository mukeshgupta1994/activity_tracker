import 'package:activity_tracker/components/custom_button.dart';
import 'package:activity_tracker/components/custom_textfield.dart';
import 'package:activity_tracker/data/local/db/themedata/db_client.dart';
import 'package:activity_tracker/data/remote/network/network_api_service.dart';
import 'package:activity_tracker/repository/api_repository.dart';
import 'package:activity_tracker/repository/db_repository.dart';
import 'package:activity_tracker/view/homescreen/home_screen.dart';
import 'package:activity_tracker/view/homescreen/widget/activity_screen.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum LoginStep { mobile, otp }

class LoginResponse {
  final int result;
  final String remarks;
  const LoginResponse({required this.result, required this.remarks});
}

class AuthManager {
  // Mock API calls.
  Future<LoginResponse> sendOtp(String mobile) async {
    // Is jagah real API call HTTP / Dio se karo.
    await Future.delayed(const Duration(milliseconds: 1000));
    return const LoginResponse(result: 1, remarks: "OTP sent successfully");
  }

  Future<LoginResponse> verifyOtp(String mobile, String otp) async {
    // Is jagah real API call HTTP / Dio se karo.
    await Future.delayed(const Duration(milliseconds: 1000));
    if (otp == "1234") {
      return const LoginResponse(result: 1, remarks: "Login successful");
    } else {
      return const LoginResponse(result: 0, remarks: "Invalid OTP");
    }
  }

  void setAuthState(LoginResponse response) {
    // Tum chaho to yahan SharedPreferences / SecureStorage / app state me store karo
  }
}

// Global AuthManager instance (tum baad me GetIt/Provider/etc. se manage kar sakte ho)
final authManager = AuthManager();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late ActivityDashViewModel _activityDashViewModel;
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
    final dbRepo = DbRepository(DbClient());
    final httpClient = http.Client();
    final apiService = NetworkApiService(dbRepo, httpClient);
    final apiRepo = ApiRepository(apiService); // apna

    _activityDashViewModel = ActivityDashViewModel(
      apiRepository: apiRepo,
      dbRepository: dbRepo,
    );
    _mainAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    const curve = Curves.easeOutQuart;

    _imageFade = CurvedAnimation(
      parent: _mainAnimController,
      curve: const Interval(0.0, 0.4, curve: curve),
    );
    _imageSlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainAnimController,
            curve: const Interval(0.0, 0.4, curve: curve),
          ),
        );

    _titleFade = CurvedAnimation(
      parent: _mainAnimController,
      curve: const Interval(0.2, 0.6, curve: curve),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainAnimController,
            curve: const Interval(0.2, 0.6, curve: curve),
          ),
        );

    _subtextFade = CurvedAnimation(
      parent: _mainAnimController,
      curve: const Interval(0.3, 0.7, curve: curve),
    );
    _subtextSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainAnimController,
            curve: const Interval(0.3, 0.7, curve: curve),
          ),
        );

    _formFade = CurvedAnimation(
      parent: _mainAnimController,
      curve: const Interval(0.4, 1.0, curve: curve),
    );
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainAnimController,
            curve: const Interval(0.4, 1.0, curve: curve),
          ),
        );

    _mainAnimController.forward();
  }

  @override
  void dispose() {
    _mainAnimController.dispose();
    _mobileController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleSendOtp() async {
    if (_mobileController.text.length < 10) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_buildSnackBar('Please enter a valid mobile number'));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await authManager.sendOtp(_mobileController.text);

      if (mounted) setState(() => _isLoading = false);

      if (response.result == 1) {
        if (mounted) {
          setState(() {
            _currentStep = LoginStep.otp;
          });
        }
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) _otpFocusNodes[0].requestFocus();
        });
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(_buildSnackBar(response.remarks));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(_buildSnackBar(e.toString()));
      }
    }
  }

  void _handleVerifyOtp() async {
    // late ActivityDashViewModel _activityViewModel;

    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_buildSnackBar('Please enter the 4-digit OTP'));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await authManager.verifyOtp(_mobileController.text, otp);

      if (mounted) setState(() => _isLoading = false);

      if (response.result == 1) {
        authManager.setAuthState(response);
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditActivityScreen(vm: _activityDashViewModel),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(_buildSnackBar(response.remarks));
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(_buildSnackBar(e.toString()));
      }
    }
  }

  SnackBar _buildSnackBar(String message) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _currentStep == LoginStep.mobile
                    ? _buildMobileInput()
                    : _buildOtpInput(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileInput() {
    return Column(
      key: const ValueKey('mobile_input'),
      children: [
        _buildHeaderText('Welcome', 'Enter your mobile number to continue'),
        const SizedBox(height: 40),
        FadeTransition(
          opacity: _formFade,
          child: SlideTransition(
            position: _formSlide,
            child: Column(
              children: [
                CustomTextField(
                  controller: _mobileController,
                  hint: 'Mobile Number',
                  icon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Send OTP',
                  onPressed: _handleSendOtp,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Column(
      key: const ValueKey('otp_input'),
      children: [
        _buildHeaderText(
          'Verify OTP',
          'Enter the 4-digit code sent to your mobile',
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) => _buildOtpDigitBox(index)),
        ),
        const SizedBox(height: 40),
        CustomButton(
          text: 'Verify OTP',
          onPressed: _handleVerifyOtp,
          isLoading: _isLoading,
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            setState(() {
              _currentStep = LoginStep.mobile;
              for (var controller in _otpControllers) {
                controller.clear();
              }
            });
          },
          child: const Text(
            'Change Mobile Number',
            style: TextStyle(
              color: Color(0xFF7D7D8F),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

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

  Widget _buildOtpDigitBox(int index) {
    return Container(
      width: 65,
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _otpFocusNodes[index].hasFocus
              ? const Color(0xFF2f3192)
              : const Color(0xFFEDEDF5),
          width: 2,
        ),
        boxShadow: _otpFocusNodes[index].hasFocus
            ? [
                BoxShadow(
                  color: const Color(0xFF3D3BF3).withValues(alpha: 0.1),
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
}
