class CategoryRecord {
  const CategoryRecord({
    required this.id,
    required this.name,
    required this.systemCode,
    required this.isSystem,
    this.iconCodePoint = 0xe8cc,
    this.colorValue = 0xff607d8b,
    this.usageCount = 0,
    this.spendingMinor = 0,
    this.lastUsedAt,
  });

  final String id;
  final String name;
  final String? systemCode;
  final bool isSystem;
  final int iconCodePoint;
  final int colorValue;
  final int usageCount;
  final int spendingMinor;
  final DateTime? lastUsedAt;
}

enum DeleteCategoryResult { deleted, inUse, systemCategory }

abstract interface class CategoryRepository {
  Stream<List<CategoryRecord>> watchAll(String profileId);
  Future<void> ensureSystemCategories(String profileId);
  Future<CategoryRecord> createCustom(String profileId, String name);
  Future<void> renameCustom(String categoryId, String name);
  Future<void> updateAppearance(
    String categoryId, {
    required int iconCodePoint,
    required int colorValue,
  });
  Future<DeleteCategoryResult> deleteCustom(String categoryId);
  Future<void> reassignAndDelete(
    String categoryId,
    String replacementCategoryId,
  );
}
