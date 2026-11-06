import 'package:flutter_test/flutter_test.dart';
import 'package:peso_plan/features/goals/domain/goal_model.dart';

void main() {
  group('GoalModel.fromJson', () {
    test('parses target_cents, current_cents, name, type, due_date', () {
      final model = GoalModel.fromJson({
        'id': 1,
        'name': 'Emergency Fund',
        'target_cents': 500000,
        'current_cents': 125000,
        'type': 'savings',
        'due_date': '2027-06-30',
      });

      expect(model.id, 1);
      expect(model.name, 'Emergency Fund');
      expect(model.targetCents, 500000);
      expect(model.currentCents, 125000);
      expect(model.type, 'savings');
      expect(model.dueDate, DateTime(2027, 6, 30));
    });

    test('parses with targetCents / currentCents camelCase key aliases', () {
      final model = GoalModel.fromJson({
        'id': 2,
        'name': 'Vacation',
        'targetCents': 200000,
        'currentCents': 80000,
        'type': 'savings',
      });

      expect(model.targetCents, 200000);
      expect(model.currentCents, 80000);
    });

    test('defaults type to savings when missing', () {
      final model = GoalModel.fromJson({'id': 99, 'name': 'Unknown'});
      expect(model.type, 'savings');
    });

    test('defaults name to Goal when missing', () {
      final model = GoalModel.fromJson({'id': 99});
      expect(model.name, 'Goal');
    });
  });

  group('GoalModel.isDebtGoal', () {
    test('is true when type == "debt"', () {
      final model = GoalModel.fromJson({
        'id': 10,
        'name': 'Credit Card',
        'target_cents': 100000,
        'current_cents': 0,
        'type': 'debt',
      });

      expect(model.isDebtGoal, isTrue);
    });

    test('is false when type == "savings"', () {
      final model = GoalModel.fromJson({
        'id': 11,
        'name': 'House down payment',
        'target_cents': 500000,
        'current_cents': 100000,
        'type': 'savings',
      });

      expect(model.isDebtGoal, isFalse);
    });

    test('is false for any non-debt type string', () {
      final model = GoalModel.fromJson({
        'id': 12,
        'name': 'Emergency',
        'type': 'emergency_fund',
      });

      expect(model.isDebtGoal, isFalse);
    });
  });

  group('GoalModel._asInt coercion via fromJson', () {
    test('coerces String values', () {
      final model = GoalModel.fromJson({
        'id': 20,
        'name': 'Test',
        'target_cents': '300000',
        'current_cents': '50000',
        'type': 'savings',
      });

      expect(model.targetCents, 300000);
      expect(model.currentCents, 50000);
    });

    test('coerces double values via rounding', () {
      final model = GoalModel.fromJson({
        'id': 21,
        'name': 'Test',
        'target_cents': 100000.7,
        'current_cents': 25000.3,
        'type': 'savings',
      });

      expect(model.targetCents, 100001);
      expect(model.currentCents, 25000);
    });

    test('coerces int passthrough', () {
      final model = GoalModel.fromJson({
        'id': 22,
        'name': 'Test',
        'target_cents': 75000,
        'current_cents': 25000,
        'type': 'savings',
      });

      expect(model.targetCents, 75000);
      expect(model.currentCents, 25000);
    });
  });

  group('GoalModel progress ratio', () {
    test('currentCents / targetCents gives correct ratio', () {
      final model = GoalModel.fromJson({
        'id': 30,
        'name': 'Emergency Fund',
        'target_cents': 500000,
        'current_cents': 125000,
        'type': 'savings',
      });

      final ratio = model.currentCents / model.targetCents;
      // 125000 / 500000 = 0.25
      expect(ratio, closeTo(0.25, 0.0001));
    });

    test('progress is 1.0 when current equals target', () {
      final model = GoalModel.fromJson({
        'id': 31,
        'name': 'Goal complete',
        'target_cents': 100000,
        'current_cents': 100000,
        'type': 'savings',
      });

      final ratio = model.currentCents / model.targetCents;
      expect(ratio, closeTo(1.0, 0.0001));
    });

    test('progress is 0.0 when current is 0', () {
      final model = GoalModel.fromJson({
        'id': 32,
        'name': 'Just started',
        'target_cents': 200000,
        'current_cents': 0,
        'type': 'savings',
      });

      final ratio = model.targetCents <= 0
          ? 0.0
          : (model.currentCents / model.targetCents).clamp(0.0, 1.0);
      expect(ratio, closeTo(0.0, 0.0001));
    });
  });

  group('GoalModel.dueDate', () {
    test('parses ISO date string correctly', () {
      final model = GoalModel.fromJson({
        'id': 40,
        'name': 'Retirement',
        'target_cents': 10000000,
        'current_cents': 500000,
        'type': 'savings',
        'due_date': '2035-12-31',
      });

      expect(model.dueDate, isNotNull);
      expect(model.dueDate!.year, 2035);
      expect(model.dueDate!.month, 12);
      expect(model.dueDate!.day, 31);
    });

    test('dueDate is null when json has no due_date', () {
      final model = GoalModel.fromJson({
        'id': 41,
        'name': 'No deadline',
        'target_cents': 50000,
        'current_cents': 0,
        'type': 'savings',
      });

      expect(model.dueDate, isNull);
    });

    test('dueDate is null when due_date is null in json', () {
      final model = GoalModel.fromJson({
        'id': 42,
        'name': 'Null deadline',
        'target_cents': 50000,
        'current_cents': 0,
        'type': 'savings',
        'due_date': null,
      });

      expect(model.dueDate, isNull);
    });
  });
}
