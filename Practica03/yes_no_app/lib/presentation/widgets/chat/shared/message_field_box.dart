import 'package:flutter/material.dart';

class MessageFieldBox extends StatefulWidget {

  final ValueChanged<String>onValue;


  const MessageFieldBox({super.key, required this.onValue});

  @override
  State<MessageFieldBox> createState() => _MessageFieldBoxState();
}

class _MessageFieldBoxState extends State<MessageFieldBox> {
  final textController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    void submitMessage(String value) {
      final trimmedValue = value.trim();
      if (trimmedValue.isEmpty) return; // evita enviar mensajes vacíos

      widget.onValue(trimmedValue);
      textController.clear();
    }

    final inputDecoration = InputDecoration(
      filled: true,
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      hintText: 'Escribe un mensaje...',
      suffixIcon: IconButton(
        icon: const Icon(Icons.send_outlined),
        onPressed: () {
          submitMessage(textController.text);
        },
       
      ),
    );

    return TextFormField(
      onTapOutside: (event) {
        focusNode.unfocus(); // Ocultar el teclado al tocar fuera del TextFormField
      },
      focusNode: focusNode,
      controller: textController,
      decoration: inputDecoration,
      onFieldSubmitted: (value) {
        submitMessage(value);
        focusNode.requestFocus();
      },
    );
  }
}