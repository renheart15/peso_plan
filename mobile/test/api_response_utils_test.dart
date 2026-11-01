import 'package:flutter_test/flutter_test.dart';
import 'package:peso_plan/core/api/api_response_utils.dart';

void main() {
  group('ApiResponseUtils', () {
    test('unwraps nested top-level data wrappers', () {
      const response = {
        'data': {
          'token': 'abc123',
          'user': {'id': 1, 'name': 'Ari'},
        },
      };

      final unwrapped = ApiResponseUtils.unwrapData(response);

      expect(unwrapped['token'], 'abc123');
      expect(unwrapped['user'], isA<Map>());
    });

    test('unwraps nested list payloads from standard Laravel responses', () {
      const response = {
        'data': {
          'transactions': [
            {'id': 1, 'title': 'Groceries'},
            {'id': 2, 'title': 'Salary'},
          ],
        },
      };

      final items = ApiResponseUtils.unwrapCollection(response);

      expect(items, hasLength(2));
      expect(items[0]['title'], 'Groceries');
      expect(items[1]['title'], 'Salary');
    });

    test('unwrapRecord keeps a single item payload safe for model parsing', () {
      const response = {
        'data': {
          'id': 8,
          'name': 'Emergency fund',
          'target_cents': 25000,
        },
      };

      final record = ApiResponseUtils.unwrapRecord(response);

      expect(record, isNotNull);
      expect(record!['id'], 8);
      expect(record['name'], 'Emergency fund');
    });
  });
}
