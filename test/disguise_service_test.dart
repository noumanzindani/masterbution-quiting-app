import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/disguise_service.dart';

/// The DisguiseService is the thin Dart side of the native alternate-icon /
/// activity-alias switch. We can't exercise the real platform code in a unit
/// test, but we CAN pin the contract it speaks: the method name, the argument
/// shape, and that a platform failure never bubbles up (the persisted pref is
/// the source of truth, so a device that can't switch icons must degrade
/// quietly rather than crash the settings toggle).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.tideapp.momentum/disguise');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return true;
    });
  });

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  group('DisguiseService.apply', () {
    test('enabling asks the platform to switch on via setDiscreet(true)',
        () async {
      await const DisguiseService().apply(true);
      expect(calls, hasLength(1));
      expect(calls.single.method, 'setDiscreet');
      expect((calls.single.arguments as Map)['enabled'], isTrue);
    });

    test('disabling asks the platform to restore via setDiscreet(false)',
        () async {
      await const DisguiseService().apply(false);
      expect(calls.single.method, 'setDiscreet');
      expect((calls.single.arguments as Map)['enabled'], isFalse);
    });

    test('swallows platform errors so the toggle never crashes', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        throw PlatformException(code: 'ICON_ERROR', message: 'no support');
      });
      // Must complete normally despite the platform throwing.
      await expectLater(const DisguiseService().apply(true), completes);
    });

    test('swallows a missing platform implementation (e.g. under tests)',
        () async {
      messenger.setMockMethodCallHandler(channel, null); // no handler → Missing
      await expectLater(const DisguiseService().apply(true), completes);
    });
  });
}
