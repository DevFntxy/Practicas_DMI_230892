abstract class SeasonalThemePreferencesRepository {
  DateTime? get simulatedDate;

  Future<void> saveSimulatedDate(DateTime? date);
}
