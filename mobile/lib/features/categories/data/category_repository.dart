class CategoryRecord {
  const CategoryRecord({
    required this.id,
    required this.name,
    required this.systemCode,
    required this.isSystem,
  });

  final String id;
  final String name;
  final String? systemCode;
  final bool isSystem;
}

enum DeleteCategoryResult { deleted, inUse, systemCategory }

abstract interface class CategoryRepository {
  Stream<List<CategoryRecord>> watchAll(String profileId);
  Future<void> ensureSystemCategories(String profileId);
  Future<CategoryRecord> createCustom(String profileId, String name);
  Future<void> renameCustom(String categoryId, String name);
  Future<DeleteCategoryResult> deleteCustom(String categoryId);
}
