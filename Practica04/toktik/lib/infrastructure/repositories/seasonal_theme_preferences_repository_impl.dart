import 'package:toktik/domain/repositories/seasonal_theme_preferences_repository.dart';
import 'package:toktik/infrastructure/datasources/local_preferences_datasource.dart';

class SeasonalThemePreferencesRepositoryImpl
    implements SeasonalThemePreferencesRepository {
  final LocalPreferencesDatasource _dataSource;

  const SeasonalThemePreferencesRepositoryImpl(this._dataSource);

  @override
  DateTime? get simulatedDate => _dataSource.simulatedDate;

  @override
  Future<void> saveSimulatedDate(DateTime? date) {
    return _dataSource.setSimulatedDate(date);
  }
}
