import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:math_keyboard/math_keyboard.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MathInputForm extends StatefulWidget {
  const MathInputForm({super.key, required WebSocketChannel channel})
      : _channel = channel;
  final WebSocketChannel _channel;

  @override
  State<MathInputForm> createState() => _MathInputFormState();
}

class _MathInputFormState extends State<MathInputForm> {
  final _functionController = MathFieldEditingController();
  final _pointController = MathFieldEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> _checkConnection() async {
    try {
      await widget._channel.ready;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _functionController.dispose();
    _pointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        const Text(
          "Insert function f(x):",
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(
          height: 20,
        ),
        MathFormField(
          controller: _functionController,
          keyboardType: MathKeyboardType.expression,
          variables: const ["x"],
          decoration: InputDecoration(
            hintText: "Function",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value == r'\Box') {
              return 'Missing expression (:';
            }
            try {
              TeXParser(value).parse();
              return null;
            } catch (_) {
              return 'Invalid expression (:';
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Insert x coordinate of point:",
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(
          height: 20,
        ),
        MathFormField(
          controller: _pointController,
          keyboardType: MathKeyboardType.expression,
          variables: [],
          decoration: InputDecoration(
            hintText: "Point",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value == r'\Box') {
              return 'Missing expression (:';
            }
            try {
              TeXParser(value).parse();
              return null;
            } catch (_) {
              return 'Invalid expression (:';
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        FilledButton(
            onPressed: () async {
              final result = _formKey.currentState!.validate();
              if (result) {
                late final isAlive;
                isAlive = await _checkConnection();
                if (isAlive) {
                  // check if websocket is running
                  final latexFunction =
                      _functionController.currentEditingValue();
                  final latexPoint = _pointController.currentEditingValue();
                  final requestMap = {
                    "function": latexFunction,
                    "x_0": latexPoint
                  };
                  widget._channel.sink.add(jsonEncode(requestMap));
                }
                // send to websocket
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "Submit",
                style: TextStyle(fontSize: 16),
              ),
            ))
      ]),
    );
  }
}
