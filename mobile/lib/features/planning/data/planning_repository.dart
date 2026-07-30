class PlanningRecord {
  const PlanningRecord({
    required this.id,
    required this.section,
    required this.name,
    required this.amountMinor,
    this.date,
    this.categoryId,
  });

  final String id;
  final String section;
  final String name;
  final int amountMinor;
  final DateTime? date;
  final String? categoryId;
}

abstract interface class PlanningRepository {
  Stream<List<PlanningRecord>> watchSection(
    String profileId,
    String section,
  );
  Future<void> create({
    required String profileId,
    required String section,
    required String name,
    required int amountMinor,
    required DateTime date,
    String? categoryId,
  });
  Future<void> delete(String section, String id);
}
