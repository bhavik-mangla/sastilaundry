import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/pages/profile.dart';
import '/pages/auth/authenticate.dart';
import '/pages/auth/forgetPassword.dart';
import '/providers/sign.dart';
import 'package:provider/provider.dart';
import 'authentication/auth.dart';
import 'firebase_options.dart';
import '/pages/auth/sign_up.dart';
import '/pages/auth/sign_in.dart';
import '/pages/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthService().userChanges,
          initialData: null,
          updateShouldNotify: (_, __) => true,
        ),
        ChangeNotifierProvider<SignInOrRegister>(
          create: (_) => SignInOrRegister(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: 'Sasti Laundry',
        initialRoute: '/',
        routes: {
          '/': (context) => const Authenticate(),
          'signup': (context) => const SignUp(),
          'signin': (context) => const SignIn(),
          'home': (context) => HomeScreen(),
          'forgot': (context) => const ResetPassword(),
          'profile': (context) => const Profile(),
        },
      ),
    );
  }
}
