import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'screens/onboarding.dart';
import 'screens/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/lists.dart';
import 'screens/auth/login.dart';
import 'screens/auth/registration.dart';
import 'screens/auth/otp.dart';
import 'screens/customers/add_customer.dart';
import 'screens/orders/order_tracking.dart';
import 'screens/billing/billing_page.dart';
import 'screens/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    const coral = Color(0xFFFF6B3A);
    const lightGray = Color(0xFFF8FAFC);
    return MaterialApp(
      title: 'Crama',
      theme: ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        }),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: teal,
          onPrimary: Colors.white,
          secondary: coral,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          surface: lightGray,
          onSurface: Colors.black87,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: teal,
          elevation: 0,
        ),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: teal),
          titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: teal),
          bodyMedium: GoogleFonts.poppins(color: Colors.black87),
        ),
        cardTheme: CardTheme(
          color: lightGray,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
          elevation: 0,
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == OnboardingScreen.routeName) {
          return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const OnboardingScreen(),
          );
        }
        if (settings.name == HomePage.routeName) {
          return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const HomePage(),
          );
        }
        if (settings.name == LoginScreen.routeName) {
          return PageTransition(type: PageTransitionType.rightToLeft, child: const LoginScreen());
        }
        if (settings.name == ShopRegistrationScreen.routeName) {
          return PageTransition(type: PageTransitionType.rightToLeft, child: const ShopRegistrationScreen());
        }
        if (settings.name == OtpScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>?;
          final phone = args?['phone'] as String? ?? '';
          return PageTransition(type: PageTransitionType.rightToLeft, child: OtpScreen(phone: phone));
        }
        if (settings.name == CustomersListScreen.routeName) {
          return PageTransition(type: PageTransitionType.rightToLeft, child: const CustomersListScreen());
        }
        if (settings.name == AddCustomerScreen.routeName) {
          return PageTransition(type: PageTransitionType.rightToLeft, child: const AddCustomerScreen());
        }
        if (settings.name == OrdersListScreen.routeName) {
          return PageTransition(type: PageTransitionType.rightToLeft, child: const OrdersListScreen());
        }
        if (settings.name == OrderTrackingScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>?;
          return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: OrderTrackingScreen(
              orderId: (args?['orderId'] as String?) ?? 'Order',
              customerName: (args?['customerName'] as String?) ?? 'Customer',
              customerPhone: args?['customerPhone'] as String?,
              expectedDate: (args?['expectedDate'] as DateTime?) ?? DateTime.now().add(const Duration(days: 5)),
              balanceAmount: (args?['balanceAmount'] as int?) ?? 0,
              initialStageIndex: args?['initialStageIndex'] as int?,
            ),
          );
        }
        if (settings.name == StaffListScreen.routeName) {
          return PageTransition(type: PageTransitionType.rightToLeft, child: const StaffListScreen());
        }
        if (settings.name == BillingScreen.routeName) {
          return PageTransition(type: PageTransitionType.rightToLeft, child: const BillingScreen());
        }
        if (settings.name == SettingsScreen.routeName) {
          return PageTransition(type: PageTransitionType.rightToLeft, child: const SettingsScreen());
        }
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      },
      home: const SplashScreen(),
    );
  }
}
