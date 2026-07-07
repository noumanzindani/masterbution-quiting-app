import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';

import '../../config.dart';
import '../../providers/settings_provider.dart';

/// Arguments controlling how [LockScreen] behaves.
class LockArgs {
  const LockArgs({this.setup = false, this.popOnSuccess = false});

  /// true → capture + confirm a new PIN (from Settings). false → unlock.
  final bool setup;

  /// true → pop on success (resume re-lock). false → replace with home (launch).
  final bool popOnSuccess;
}

/// The app-lock gate: set a PIN, or unlock via PIN / biometrics. NO-AD route
/// ('lock' is in [AdPolicy.noAdRoutes]).
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  final _auth = LocalAuthentication();

  String? _firstPin; // setup: the first entry awaiting confirmation
  String? _error;
  bool _triedBiometric = false;

  LockArgs get _args =>
      (ModalRoute.of(context)?.settings.arguments as LockArgs?) ??
      const LockArgs();

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Clear the field and re-focus it. Pinput's `autofocus` only fires on first
  /// mount, so after a completed/failed entry we must request focus again or
  /// the keyboard silently ignores input.
  void _resetInput() {
    _pinController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Offer biometrics once, automatically, when unlocking.
    if (!_args.setup && !_triedBiometric) {
      _triedBiometric = true;
      final settings = context.read<SettingsProvider>();
      if (settings.biometricEnabled) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _biometric());
      }
    }
  }

  Future<void> _biometric() async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: 'Unlock Momentum',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      if (ok) _succeed();
    } catch (_) {
      // Fall back to PIN silently.
    }
  }

  void _onCompleted(String pin) {
    final settings = context.read<SettingsProvider>();
    if (_args.setup) {
      _handleSetup(pin, settings);
    } else {
      if (settings.verifyPin(pin)) {
        _succeed();
      } else {
        _fail('That PIN didn’t match. Try again.');
      }
    }
  }

  Future<void> _handleSetup(String pin, SettingsProvider settings) async {
    if (_firstPin == null) {
      setState(() {
        _firstPin = pin;
        _error = null;
      });
      _resetInput();
      return;
    }
    if (pin == _firstPin) {
      await settings.setPin(pin);
      if (mounted) route.pop(context, true);
    } else {
      setState(() => _firstPin = null);
      _fail('The PINs didn’t match. Start again.');
    }
  }

  void _fail(String message) {
    setState(() => _error = message);
    _resetInput();
  }

  void _succeed() {
    if (!mounted) return;
    if (_args.popOnSuccess) {
      route.pop(context);
    } else {
      route.pushReplacement(context, routeName.home);
    }
  }

  String get _title {
    if (!_args.setup) return 'Enter your PIN';
    return _firstPin == null ? 'Create a PIN' : 'Confirm your PIN';
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final settings = context.watch<SettingsProvider>();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: appCss.headingBold22.textColor(theme.darkText),
      decoration: BoxDecoration(
        color: theme.fieldBg,
        borderRadius: BorderRadius.circular(14),
      ),
    );

    return PopScope(
      // Can't dismiss the lock when unlocking; setup can be cancelled.
      canPop: _args.setup,
      child: Scaffold(
        backgroundColor: theme.scaffoldBg,
        appBar: _args.setup
            ? AppBar(leading: const BackButton())
            : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: theme.primarySoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.lock_outline_rounded,
                      size: 34, color: theme.primary),
                ),
                const SizedBox(height: 24),
                Text(_title,
                    style: appCss.headingBold22.textColor(theme.darkText)),
                const SizedBox(height: 8),
                Text(
                  _args.setup
                      ? 'You’ll enter this to open the app.'
                      : 'Your data is private on this device.',
                  textAlign: TextAlign.center,
                  style: appCss.body14.textColor(theme.lightText),
                ),
                const SizedBox(height: 28),
                Pinput(
                  length: 4,
                  controller: _pinController,
                  focusNode: _focusNode,
                  obscureText: true,
                  autofocus: true,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: theme.primary, width: 2),
                    ),
                  ),
                  onCompleted: _onCompleted,
                ),
                const SizedBox(height: 16),
                if (_error != null)
                  Text(_error!,
                      style: appCss.medium14.textColor(theme.danger)),
                if (!_args.setup && settings.biometricEnabled) ...[
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _biometric,
                    icon: Icon(Icons.fingerprint_rounded, color: theme.primary),
                    label: Text('Use biometrics',
                        style: appCss.buttonSemi16.textColor(theme.primary)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
