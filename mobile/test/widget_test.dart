import 'package:dinarwise/app.dart';
import 'package:dinarwise/features/auth/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('shows global login portal', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(_TestAuthController.new),
        ],
        child: const DinarWiseApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('DinarWise'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('New to DinarWise? Create account'), findsOneWidget);
  });
}

class _TestAuthController extends AuthController {
  @override
  Future<AuthSession?> build() async => null;
}
