import 'dart:convert';

import 'package:http/http.dart' as http;

class DailymotionStreamResolver {
  final http.Client _client;

  DailymotionStreamResolver({http.Client? client})
    : _client = client ?? http.Client();

  Future<Uri> resolve(String videoPageUrl) async {
    final page = Uri.parse(videoPageUrl);
    final videoId = page.pathSegments.isEmpty ? '' : page.pathSegments.last;
    if (videoId.isEmpty) {
      throw const FormatException('La URL de Dailymotion no contiene un ID.');
    }

    final response = await _client
        .get(
          Uri.https('www.dailymotion.com', '/player/metadata/video/$videoId'),
          headers: const {
            'Accept': 'application/json',
            'User-Agent': 'Mozilla/5.0 (compatible; TokTik/1.0)',
          },
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception(
        'Dailymotion respondió con el estado ${response.statusCode}.',
      );
    }

    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de Dailymotion no es válida.');
    }
    final qualities = data['qualities'];
    if (qualities is! Map<String, dynamic>) {
      throw const FormatException(
        'Dailymotion no proporcionó calidades reproducibles.',
      );
    }

    final qualityNames = [
      'auto',
      '1080',
      '720',
      '480',
      ...qualities.keys.where((key) => key != 'auto'),
    ];
    for (final quality in qualityNames) {
      final candidates = qualities[quality];
      if (candidates is! List) continue;
      for (final candidate in candidates) {
        if (candidate is! Map<String, dynamic>) continue;
        final url = candidate['url'];
        if (url is! String) continue;
        final stream = Uri.tryParse(url);
        if (stream != null &&
            stream.hasScheme &&
            (stream.scheme == 'https' || stream.scheme == 'http')) {
          return stream;
        }
      }
    }
    throw const FormatException(
      'No se encontró una transmisión reproducible para este video.',
    );
  }

  void close() => _client.close();
}
