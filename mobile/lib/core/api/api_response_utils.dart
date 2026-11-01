class ApiResponseUtils {
  const ApiResponseUtils._();

  static Map<String, dynamic> unwrapData(dynamic responseData) {
    if (responseData is! Map) {
      return const <String, dynamic>{};
    }

    final map = Map<String, dynamic>.from(responseData);
    final nestedData = map['data'];
    if (nestedData is Map) {
      return Map<String, dynamic>.from(nestedData);
    }
    return map;
  }

  static List<Map<String, dynamic>> unwrapCollection(dynamic responseData) {
    final direct = _asList(responseData);
    if (direct.isNotEmpty) {
      return direct;
    }

    if (responseData is Map) {
      final map = Map<String, dynamic>.from(responseData);
      final candidateKeys = [
        'data',
        'transactions',
        'accounts',
        'budgets',
        'goals',
        'items',
        'results',
      ];

      for (final key in candidateKeys) {
        final value = map[key];
        final nested = _asList(value);
        if (nested.isNotEmpty) {
          return nested;
        }

        if (value is Map) {
          final deeper = unwrapCollection(value);
          if (deeper.isNotEmpty) {
            return deeper;
          }
        }
      }
    }

    return const <Map<String, dynamic>>[];
  }

  static Map<String, dynamic>? unwrapRecord(dynamic responseData) {
    if (responseData is Map) {
      final map = Map<String, dynamic>.from(responseData);
      final nestedData = map['data'];
      if (nestedData is Map) {
        return Map<String, dynamic>.from(nestedData);
      }
      return map;
    }
    return null;
  }

  static List<Map<String, dynamic>> _asList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }
}
