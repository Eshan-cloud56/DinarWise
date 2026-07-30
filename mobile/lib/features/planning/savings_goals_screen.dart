import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/expenses/amount_parser.dart';
import 'package:dinarwise/features/planning/data/advanced_planning_repository.dart';
import 'package:dinarwise/features/planning/data/planning_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _goalsProvider =
    StreamProvider.autoDispose<List<GoalDetails>>((ref) async* {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  yield* ref
      .watch(advancedPlanningRepositoryProvider)
      .watchGoals(onboarding.localProfileId);
});

const _goalTemplates = [
  'emergency_fund',
  'travel',
  'wedding',
  'car',
  'education',
  'hajj',
  'umrah',
  'eid',
  'custom',
];

class SavingsGoalsScreen extends ConsumerWidget {
  const SavingsGoalsScreen({super.key});

  Future<void> _editGoal(
    BuildContext context,
    WidgetRef ref, [
    GoalDetails? goal,
  ]) async {
    final result = await showModalBottomSheet<_GoalDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _GoalEditor(goal: goal),
    );
    if (result == null) return;
    final onboarding = await ref.read(onboardingControllerProvider.future);
    await ref.read(advancedPlanningRepositoryProvider).saveGoal(
          profileId: onboarding.localProfileId,
          id: goal?.id,
          name: result.name,
          targetMinor: result.targetMinor,
          targetDate: result.targetDate,
          templateCode: result.templateCode,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(_goalsProvider);
    final currency = ref
        .watch(selectedCurrencyProvider)
        .formatter(Localizations.localeOf(context).toLanguageTag());
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.savingsGoals)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editGoal(context, ref),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.add),
      ),
      body: goals.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(context.l10n.unknownError)),
        data: (items) => items.isEmpty
            ? Center(child: Text(context.l10n.comingSoon))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final goal = items[index];
                  final progress = goal.progress;
                  return Card(
                    child: InkWell(
                      onTap: () => _showGoal(context, ref, goal, currency),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.savings_outlined),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    goal.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                IconButton(
                                  tooltip: context.l10n.edit,
                                  onPressed: () =>
                                      _editGoal(context, ref, goal),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                              ],
                            ),
                            LinearProgressIndicator(
                              value: progress.percentage,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${currency.format(goal.currentMinor / 100)} / '
                              '${currency.format(goal.targetMinor / 100)}',
                            ),
                            Text(
                              '${context.l10n.remaining}: '
                              '${currency.format(progress.remainingMinor / 100)}',
                            ),
                            if (progress.isComplete)
                              Text(
                                context.l10n.goalCompleted,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _showGoal(
    BuildContext context,
    WidgetRef ref,
    GoalDetails goal,
    NumberFormat currency,
  ) {
    final repository = ref.read(advancedPlanningRepositoryProvider);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: .85,
        child: StreamBuilder<List<GoalContributionDetails>>(
          stream: repository.watchContributions(goal.id),
          builder: (context, snapshot) {
            final contributions = snapshot.data ?? const [];
            final progress = goal.progress;
            return Column(
              children: [
                Text(goal.name, style: Theme.of(context).textTheme.titleLarge),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: progress.percentage,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${context.l10n.requiredWeekly}: '
                        '${currency.format(progress.requiredWeeklyMinor / 100)}',
                      ),
                      Text(
                        '${context.l10n.requiredMonthly}: '
                        '${currency.format(progress.requiredMonthlyMinor / 100)}',
                      ),
                      FilledButton.icon(
                        onPressed: () => _editContribution(context, ref, goal),
                        icon: const Icon(Icons.add),
                        label: Text(context.l10n.addContribution),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: contributions.isEmpty
                      ? Center(child: Text(context.l10n.noContributions))
                      : ListView.builder(
                          itemCount: contributions.length,
                          itemBuilder: (_, index) {
                            final contribution = contributions[index];
                            return ListTile(
                              title: Text(
                                currency.format(contribution.amountMinor / 100),
                              ),
                              subtitle: Text(
                                [
                                  DateFormat.yMd().format(
                                    contribution.contributedAt,
                                  ),
                                  if (contribution.note?.isNotEmpty == true)
                                    contribution.note!,
                                ].join(' • '),
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (action) {
                                  if (action == 'edit') {
                                    _editContribution(
                                      context,
                                      ref,
                                      goal,
                                      contribution,
                                    );
                                  } else {
                                    repository.deleteContribution(
                                      contribution.id,
                                    );
                                  }
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text(context.l10n.edit),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text(context.l10n.delete),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _editContribution(
    BuildContext context,
    WidgetRef ref,
    GoalDetails goal, [
    GoalContributionDetails? contribution,
  ]) async {
    final amount = TextEditingController(
      text: contribution == null
          ? null
          : (contribution.amountMinor / 100).toStringAsFixed(2),
    );
    final note = TextEditingController(text: contribution?.note);
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.addContribution),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amount,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: context.l10n.amount),
            ),
            TextField(
              controller: note,
              decoration:
                  InputDecoration(labelText: context.l10n.notesOptional),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    final parsed = parseLocalizedAmount(amount.text);
    final noteValue = note.text;
    amount.dispose();
    note.dispose();
    if (save != true || parsed == null || parsed <= 0) return;
    final onboarding = await ref.read(onboardingControllerProvider.future);
    await ref.read(advancedPlanningRepositoryProvider).saveContribution(
          profileId: onboarding.localProfileId,
          goalId: goal.id,
          contributionId: contribution?.id,
          amountMinor: (parsed * 100).round(),
          date: contribution?.contributedAt ?? DateTime.now(),
          note: noteValue,
        );
  }
}

class _GoalDraft {
  const _GoalDraft({
    required this.name,
    required this.targetMinor,
    required this.targetDate,
    required this.templateCode,
  });

  final String name;
  final int targetMinor;
  final DateTime? targetDate;
  final String? templateCode;
}

class _GoalEditor extends StatefulWidget {
  const _GoalEditor({this.goal});

  final GoalDetails? goal;

  @override
  State<_GoalEditor> createState() => _GoalEditorState();
}

class _GoalEditorState extends State<_GoalEditor> {
  late final TextEditingController _name =
      TextEditingController(text: widget.goal?.name);
  late final TextEditingController _target = TextEditingController(
    text: widget.goal == null
        ? null
        : (widget.goal!.targetMinor / 100).toStringAsFixed(2),
  );
  late String _template = widget.goal?.templateCode ?? 'custom';
  late DateTime? _date = widget.goal?.targetDate;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

  String _templateLabel(BuildContext context, String template) =>
      switch (template) {
        'emergency_fund' => context.l10n.emergencyFund,
        'travel' => context.l10n.travel,
        'wedding' => context.l10n.wedding,
        'car' => context.l10n.car,
        'education' => context.l10n.education,
        'hajj' => context.l10n.hajj,
        'umrah' => context.l10n.umrah,
        'eid' => context.l10n.eid,
        _ => context.l10n.customGoal,
      };

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.goal == null
                    ? context.l10n.addGoal
                    : context.l10n.editGoal,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              DropdownButtonFormField<String>(
                initialValue: _template,
                decoration:
                    InputDecoration(labelText: context.l10n.goalTemplate),
                items: _goalTemplates
                    .map(
                      (template) => DropdownMenuItem(
                        value: template,
                        child: Text(_templateLabel(context, template)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  _template = value!;
                  if (_template != 'custom' && _name.text.trim().isEmpty) {
                    _name.text = _templateLabel(context, _template);
                  }
                }),
              ),
              TextField(
                controller: _name,
                decoration: InputDecoration(labelText: context.l10n.name),
              ),
              TextField(
                controller: _target,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    InputDecoration(labelText: context.l10n.targetAmount),
              ),
              ListTile(
                title: Text(context.l10n.targetDate),
                subtitle: Text(
                  _date == null
                      ? context.l10n.optional
                      : DateFormat.yMd().format(_date!),
                ),
                trailing: const Icon(Icons.date_range_outlined),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                    initialDate: _date ?? DateTime.now(),
                  );
                  if (selected != null) setState(() => _date = selected);
                },
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final target = parseLocalizedAmount(_target.text);
                    if (_name.text.trim().isEmpty ||
                        target == null ||
                        target <= 0) {
                      return;
                    }
                    Navigator.pop(
                      context,
                      _GoalDraft(
                        name: _name.text.trim(),
                        targetMinor: (target * 100).round(),
                        targetDate: _date,
                        templateCode: _template,
                      ),
                    );
                  },
                  child: Text(context.l10n.save),
                ),
              ),
            ],
          ),
        ),
      );
}
