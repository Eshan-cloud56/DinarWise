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
