import 'package:flutter/material.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  bool _largeText = false;
  bool _highContrast = false;
  bool _reduceMotion = true;
  bool _haptics = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility')),
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
                    'Display & interaction',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ToggleRow(
                    label: 'Large text',
                    value: _largeText,
                    onChanged: (value) => setState(() => _largeText = value),
                  ),
                  const Divider(height: 1),
                  _ToggleRow(
                    label: 'High contrast mode',
                    value: _highContrast,
                    onChanged: (value) => setState(() => _highContrast = value),
                  ),
                  const Divider(height: 1),
                  _ToggleRow(
                    label: 'Reduce motion',
                    value: _reduceMotion,
                    onChanged: (value) => setState(() => _reduceMotion = value),
                  ),
                  const Divider(height: 1),
                  _ToggleRow(
                    label: 'Haptic feedback',
                    value: _haptics,
                    onChanged: (value) => setState(() => _haptics = value),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Release readiness checklist',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ChecklistRow(
                    label: 'Color contrast meets WCAG guidance',
                    isComplete: true,
                    color: cs.primary,
                  ),
                  _ChecklistRow(
                    label: 'All icons have accessible labels',
                    isComplete: true,
                    color: cs.primary,
                  ),
                  _ChecklistRow(
                    label: 'Primary actions are discoverable with keyboard and screen readers',
                    isComplete: true,
                    color: cs.primary,
                  ),
                  _ChecklistRow(
                    label: 'Smart defaults for haptics and motion are enabled',
                    isComplete: false,
                    color: cs.tertiary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Accessibility settings saved locally.'),
                ),
              );
            },
            icon: const Icon(Icons.save_alt_outlined),
            label: const Text('Save preferences'),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: tt.bodyMedium?.copyWith(color: cs.onSurface),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({
    required this.label,
    required this.isComplete,
    required this.color,
  });

  final String label;
  final bool isComplete;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isComplete
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: tt.bodyMedium)),
        ],
      ),
    );
  }
}
