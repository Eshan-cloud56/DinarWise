import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/features/tutorial/tutorial_keys.dart';
import 'package:dinarwise/features/tutorial/tutorial_service.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Settings → Help & Tutorials screen.
///
/// Lists all 11 feature tutorials with "View Tutorial" buttons and
/// a "Replay All Feature Tutorials" action. Fully localized in English and Arabic.
class HelpTutorialsScreen extends ConsumerStatefulWidget {
  const HelpTutorialsScreen({super.key});

  @override
  ConsumerState<HelpTutorialsScreen> createState() =>
      _HelpTutorialsScreenState();
}

class _HelpTutorialsScreenState extends ConsumerState<HelpTutorialsScreen> {
  bool _replayAllDone = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final service = ref.read(tutorialServiceProvider);

    final tutorials = [
      _TutorialEntry(
        key: TutorialKeys.home,
        title: l10n.tutorialDashboardTitle,
        description: l10n.tutorialHomeDescription,
        icon: Icons.dashboard_outlined,
      ),
      _TutorialEntry(
        key: TutorialKeys.history,
        title: l10n.tutorialTransactionsTitle,
        description: l10n.tutorialHistoryDescription,
        icon: Icons.history_outlined,
      ),
      _TutorialEntry(
        key: TutorialKeys.smartSearch,
        title: l10n.tutorialSmartSearchTitle,
        description: l10n.tutorialSmartSearchDescription,
        icon: Icons.search_outlined,
      ),
      _TutorialEntry(
        key: TutorialKeys.smartReceipt,
        title: l10n.tutorialSmartReceiptTitle,
        description: l10n.tutorialSmartReceiptDescription,
        icon: Icons.document_scanner_outlined,
      ),
      _TutorialEntry(
        key: TutorialKeys.voiceExpense,
        title: l10n.tutorialVoiceExpenseTitle,
        description: l10n.tutorialVoiceExpenseDescription,
        icon: Icons.mic_outlined,
      ),
      _TutorialEntry(
        key: TutorialKeys.smsDetection,
        title: l10n.tutorialSmsDetectionTitle,
        description: l10n.tutorialSmsDetectionDescription,
        icon: Icons.sms_outlined,
      ),
      _TutorialEntry(
        key: TutorialKeys.spendingAlerts,
        title: l10n.tutorialSpendingAlertsTitle,
        description: l10n.tutorialSpendingAlertsDescription,
        icon: Icons.notifications_active_outlined,
      ),
      _TutorialEntry(
        key: TutorialKeys.addExpense,
        title: l10n.tutorialExpenseTitle,
        description: l10n.tutorialExpenseDescription,
        icon: Icons.add_circle_outline,
      ),
      _TutorialEntry(
        key: TutorialKeys.planning,
        title: l10n.tutorialPlanningTitle,
        description: l10n.tutorialPlanningDescription,
        icon: Icons.account_balance_outlined,
      ),
      _TutorialEntry(
        key: TutorialKeys.bottomNav,
        title: l10n.tutorialBottomNavTitle,
        description: l10n.tutorialBottomNavDescription,
        icon: Icons.navigation_outlined,
      ),
      _TutorialEntry(
        key: TutorialKeys.homeWidget,
        title: l10n.tutorialHomeWidgetTitle,
        description: l10n.tutorialHomeWidgetDescription,
        icon: Icons.widgets_outlined,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpAndTutorials),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header card
          Card(
            color: const Color(0xFFFFFBF0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.featureTutorials,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.featureTutorialsSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Introduction Tour button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.auto_stories_outlined),
              label: Text(
                l10n.introTour,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () => context.push('/intro?replay=true'),
            ),
          ),
          const SizedBox(height: 10),

          // Replay All button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: Icon(
                _replayAllDone ? Icons.check_circle : Icons.replay_outlined,
              ),
              label: Text(
                _replayAllDone
                    ? l10n.allTutorialsReset
                    : l10n.replayAllTutorials,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              onPressed: _replayAllDone
                  ? null
                  : () async {
                      await service.resetAllTutorials();
                      if (context.mounted) {
                        setState(() => _replayAllDone = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.allTutorialsResetSnackbar,
                            ),
                          ),
                        );
                      }
                    },
            ),
          ),
          const SizedBox(height: 16),

          // Tutorial list
          ...tutorials.map((entry) => _TutorialTile(
                entry: entry,
                isCompleted: service.isTutorialCompleted(entry.key),
                onTap: () => _showTutorialDetails(context, entry, service),
                onReplay: () async {
                  await service.resetTutorial(entry.key);
                  if (context.mounted) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.tutorialResetSnackbar(entry.title),
                        ),
                      ),
                    );
                  }
                },
              )),
        ],
      ),
    );
  }

  void _showTutorialDetails(
    BuildContext context,
    _TutorialEntry entry,
    TutorialService service,
  ) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(entry.icon, color: DinarColors.forest),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                entry.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (entry.key == TutorialKeys.homeWidget) ...[
                Text(
                  l10n.widgetTutorialTitle,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: DinarColors.forest),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.widgetTutorialSubtitle,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 12),
                _buildBulletPoint(
                    '🔍', l10n.widgetActionSearch, l10n.widgetTutorialSearchDesc),
                const SizedBox(height: 6),
                _buildBulletPoint(
                    '📷', l10n.widgetActionCamera, l10n.widgetTutorialCameraDesc),
                const SizedBox(height: 6),
                _buildBulletPoint('🖼️', l10n.widgetActionMedia,
                    l10n.widgetTutorialMediaDesc),
                const SizedBox(height: 6),
                _buildBulletPoint('🎙️', l10n.voice,
                    l10n.widgetTutorialVoiceDesc),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF0),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: DinarColors.gold.withAlpha(80)),
                  ),
                  child: Text(
                    l10n.widgetTutorialTip,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF78350F), height: 1.3),
                  ),
                ),
              ] else ...[
                Text(
                  entry.description,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await service.completeTutorial(entry.key);
              if (mounted) setState(() {});
            },
            child: Text(l10n.gotIt,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static Widget _buildBulletPoint(String emoji, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: const TextStyle(
                  fontSize: 12, color: Colors.black87, height: 1.3),
              children: [
                TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: desc),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TutorialEntry {
  const _TutorialEntry({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String key;
  final String title;
  final String description;
  final IconData icon;
}

class _TutorialTile extends StatelessWidget {
  const _TutorialTile({
    required this.entry,
    required this.isCompleted,
    required this.onReplay,
    this.onTap,
  });

  final _TutorialEntry entry;
  final bool isCompleted;
  final VoidCallback onReplay;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCompleted
                ? DinarColors.forest.withAlpha(20)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            entry.icon,
            color: isCompleted ? DinarColors.forest : Colors.grey.shade600,
            size: 24,
          ),
        ),
        title: Text(
          entry.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            entry.description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ),
        trailing: isCompleted
            ? TextButton(
                onPressed: onReplay,
                child: Text(
                  context.l10n.replay,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: DinarColors.forest,
                  ),
                ),
              )
            : Icon(
                Icons.circle_outlined,
                size: 18,
                color: Colors.grey.shade400,
              ),
      ),
    );
  }
}
