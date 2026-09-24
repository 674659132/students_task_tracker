import 'package:flutter/material.dart';

void main() {
  runApp(const StudentsTaskTrackerApp());
}

// -----------------------------------------------------------------------------
// SYSTEM: Language State Management (ระบบจัดการภาษา EN / TH ทั่วแอป)
// -----------------------------------------------------------------------------
class LanguageNotifier extends ValueNotifier<bool> {
  LanguageNotifier() : super(false); // false = English, true = Thai

  void toggle() => value = !value;
}

final languageNotifier = LanguageNotifier();

class StudentsTaskTrackerApp extends StatelessWidget {
  const StudentsTaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isThai, child) {
        return MaterialApp(
          title: 'Students Task Tracker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFEFF4FC),
            fontFamily: 'Roboto',
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

// Helper สำหรับแปลข้อความ
String tr(String en, String th) {
  return languageNotifier.value ? th : en;
}

// Widget ปุ่มสลับภาษา (EN / TH) ทั่วโลก
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isThai, child) {
        return InkWell(
          onTap: () => languageNotifier.toggle(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF196CD8),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Text(
              isThai ? 'EN' : 'TH',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// 1. SPLASH SCREEN
// =============================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF196CD8),
      body: Stack(
        children: [
          const Center(child: AppLogoBadge(size: 160)),
          Positioned(top: 40, right: 20, child: const LanguageToggleButton()),
        ],
      ),
    );
  }
}

class AppLogoBadge extends StatelessWidget {
  final double size;
  const AppLogoBadge({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF196CD8),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.school, color: Colors.white, size: 36),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.menu_book, color: Colors.white, size: 28),
              SizedBox(width: 6),
              Icon(Icons.check_circle, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 2),
          const Text('STUDENTS TASK TRACKER', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
          const Text('EFFICIENCY THROUGH EDUCATION', style: TextStyle(color: Colors.white70, fontSize: 6)),
        ],
      ),
    );
  }
}

// =============================================================================
// 2. SIGN IN SCREEN
// =============================================================================
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [LanguageToggleButton()],
                      ),
                      const Center(child: AppLogoBadge(size: 130)),
                      const SizedBox(height: 24),
                      Text(tr('Email', 'อีเมล'), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF196CD8), fontSize: 16)),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: tr('Email', 'อีเมล'),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(tr('Password', 'รหัสผ่าน'), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF196CD8), fontSize: 16)),
                      const SizedBox(height: 8),
                      TextField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v ?? false)),
                              Text(tr('Remember me', 'จดจำฉันไว้')),
                            ],
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
                            child: Text(tr('Forgot Password?', 'ลืมรหัสผ่าน?'), style: const TextStyle(color: Color(0xFF9C27B0), fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainDashboardScreen())),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF196CD8), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Text(tr('Sign In', 'เข้าสู่ระบบ'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(child: Divider(color: Color(0xFF196CD8), thickness: 1)),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(tr('Sign in with', 'เข้าสู่ระบบด้วย'), style: const TextStyle(color: Color(0xFF196CD8), fontWeight: FontWeight.w600))),
                          const Expanded(child: Divider(color: Color(0xFF196CD8), thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialBtn('G', Colors.red),
                          const SizedBox(width: 24),
                          _socialBtn('f', Colors.blue),
                          const SizedBox(width: 24),
                          _socialBtn('', Colors.black),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(tr('New User? ', 'ยังไม่มีบัญชี? ')),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                            child: Text(tr('Create Here!', 'สร้างบัญชีที่นี่!'), style: const TextStyle(color: Color(0xFF9C27B0), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _socialBtn(String label, Color color) {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6)]),
      child: Center(child: Text(label, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color))),
    );
  }
}

// =============================================================================
// 3. SIGN UP SCREEN
// =============================================================================
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                          const LanguageToggleButton(),
                        ],
                      ),
                      const Center(child: AppLogoBadge(size: 110)),
                      const SizedBox(height: 24),
                      Text(tr('Full Name*', 'ชื่อ-นามสกุล*'), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF196CD8), fontSize: 15)),
                      const SizedBox(height: 6),
                      TextField(decoration: InputDecoration(hintText: tr('Name', 'ชื่อ'), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
                      const SizedBox(height: 16),
                      Text(tr('Email Address*', 'ที่อยู่อีเมล*'), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF196CD8), fontSize: 15)),
                      const SizedBox(height: 6),
                      TextField(decoration: InputDecoration(hintText: tr('Email', 'อีเมล'), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
                      const SizedBox(height: 16),
                      Text(tr('Password*', 'รหัสผ่าน*'), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF196CD8), fontSize: 15)),
                      const SizedBox(height: 6),
                      TextField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
                        ),
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainDashboardScreen())),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF196CD8), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Text(tr('Sign Up', 'สมัครสมาชิก'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// 4. FORGOT PASSWORD SCREEN
// =============================================================================
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                          const LanguageToggleButton(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          width: 90, height: 90,
                          decoration: const BoxDecoration(color: Color(0xFF196CD8), shape: BoxShape.circle),
                          child: const Icon(Icons.lock, color: Colors.white, size: 45),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(tr('Forgot Password?', 'ลืมรหัสผ่าน?'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF196CD8))),
                      const SizedBox(height: 8),
                      Text(tr("Don't worry! We will send you the reset instruction!", "ไม่ต้องกังวล! เราจะส่งคำแนะนำในการรีเซ็ตรหัสผ่านให้คุณ"), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF5C93E8), fontWeight: FontWeight.w500)),
                      const SizedBox(height: 36),
                      Text(tr('Email Address', 'ที่อยู่อีเมล'), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF196CD8), fontSize: 15)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: TextEditingController(text: 'SirWilliam@gmail.com'),
                        decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OtpVerificationScreen())),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF196CD8), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Text(tr('Send Code', 'ส่งรหัสยืนยัน'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// 5. OTP VERIFICATION SCREEN
// =============================================================================
class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                          const LanguageToggleButton(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(color: const Color(0xFF196CD8), borderRadius: BorderRadius.circular(20)),
                          child: const Icon(Icons.email, color: Colors.white, size: 45),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(tr('Check Your Email!', 'ตรวจสอบอีเมลของคุณ!'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF196CD8))),
                      const SizedBox(height: 8),
                      Text(tr('We sent the verification code to\nSirWilliam@gmail.com', 'เราได้ส่งรหัสยืนยันไปที่\nSirWilliam@gmail.com'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF5C93E8), fontWeight: FontWeight.w500, height: 1.4)),
                      const SizedBox(height: 36),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          _OtpBox('1', true), _OtpBox('7', true), _OtpBox('9', true),
                          _OtpBox('', false), _OtpBox('', false), _OtpBox('', false),
                        ],
                      ),
                      const SizedBox(height: 36),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordScreen())),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF196CD8), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Text(tr('Verify', 'ยืนยันรหัส'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OtpBox extends StatelessWidget {
  final String digit;
  final bool filled;
  const _OtpBox(this.digit, this.filled);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46, height: 56,
      decoration: BoxDecoration(color: filled ? const Color(0xFFE5EBF5) : Colors.white, borderRadius: BorderRadius.circular(16)),
      alignment: Alignment.center,
      child: Text(digit, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}

// =============================================================================
// 6. RESET PASSWORD SCREEN
// =============================================================================
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                          const LanguageToggleButton(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 90, height: 90,
                          decoration: const BoxDecoration(color: Color(0xFF196CD8), shape: BoxShape.circle),
                          child: const Icon(Icons.lock, color: Colors.white, size: 45),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(tr('Reset Password', 'ตั้งรหัสผ่านใหม่'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF196CD8))),
                      const SizedBox(height: 8),
                      Text(tr('Set a strong but memorable password\nfor secure and easy access!', 'ตั้งรหัสผ่านที่รัดกุมและจดจำง่าย\nเพื่อความปลอดภัยในการเข้าใช้งาน!'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF5C93E8), fontWeight: FontWeight.w500, height: 1.4)),
                      const SizedBox(height: 32),
                      Text(tr('New Password', 'รหัสผ่านใหม่'), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF196CD8), fontSize: 15)),
                      const SizedBox(height: 8),
                      TextField(
                        obscureText: _obscure1,
                        decoration: InputDecoration(
                          hintText: '••••••••', filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          suffixIcon: IconButton(icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure1 = !_obscure1)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(tr('Confirm Password', 'ยืนยันรหัสผ่าน'), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF196CD8), fontSize: 15)),
                      const SizedBox(height: 8),
                      TextField(
                        obscureText: _obscure2,
                        decoration: InputDecoration(
                          hintText: '••••••••', filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          suffixIcon: IconButton(icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure2 = !_obscure2)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordChangedScreen())),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF196CD8), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Text(tr('Save', 'บันทึก'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// 7. PASSWORD CHANGED SCREEN
// =============================================================================
class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 90, height: 90,
                          decoration: const BoxDecoration(color: Color(0xFF196CD8), shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: Colors.white, size: 50),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(tr('Password Changed!', 'เปลี่ยนรหัสผ่านสำเร็จ!'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF196CD8))),
                      const SizedBox(height: 12),
                      Text(tr('Your password has been successfully changed!\nPlease remember it this time!', 'รหัสผ่านของคุณถูกเปลี่ยนเรียบร้อยแล้ว!\nกรุณาจดจำให้ดีในครั้งนี้!'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: Color(0xFF5C93E8), fontWeight: FontWeight.w500, height: 1.4)),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainDashboardScreen()), (route) => false),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF196CD8), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Text(tr('Continues', 'ดำเนินการต่อ'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// 8. MAIN DASHBOARD WITH DYNAMIC REBUILD FOR LANGUAGE TOGGLE
// =============================================================================
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // สร้างรายการหน้าจอใหม่ทุกครั้งที่ภาษาเปลี่ยน เพื่อให้ UI ทุกหน้าจออัปเดตทันที
    final List<Widget> screens = [
      const HomeScreen(),
      const CoursesScreen(),
      const CalendarScreen(),
      const ProfileAnalyticalScreen(),
    ];

    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return Scaffold(
          body: screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: const Color(0xFFEFF4FC),
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF196CD8),
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.home), label: tr('Home', 'หน้าหลัก')),
              BottomNavigationBarItem(icon: const Icon(Icons.folder), label: tr('Courses', 'รายวิชา')),
              BottomNavigationBarItem(icon: const Icon(Icons.calendar_today), label: tr('Calendar', 'ปฏิทิน')),
              BottomNavigationBarItem(icon: const Icon(Icons.person), label: tr('Profile', 'โปรไฟล์')),
            ],
          ),
        );
      },
    );
  }
}

// --- TAB 1: HOME ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      {'title': 'IoT & Mobile App', 'due': tr('Due Tomorrow 23:59', 'ครบกำหนดพรุ่งนี้ 23:59'), 'priority': 'HIGH', 'color': Colors.blue},
      {'title': 'Eng A+', 'due': tr('Due Today 23:59', 'ครบกำหนดวันนี้ 23:59'), 'priority': 'MEDIUM', 'color': Colors.orange},
      {'title': 'Control System', 'due': tr('Due Fri 13:00', 'ครบกำหนดวันศุกร์ 13:00'), 'priority': 'LOW', 'color': Colors.green},
      {'title': 'Electronics Engineering', 'due': tr('Due Thu 16:00', 'ครบกำหนดวันพฤหัส 16:00'), 'priority': 'MEDIUM', 'color': Colors.brown},
    ];

    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr('Monday, Sep 7th', 'วันจันทร์ ที่ 7 ก.ย.'), style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(tr('Welcome, User!', 'ยินดีต้อนรับ, ผู้ใช้!'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                    Row(
                      children: [
                        const LanguageToggleButton(),
                        const SizedBox(width: 8),
                        const CircleAvatar(radius: 20, backgroundColor: Colors.blueGrey, child: Icon(Icons.person, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _progressCard(tr('TODAY TASKS', 'งานวันนี้'), '1 ' + tr('OUT OF', 'จาก') + ' 3', tr('Complete', 'เสร็จสิ้น'), Colors.blue, 0.33)),
                    const SizedBox(width: 16),
                    Expanded(child: _progressCard(tr('WEEKLY TASKS', 'งานสัปดาห์นี้'), '1 ' + tr('OUT OF', 'จาก') + ' 7', tr('Complete', 'เสร็จสิ้น'), Colors.orange, 0.14)),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('MY TASKS', 'งานของฉัน'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Color(0xFFE65100), size: 36),
                      onPressed: () => _showAddTaskModal(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...tasks.map((t) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Container(width: 32, height: 32, decoration: BoxDecoration(color: t['color'] as Color, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.check, color: Colors.white, size: 20)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${t['due']} | ${t['priority']}', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _progressCard(String title, String fraction, String sub, Color color, double val) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fraction, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 4),
                  Text(sub, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
                ],
              ),
              CircularProgressIndicator(value: val, valueColor: AlwaysStoppedAnimation<Color>(color), backgroundColor: color.withOpacity(0.2)),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFEFF4FC),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.close, color: Colors.grey, size: 28), onPressed: () => Navigator.pop(context)),
                  Text(tr('ADD TASK', 'เพิ่มงาน'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(width: 28),
                ],
              ),
              const SizedBox(height: 20),
              Text(tr('TASK TITLE', 'ชื่อหัวข้องาน'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 6),
              TextField(decoration: InputDecoration(hintText: tr('Task Title', 'ชื่อหัวข้องาน'), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              const SizedBox(height: 16),
              Text(tr('COURSES', 'รายวิชา'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('IoT & Mobile App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(tr('DATE', 'วันที่'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('7/9/2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Icon(Icons.calendar_today, color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(tr('PRIORITY', 'ระดับความสำคัญ'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: Text(tr('LOW', 'ต่ำ'), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)))),
                  const SizedBox(width: 8),
                  Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: Text(tr('MEDIUM', 'ปานกลาง'), style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)))),
                  const SizedBox(width: 8),
                  Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: Text(tr('HIGH', 'สูง'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF196CD8), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: Text(tr('CREATE TASK', 'สร้างงาน'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(tr('CANCEL', 'ยกเลิก'), style: const TextStyle(color: Color(0xFF196CD8), fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// --- TAB 2: COURSES ---
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {'title': 'IoT & Mobile App', 'color': const Color(0xFF196CD8), 'assignments': tr('7 Assignment', '7 งานที่มอบหมาย'), 'tests': tr('1 Test', '1 การทดสอบ'), 'totalA': tr('10 Assignment', 'ทั้งหมด 10 งาน'), 'progress': 0.7},
      {'title': 'Eng A+\nClass ID: 1u34t', 'color': const Color(0xFFD36B41), 'assignments': tr('8 Assignment', '8 งานที่มอบหมาย'), 'tests': tr('2 Test', '2 การทดสอบ'), 'totalA': tr('11 Assignment', 'ทั้งหมด 11 งาน'), 'progress': 0.8},
      {'title': 'Control System', 'color': const Color(0xFF4CAF50), 'assignments': tr('5 Assignment', '5 งานที่มอบหมาย'), 'tests': tr('1 Test', '1 การทดสอบ'), 'totalA': tr('7 Assignment', 'ทั้งหมด 7 งาน'), 'progress': 0.6},
      {'title': 'Electronic Engineering', 'color': const Color(0xFF8D2C2C), 'assignments': tr('6 Assignment', '6 งานที่มอบหมาย'), 'tests': tr('1 Test', '1 การทดสอบ'), 'totalA': tr('8 Assignment', 'ทั้งหมด 8 งาน'), 'progress': 0.75},
    ];

    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('COURSES', 'รายวิชา'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Row(
                      children: [
                        const LanguageToggleButton(),
                        const SizedBox(width: 8),
                        const CircleAvatar(radius: 20, backgroundColor: Colors.blueGrey, child: Icon(Icons.person, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final c = courses[index];
                    return Container(
                      decoration: BoxDecoration(color: c['color'] as Color, borderRadius: BorderRadius.circular(20)),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(c['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tr('Progress', 'ความคืบหน้า'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 6),
                                  LinearProgressIndicator(value: c['progress'] as double, valueColor: AlwaysStoppedAnimation<Color>(c['color'] as Color), backgroundColor: Colors.grey[200]),
                                  const SizedBox(height: 10),
                                  Text(c['assignments'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text(c['tests'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  const Divider(height: 16),
                                  Text(tr('Total', 'ทั้งหมด'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                                  Text(c['totalA'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- TAB 3: CALENDAR ---
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('CALENDAR', 'ปฏิทิน'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Row(
                      children: [
                        const LanguageToggleButton(),
                        const SizedBox(width: 8),
                        const CircleAvatar(radius: 20, backgroundColor: Colors.blueGrey, child: Icon(Icons.person, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                Text(tr('SEPTEMBER', 'กันยายน'), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(tr('Mon', 'จ.'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
                          Text(tr('Tue', 'อ.'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
                          Text(tr('Wed', 'พ.'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
                          Text(tr('Thu', 'พฤ.'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
                          Text(tr('Fri', 'ศ.'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
                          Text(tr('Sat', 'ส.'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
                          Text(tr('Sun', 'อา.'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
                        ],
                      ),
                      const Divider(height: 20),
                      _calendarRow([('7', Colors.amber), ('8', Colors.red), ('9', Colors.green), ('10', null), ('11', Colors.red), ('12', null), ('13', null)]),
                      _calendarRow([('14', null), ('15', Colors.green), ('16', Colors.amber), ('17', Colors.green), ('18', null), ('19', null), ('20', null)]),
                      _calendarRow([('21', Colors.amber), ('22', null), ('23', null), ('24', Colors.red), ('25', null), ('26', null), ('27', null)]),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(tr('UPCOMING DEADLINE', 'กำหนดส่งที่กำลังจะมาถึง'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 12),
                _deadlineCard(tr('Sep', 'ก.ย.'), '7', 'Coding', 'IoT & Mobile App | 8:30', Colors.amber),
                _deadlineCard(tr('Sep', 'ก.ย.'), '8', 'MidTerm Exam', 'Eng A+ | 13:30', Colors.red),
                _deadlineCard(tr('Sep', 'ก.ย.'), '9', 'Presentation', 'Control System | 10:00', Colors.green),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _calendarRow(List<(String, Color?)> days) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((d) {
          return Column(
            children: [
              Text(d.$1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Container(width: 6, height: 6, decoration: BoxDecoration(color: d.$2 ?? Colors.transparent, shape: BoxShape.circle)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _deadlineCard(String month, String day, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Column(
            children: [
              Text(month, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(day, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          Container(height: 35, width: 2, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 16)),
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- TAB 4: PROFILE / ANALYTICAL ---
class ProfileAnalyticalScreen extends StatelessWidget {
  const ProfileAnalyticalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('ANALYTICAL', 'วิเคราะห์สถิติ'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Row(
                      children: [
                        const LanguageToggleButton(),
                        const SizedBox(width: 8),
                        const CircleAvatar(radius: 20, backgroundColor: Colors.blueGrey, child: Icon(Icons.person, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr('TASK COMPLETION RATE', 'อัตราการส่งงานสำเร็จ'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 8),
                      const Text('70%', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr('WEEKLY PRODUCTIVITY', 'ประสิทธิภาพรายสัปดาห์'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LegendDot(color: Colors.blue, label: tr('On-Time Submission', 'ส่งตรงเวลา เก่งมาก')),
                          const SizedBox(width: 16),
                          _LegendDot(color: Colors.amber, label: tr('Late Submission', 'ส่งช้ามาก')),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _barItem('Mon', 0.7, 0.15, 0.15),
                            _barItem('Tue', 0.6, 0.25, 0.15),
                            _barItem('Wed', 0.8, 0.1, 0.1),
                            _barItem('Thu', 0.6, 0.2, 0.2),
                            _barItem('Fri', 0.8, 0.1, 0.1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _barItem(String day, double blueH, double yellowH, double redH) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: 120,
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(width: 32, height: 120 * redH, color: Colors.red),
              Container(width: 32, height: 120 * yellowH, color: Colors.amber),
              Container(width: 32, height: 120 * blueH, color: Colors.blue),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }
}