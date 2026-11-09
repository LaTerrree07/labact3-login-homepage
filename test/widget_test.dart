import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lim_lab3/main.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets(
    'Initial Login screen displays compact header, branding, form, and academic footer',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const LoginRegisterApp());

      // Verify compact header with graduation-cap icon and "Student Portal" (no duplicate banner)
      expect(find.text('Student Portal'), findsOneWidget);
      expect(find.byIcon(Icons.school_rounded), findsOneWidget);

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to your account.'), findsOneWidget);

      // Verify academic footer inside card separated by divider
      expect(find.text('Earth Justin Lim · CCE106 (3447)'), findsOneWidget);

      // Verify input fields and buttons
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
      expect(find.text('Create an account'), findsOneWidget);
    },
  );

  testWidgets(
    'Login form validation triggers for empty, invalid email, and short password',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const LoginRegisterApp());

      // 1. Submit empty form
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);

      // 2. Enter invalid email and short password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'notanemail',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '12345',
      );
      await tester.tap(signInButton);
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(
        find.text('Password must be at least 8 characters long'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Login attempt before registration displays appropriate error message',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const LoginRegisterApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@student.edu',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123',
      );
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      await tester.pump();

      expect(
        find.text(
          'No registered account found. Please create an account first.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('Toggle password visibility on login screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const LoginRegisterApp());

    // Initially obscureText is true
    final passwordTextFieldFinder = find.descendant(
      of: find.widgetWithText(TextFormField, 'Password'),
      matching: find.byType(TextField),
    );
    final TextField initialField = tester.widget(passwordTextFieldFinder);
    expect(initialField.obscureText, isTrue);

    // Tap visibility icon
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    final TextField visibleField = tester.widget(passwordTextFieldFinder);
    expect(visibleField.obscureText, isFalse);
  });

  testWidgets(
    'Registration form validation enforces all constraints and shows footer',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const LoginRegisterApp());

      // Switch to Register
      final createAccountLink = find.text('Create an account');
      await tester.ensureVisible(createAccountLink);
      await tester.tap(createAccountLink);
      await tester.pump();

      expect(find.text('Create an Account'), findsOneWidget);
      expect(find.text('Enter your details to get started.'), findsOneWidget);
      expect(find.text('Earth Justin Lim · CCE106 (3447)'), findsOneWidget);

      // 1. Submit empty form
      final createAccountButton = find.widgetWithText(
        ElevatedButton,
        'Create Account',
      );
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      await tester.pump();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);

      // 2. Short password and mismatching confirm password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Earth Justin Lim',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'earth@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'pass',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'pass2',
      );
      await tester.tap(createAccountButton);
      await tester.pump();

      expect(
        find.text('Password must be at least 8 characters long'),
        findsOneWidget,
      );
      expect(find.text('Passwords do not match'), findsOneWidget);
    },
  );

  testWidgets(
    'Full flow: Register, Duplicate prevention, Sign In, Welcome, and Sign Out',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const LoginRegisterApp());

      // 1. Switch to Register
      final createAccountLink = find.text('Create an account');
      await tester.ensureVisible(createAccountLink);
      await tester.tap(createAccountLink);
      await tester.pump();

      // 2. Register with valid details
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Earth Justin Lim',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'Earth@Example.Com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123',
      );

      final createAccountButton = find.widgetWithText(
        ElevatedButton,
        'Create Account',
      );
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      await tester.pump(); // Trigger frame for SnackBar and navigation

      // Verify returned to Login and success message displayed
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(
        find.text('Account created successfully. Please sign in.'),
        findsOneWidget,
      );

      // 3. Test Duplicate Registration Prevention
      await tester.ensureVisible(createAccountLink);
      await tester.tap(createAccountLink);
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Earth Lim',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'earth@example.com',
      ); // normalized
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123',
      );
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      await tester.pump();

      expect(
        find.text('An account with this email already exists. Please sign in.'),
        findsOneWidget,
      );

      // 4. Return to Login screen
      final signInLink = find.widgetWithText(TextButton, 'Sign In');
      await tester.ensureVisible(signInLink);
      await tester.tap(signInLink);
      await tester.pump();
      expect(find.text('Welcome Back'), findsOneWidget);

      // 5. Test incorrect password
      final emailLoginField = find.widgetWithText(TextFormField, 'Email');
      final passwordLoginField = find.widgetWithText(TextFormField, 'Password');
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');

      await tester.enterText(emailLoginField, 'earth@example.com');
      await tester.enterText(passwordLoginField, 'WrongPassword123');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      await tester.pump();

      expect(
        find.text('Invalid email or password. Please try again.'),
        findsOneWidget,
      );

      // 6. Test successful sign in with email normalization
      await tester.enterText(emailLoginField, '  EARTH@example.com  ');
      await tester.enterText(passwordLoginField, 'Password123');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // 7. Verify Welcome Screen contents
      expect(find.text('Welcome, Earth Justin Lim!'), findsOneWidget);
      expect(find.text('earth@example.com'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(find.text('You have successfully signed in.'), findsOneWidget);
      final signOutButton = find.widgetWithText(ElevatedButton, 'Sign Out');
      expect(signOutButton, findsOneWidget);

      // Verify academic footer is NOT on Welcome screen
      expect(find.text('Earth Justin Lim · CCE106 (3447)'), findsNothing);

      // 8. Sign Out
      await tester.ensureVisible(signOutButton);
      await tester.tap(signOutButton);
      await tester.pumpAndSettle();

      // Verify returned to Login screen
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Earth Justin Lim · CCE106 (3447)'), findsOneWidget);

      // 9. Verify account is preserved: signing in again succeeds
      await tester.enterText(passwordLoginField, 'Password123');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.text('Welcome, Earth Justin Lim!'), findsOneWidget);
    },
  );
}
