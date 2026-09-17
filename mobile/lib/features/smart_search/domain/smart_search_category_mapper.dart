import 'package:dinarwise/features/categories/data/category_repository.dart';

class SmartSearchCategoryMapper {
  const SmartSearchCategoryMapper();

  /// Canonical mapping of AI category groups to DinarWise system category codes.
  static const Map<String, List<String>> _groupToSystemCodes = {
    'restaurants_cafes': ['restaurants'],
    'groceries': ['groceries'],
    'transport': ['transportation', 'fuel'],
    'shopping': ['shopping', 'bnpl'],
    'entertainment': [],
    'health': ['healthcare'],
    'education': [],
    'bills': ['utilities'],
    'subscriptions': ['subscriptions'],
    'travel': ['transportation'],
    'utilities': ['utilities'],
    'other': ['other'],
  };

  /// Maps returned AI category groups to the app's real, existing category IDs.
  /// Uses stable system category codes and profile IDs.
  Set<String> mapCategoryGroupsToIds({
    required List<String> categoryGroups,
    required String profileId,
    List<CategoryRecord> existingCategories = const [],
  }) {
    final matchedIds = <String>{};

    for (final rawGroup in categoryGroups) {
      final group = rawGroup.toLowerCase().trim();
      final systemCodes = _groupToSystemCodes[group] ?? const [];

      // 1. Map directly to canonical system category IDs for this profile
      for (final code in systemCodes) {
        matchedIds.add('$profileId:$code');
      }

      // 2. Include any existing categories whose systemCode matches
      for (final category in existingCategories) {
        if (category.systemCode != null && systemCodes.contains(category.systemCode)) {
          matchedIds.add(category.id);
        }
      }
    }

    return matchedIds;
  }
}
