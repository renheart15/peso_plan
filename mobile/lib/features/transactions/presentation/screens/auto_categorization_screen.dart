import 'package:flutter/material.dart';

class AutoCategorizationScreen extends StatefulWidget {
  const AutoCategorizationScreen({super.key});

  @override
  State<AutoCategorizationScreen> createState() =>
      _AutoCategorizationScreenState();
}

class _AutoCategorizationScreenState extends State<AutoCategorizationScreen> {
  final _searchController = TextEditingController(text: 'SM Hypermarket');
  final List<_CategoryRule> _rules = [
    _CategoryRule(
      name: 'Groceries',
      matcher: 'SM Hypermarket|Puregold|Robinsons|Shopwise|Mercury Drug',
      enabled: true,
      confidence: 0.95,
    ),
    _CategoryRule(
      name: 'Dining',
      matcher: 'Jollibee|McDonalds|KFC|Mang Inasal|Coffee Bean|Starbucks',
      enabled: true,
      confidence: 0.92,
    ),
    _CategoryRule(
      name: 'Transport',
      matcher: 'Petron|Shell|Grab|LRT|MRT|Jeepney|Taxi',
      enabled: true,
      confidence: 0.88,
    ),
    _CategoryRule(
      name: 'Utilities',
      matcher: 'MERALCO|Maynilad|Globe|Smart|PLDT|Dito|Water',
      enabled: true,
      confidence: 0.91,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _CategoryRule? _matchRule(String input) {
    final normalized = input.trim();
    if (normalized.isEmpty) {
      return null;
    }

    for (final rule in _rules.where((rule) => rule.enabled)) {
      final pattern = rule.matcher.split('|');
      if (pattern.any(
        (value) =>
            normalized.toLowerCase().contains(value.trim().toLowerCase()),
      )) {
        return rule;
      }
    }

    return null;
  }

  Future<void> _addRule() async {
    final nameController = TextEditingController();
    final matcherController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final created = await showDialog<_CategoryRule>(
      context: context,
      builder: (dialogContext) {
        double confidence = 0.9;

        return AlertDialog(
          title: const Text('Add categorization rule'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Category name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Category is required'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: matcherController,
                    decoration: const InputDecoration(
                      labelText: 'Merchant matchers',
                      hintText: 'SM Hypermarket|Puregold',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Matchers are required'
                            : null,
                  ),
                  const SizedBox(height: 14),
                  StatefulBuilder(
                    builder: (builderContext, setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confidence: ${(confidence * 100).round()}%',
                            style: Theme.of(builderContext).textTheme.bodyMedium,
                          ),
                          Slider(
                            value: confidence,
                            min: 0.5,
                            max: 1.0,
                            divisions: 10,
                            onChanged: (value) {
                              confidence = value;
                              setState(() {});
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(dialogContext).pop(
                    _CategoryRule(
                      name: nameController.text.trim(),
                      matcher: matcherController.text.trim(),
                      enabled: true,
                      confidence: confidence,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (created != null) {
      setState(() => _rules.add(created));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final match = _matchRule(_searchController.text);

    return Scaffold(
      appBar: AppBar(title: const Text('Auto-categorisation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Try a merchant name',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. SM Hypermarket',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.auto_fix_high_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: match != null
                          ? theme.colorScheme.primary.withValues(alpha: 0.08)
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          match != null
                              ? Icons.check_circle
                              : Icons.help_outline,
                          color: match != null
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            match == null
                                ? 'No category match yet'
                                : 'Suggested category: ${match.name} (${(match.confidence * 100).round()}%)',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Rules',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ..._rules.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final rule = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rule.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              rule.matcher,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${(rule.confidence * 100).round()}%',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Switch(
                            value: rule.enabled,
                            onChanged: (value) {
                              setState(() => _rules[index].enabled = value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _addRule,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Add rule'),
          ),
        ],
      ),
    );
  }
}

class _CategoryRule {
  _CategoryRule({
    required this.name,
    required this.matcher,
    required this.enabled,
    required this.confidence,
  });

  String name;
  String matcher;
  bool enabled;
  double confidence;
}
