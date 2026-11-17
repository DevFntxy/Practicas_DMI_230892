import 'package:flutter/material.dart';
import 'package:cinemapedia/config/localization/app_localizations.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages(List<String> messages) {
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(strings.pleaseWait),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),

          StreamBuilder(
            stream: getLoadingMessages(strings.loadingMessages),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text(strings.loading);

              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
