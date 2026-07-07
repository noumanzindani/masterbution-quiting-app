/// Bundled crisis/helpline resources. Static content (no live directory — that
/// needs a backend, deferred to v2). English/US-centric with an international
/// fallback; localized + region-aware lists come in Phase 7.
///
/// `uri` uses `tel:` / `sms:` / `https:` schemes launched via url_launcher.
class CrisisResource {
  const CrisisResource({
    required this.title,
    required this.detail,
    required this.actionLabel,
    required this.uri,
  });

  final String title;
  final String detail;
  final String actionLabel;
  final String uri;
}

const List<CrisisResource> crisisResources = [
  CrisisResource(
    title: '988 Suicide & Crisis Lifeline',
    detail: 'Free, confidential support 24/7 (US). Call or text 988.',
    actionLabel: 'Call 988',
    uri: 'tel:988',
  ),
  CrisisResource(
    title: 'Crisis Text Line',
    detail: 'Text a trained crisis counselor. Text HOME to 741741 (US).',
    actionLabel: 'Text 741741',
    uri: 'sms:741741',
  ),
  CrisisResource(
    title: 'SAMHSA National Helpline',
    detail: 'Free, confidential treatment referral & information, 24/7 (US).',
    actionLabel: 'Call 1-800-662-4357',
    uri: 'tel:18006624357',
  ),
  CrisisResource(
    title: 'Find a helpline near you',
    detail: 'Verified helplines in 130+ countries via findahelpline.com.',
    actionLabel: 'Open directory',
    uri: 'https://findahelpline.com',
  ),
];
