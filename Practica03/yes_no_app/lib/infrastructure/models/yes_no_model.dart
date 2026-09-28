import 'package:yes_no_app/domain/entities/message.dart';

class YesNoModel {
  final String answer;
  final bool forced;
  final String image;

  YesNoModel({required this.answer, required this.forced, required this.image});

  factory YesNoModel.fromJsonMap(Map<String, dynamic> json) => YesNoModel(
    answer: json["answer"],
    forced: json["forced"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "answer": answer,
    "forced": forced,
    "image": image,
  };

  Message toMessageEntity() => Message(
    text: answer == 'yes'
        ? 'Sí'
        : answer == 'no'
        ? 'No'
        : 'Tal Vez',
    fromwho: Fromwho.hers,
    imageUrl: answer == 'yes'
        ? 'assets/gifs/happy.gif'
        : answer == 'no'
        ? 'assets/gifs/sad.gif'
        : 'assets/gifs/thinking.gif',
  );
}
