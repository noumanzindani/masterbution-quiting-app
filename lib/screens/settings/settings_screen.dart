import 'package:local_auth/local_auth.dart';

import '../../config.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../lock/lock_screen.dart';

/// Privacy, security and appearance settings. A non-crisis screen, so a banner
/// is allowed here (still policy-gated).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final settings = context.watch<SettingsProvider>();
    final themeService = context.watch<ThemeService>();

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text(language(context, appFonts.settings),
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _SectionLabel('Privacy & security', theme: theme),
          _SettingCard(
            theme: theme,
            children: [
              _SwitchRow(
                icon: Icons.lock_outline_rounded,
                title: 'App lock',
                subtitle: 'Require a PIN to open Momentum',
                value: settings.appLockEnabled,
                theme: theme,
                onChanged: (v) => _toggleLock(context, settings, v),
              ),
              if (settings.appLockEnabled) ...[
                _Divider(theme: theme),
                _SwitchRow(
                  icon: Icons.fingerprint_rounded,
                  title: 'Unlock with biometrics',
                  subtitle: 'Face ID / fingerprint',
                  value: settings.biometricEnabled,
                  theme: theme,
                  onChanged: (v) => _toggleBiometric(context, settings, v),
                ),
              ],
              _Divider(theme: theme),
              _SwitchRow(
                icon: Icons.visibility_off_outlined,
                title: 'Discreet mode',
                subtitle: 'Neutral name & icon (applied in a later update)',
                value: settings.discreetMode,
                theme: theme,
                onChanged: settings.setDiscreet,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel('Appearance', theme: theme),
          _SettingCard(
            theme: theme,
            children: [
              _ThemePicker(
                index: themeService.themeIndex,
                onChanged: themeService.setThemeIndex,
                theme: theme,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel('Reminders', theme: theme),
          _SettingCard(
            theme: theme,
            children: [
              _SwitchRow(
                icon: Icons.notifications_none_rounded,
                title: 'Smart reminders',
                subtitle:
                    'Gentle, private check-ins timed around your own patterns',
                value: settings.notificationsEnabled,
                theme: theme,
                onChanged: (v) => settings.setNotificationsEnabled(v),
              ),
              if (settings.notificationsEnabled) ...[
                _Divider(theme: theme),
                _LinkRow(
                  icon: Icons.schedule_rounded,
                  title: 'Daily check-in time',
                  trailing: _fmtHour(settings.checkInHour),
                  theme: theme,
                  onTap: () => _pickCheckInHour(context, settings),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel('Data', theme: theme),
          _SettingCard(
            theme: theme,
            children: [
              _LinkRow(
                icon: Icons.backup_outlined,
                title: 'Backup & export',
                theme: theme,
                onTap: () => route.pushNamed(context, routeName.backup),
              ),
              _Divider(theme: theme),
              _LinkRow(
                icon: Icons.people_alt_outlined,
                title: 'Accountability partner',
                theme: theme,
                onTap: () => route.pushNamed(context, routeName.accountability),
              ),
              _Divider(theme: theme),
              _LinkRow(
                icon: Icons.medical_services_outlined,
                title: 'Therapy notes',
                theme: theme,
                onTap: () =>
                    route.pushNamed(context, routeName.professionalNotes),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel('Support', theme: theme),
          _SettingCard(
            theme: theme,
            children: [
              _LinkRow(
                icon: Icons.support_agent_rounded,
                title: language(context, appFonts.crisisResources),
                theme: theme,
                onTap: () =>
                    route.pushNamed(context, routeName.crisisResources),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              language(context, appFonts.notMedicalCare),
              style: appCss.label12.textColor(theme.darkText),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }

  Future<void> _pickCheckInHour(
      BuildContext context, SettingsProvider settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.checkInHour, minute: 0),
      helpText: 'Daily check-in time',
    );
    if (picked != null) await settings.setCheckInHour(picked.hour);
  }

  Future<void> _toggleLock(
      BuildContext context, SettingsProvider settings, bool enable) async {
    if (enable) {
      // Launch the PIN-setup flow; the provider flips the flag on success.
      await route.pushNamed(context, routeName.lock,
          args: const LockArgs(setup: true));
    } else {
      await settings.disableLock();
    }
  }

  Future<void> _toggleBiometric(
      BuildContext context, SettingsProvider settings, bool enable) async {
    if (!enable) {
      await settings.setBiometric(false);
      return;
    }
    final auth = LocalAuthentication();
    bool available = false;
    try {
      available = await auth.isDeviceSupported() &&
          await auth.canCheckBiometrics;
    } catch (_) {
      available = false;
    }
    if (!context.mounted) return;
    if (available) {
      await settings.setBiometric(true);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text('No biometrics enrolled on this device.')));
    }
  }
}

// --- Building blocks --------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.theme});
  final String text;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(text.toUpperCase(),
          style: appCss.label12.textColor(theme.lightText)),
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.children, required this.theme});
  final List<Widget> children;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.theme});
  final AppTheme theme;
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, thickness: 1, color: theme.stroke, indent: 16, endIndent: 16);
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.theme,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: theme.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: appCss.titleSemi16.textColor(theme.darkText)),
                Text(subtitle,
                    style: appCss.label12.textColor(theme.lightText)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: theme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// 24h hour → a friendly "8:00 PM" label.
String _fmtHour(int hour24) {
  final period = hour24 < 12 ? 'AM' : 'PM';
  var h = hour24 % 12;
  if (h == 0) h = 12;
  return '$h:00 $period';
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.theme,
    this.trailing,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final AppTheme theme;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: theme.primary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: appCss.titleSemi16.textColor(theme.darkText)),
            ),
            if (trailing != null) ...[
              Text(trailing!, style: appCss.body14.textColor(theme.primary)),
              const SizedBox(width: 6),
            ],
            Icon(Icons.chevron_right_rounded, color: theme.lightText),
          ],
        ),
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({
    required this.index,
    required this.onChanged,
    required this.theme,
  });
  final int index;
  final ValueChanged<int> onChanged;
  final AppTheme theme;

  static const _labels = ['Light', 'Dark', 'System'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: i == index ? theme.primary : theme.fieldBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _labels[i],
                    textAlign: TextAlign.center,
                    style: appCss.medium14
                        .textColor(i == index ? Colors.white : theme.darkText),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
