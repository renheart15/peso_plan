import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peso_plan/features/budget/domain/budget_category_model.dart';

void main() {
  group('BudgetCategoryModel.fromJson', () {
    test('parses planned_cents, spentCents, name, colorHex correctly', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 1,
        'name': 'Groceries',
        'planned_cents': 50000,
        'spent_cents': 30000,
        'color_hex': '#1A6B4A',
      });

      expect(model.id, 1);
      expect(model.name, 'Groceries');
      expect(model.plannedCents, 50000);
      expect(model.spentCents, 30000);
      expect(model.colorHex, '#1A6B4A');
    });

    test('parses with budgeted_cents key alias', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 2,
        'name': 'Housing',
        'budgeted_cents': 80000,
        'spent_cents': 80000,
      });

      expect(model.plannedCents, 80000);
    });

    test('parses with spentCents camelCase key alias', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 3,
        'name': 'Transport',
        'plannedCents': 20000,
        'spentCents': 5000,
      });

      expect(model.plannedCents, 20000);
      expect(model.spentCents, 5000);
    });

    test('defaults name to Category when missing', () {
      final model = BudgetCategoryModel.fromJson({'id': 99});
      expect(model.name, 'Category');
    });
  });

  group('BudgetCategoryModel.isOverBudget', () {
    test('returns true when spentCents > plannedCents', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 1,
        'name': 'Fun',
        'planned_cents': 10000,
        'spent_cents': 15000,
      });

      expect(model.isOverBudget, isTrue);
    });

    test('returns false when spentCents == plannedCents', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 2,
        'name': 'Fun',
        'planned_cents': 10000,
        'spent_cents': 10000,
      });

      expect(model.isOverBudget, isFalse);
    });

    test('returns false when spentCents < plannedCents', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 3,
        'name': 'Fun',
        'planned_cents': 10000,
        'spent_cents': 5000,
      });

      expect(model.isOverBudget, isFalse);
    });

    test('zero-based mode: when plannedCents==0 and spentCents==0, isOverBudget is false', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 4,
        'name': 'Zero',
        'planned_cents': 0,
        'spent_cents': 0,
      });

      expect(model.isOverBudget, isFalse);
    });
  });

  group('BudgetCategoryModel._asInt coercion via fromJson', () {
    test('coerces String value for planned_cents', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 10,
        'name': 'Test',
        'planned_cents': '45000',
        'spent_cents': '10000',
      });

      expect(model.plannedCents, 45000);
      expect(model.spentCents, 10000);
    });

    test('coerces double value via rounding', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 11,
        'name': 'Test',
        'planned_cents': 12345.9,
        'spent_cents': 6789.1,
      });

      expect(model.plannedCents, 12346);
      expect(model.spentCents, 6789);
    });

    test('coerces int passthrough', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 12,
        'name': 'Test',
        'planned_cents': 99999,
        'spent_cents': 11111,
      });

      expect(model.plannedCents, 99999);
      expect(model.spentCents, 11111);
    });
  });

  group('BudgetCategoryModel.accentColor', () {
    test('parses valid colorHex #1A6B4A correctly', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 20,
        'name': 'Custom',
        'planned_cents': 1000,
        'spent_cents': 0,
        'color_hex': '#1A6B4A',
      });

      // #1A6B4A with 0xFF prefix -> 0xFF1A6B4A
      expect(model.accentColor, const Color(0xFF1A6B4A));
    });

    test('falls back to named color when no colorHex', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 21,
        'name': 'Housing',
        'planned_cents': 1000,
        'spent_cents': 0,
      });

      expect(model.accentColor, const Color(0xFF1A6B4A));
    });

    test('falls back to default purple when name is unrecognized', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 22,
        'name': 'Mystery',
        'planned_cents': 1000,
        'spent_cents': 0,
      });

      expect(model.accentColor, const Color(0xFF8A5CF6));
    });
  });

  group('BudgetCategoryModel budget remaining calculation', () {
    test('remainingCents is plannedCents - spentCents (computed scenario)', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 30,
        'name': 'Utilities',
        'planned_cents': 25000,
        'spent_cents': 18000,
      });

      final remaining = model.plannedCents - model.spentCents;
      expect(remaining, 7000);
      expect(model.isOverBudget, isFalse);
    });

    test('negative remaining when over budget', () {
      final model = BudgetCategoryModel.fromJson({
        'id': 31,
        'name': 'Shopping',
        'planned_cents': 10000,
        'spent_cents': 12500,
      });

      final remaining = model.plannedCents - model.spentCents;
      expect(remaining, -2500);
      expect(model.isOverBudget, isTrue);
    });
  });
}
