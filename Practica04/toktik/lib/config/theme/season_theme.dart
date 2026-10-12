enum SeasonTheme { normal, halloween, christmas, valentines }

extension SeasonThemeLabel on SeasonTheme {
  String get label => switch (this) {
    SeasonTheme.normal => 'Normal',
    SeasonTheme.halloween => 'Halloween',
    SeasonTheme.christmas => 'Christmas',
    SeasonTheme.valentines => "Valentine's Day",
  };

  String get welcomeTitle => switch (this) {
    SeasonTheme.normal => 'Bienvenido a TokTik',
    SeasonTheme.halloween => 'Una noche escalofriante',
    SeasonTheme.christmas => 'La magia de la Navidad',
    SeasonTheme.valentines => 'Celebra el amor',
  };

  String get welcomeSubtitle => switch (this) {
    SeasonTheme.normal => 'Tu siguiente video favorito te espera',
    SeasonTheme.halloween => 'Videos para una noche de miedo',
    SeasonTheme.christmas => 'Que comience la temporada más especial',
    SeasonTheme.valentines => 'Historias que llegan al corazón',
  };

  String get welcomeEmoji => switch (this) {
    SeasonTheme.normal => '▶',
    SeasonTheme.halloween => '🎃',
    SeasonTheme.christmas => '🎄',
    SeasonTheme.valentines => '💝',
  };
}
