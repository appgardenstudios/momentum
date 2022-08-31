import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'dart:io' show Directory;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:momentum/main.dart';
import 'package:momentum/wren.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("test app", (WidgetTester tester) async {
    // Initialize
    final Directory result = await getApplicationSupportDirectory();
    tester.printToConsole(result.absolute.path);
    await Wren.init(path: join(result.path, 'momentum.db'));
    await tester.pumpWidget(App());
    await tester.pumpAndSettle();

    // await Future<void>.delayed(const Duration(seconds: 20));
    // expect(2 + 2, equals(5));
  });
}
