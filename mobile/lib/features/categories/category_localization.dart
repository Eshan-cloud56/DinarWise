import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';

String localizedCategoryName(
  AppLocalizations l10n,
  CategoryRecord category,
) {
  return switch (category.systemCode) {
    'restaurants' => l10n.restaurants,
    'groceries' => l10n.groceries,
    'fuel' => l10n.fuel,
    'transportation' => l10n.transportation,
    'shopping' => l10n.shopping,
    'healthcare' => l10n.healthcare,
    'utilities' => l10n.utilities,
    'subscriptions' => l10n.subscriptions,
    'bnpl' => l10n.bnplPayment,
    'other' => l10n.other,
    _ => category.name,
  };
}

const Map<String, List<String>> systemCategoryAliases = {
  'restaurants': [
    'restaurant',
    'restaurants',
    'cafe',
    'cafes',
    'dining',
    'food',
    'مطعم',
    'مطاعم',
    'مقاهي',
    'كافيه',
    'اكل',
  ],
  'groceries': [
    'grocery',
    'groceries',
    'supermarket',
    'market',
    'بقالة',
    'تموينات',
    'سوبرماركت',
    'اغذية',
  ],
  'fuel': [
    'fuel',
    'gas',
    'petrol',
    'بنزين',
    'وقود',
    'محطة',
  ],
  'transportation': [
    'transport',
    'transportation',
    'transit',
    'uber',
    'taxi',
    'مواصلات',
    'نقل',
    'سيارات',
    'توصيل',
  ],
  'shopping': [
    'shop',
    'shopping',
    'store',
    'mall',
    'تسوق',
    'ملابس',
  ],
  'healthcare': [
    'health',
    'healthcare',
    'medical',
    'pharmacy',
    'صحة',
    'علاج',
    'صيدلية',
    'طبي',
  ],
  'utilities': [
    'utility',
    'utilities',
    'bill',
    'bills',
    'electricity',
    'water',
    'فاتورة',
    'فواتير',
    'كهرباء',
    'ماء',
  ],
  'subscriptions': [
    'subscription',
    'subscriptions',
    'sub',
    'subs',
    'اشتراك',
    'اشتراكات',
  ],
  'bnpl': [
    'bnpl',
    'tabby',
    'tamara',
    'اقساط',
    'تابي',
    'تمارا',
  ],
  'other': [
    'other',
    'misc',
    'اخري',
    'أخرى',
  ],
};

Set<String> resolveCategorySearchIds({
  required String query,
  required List<CategoryRecord> categories,
  AppLocalizations? l10n,
}) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty) return const {};

  final matchedIds = <String>{};

  for (final category in categories) {
    if (l10n != null) {
      final localized = localizedCategoryName(l10n, category).toLowerCase();
      if (localized == needle ||
          localized.contains(needle) ||
          needle.contains(localized)) {
        matchedIds.add(category.id);
        continue;
      }
    }

    final raw = category.name.toLowerCase();
    if (raw == needle || raw.contains(needle) || needle.contains(raw)) {
      matchedIds.add(category.id);
      continue;
    }

    final code = category.systemCode?.toLowerCase();
    if (code != null) {
      if (code == needle || code.contains(needle) || needle.contains(code)) {
        matchedIds.add(category.id);
        continue;
      }

      final aliases = systemCategoryAliases[code] ?? const [];
      for (final alias in aliases) {
        if (alias == needle ||
            alias.contains(needle) ||
            needle.contains(alias)) {
          matchedIds.add(category.id);
          break;
        }
      }
    }
  }

  return matchedIds;
}