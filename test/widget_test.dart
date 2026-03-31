import 'package:flutter_test/flutter_test.dart';

import 'package:bhasha_ai/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('app theme builds without throwing', () {
    final theme = buildAppTheme();
    expect(theme.scaffoldBackgroundColor, isNotNull);
  });
}
