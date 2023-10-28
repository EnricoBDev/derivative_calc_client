import 'package:derivative_calculator/shared_prefs_helper.dart';
import 'package:derivative_calculator/widgets/math_display.dart';
import 'package:derivative_calculator/widgets/math_input_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final _channel;
  late final _webSocketInitialization;

  Future<bool> _initializeWebSocket() async {
    final ipAddr = await PrefsHelper.getIp();
    _channel = WebSocketChannel.connect(Uri.parse("ws://$ipAddr:8765"));
    return true;
  }

  @override
  void initState() {
    _webSocketInitialization = _initializeWebSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _webSocketInitialization,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MathKeyboardViewInsets(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Derivative Calculator"),
                  actions: [
                    PopupMenuButton(
                      icon: const Icon(Icons.menu),
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 0,
                            child: Text("Change Ip"),
                          ),
                          const PopupMenuItem(
                              value: 1, child: Text("Informations")),
                        ];
                      },
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            PrefsHelper.setIp("");
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("Now reload the application"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            SystemChannels.platform
                                                .invokeMethod(
                                                    'SystemNavigator.pop');
                                          },
                                          child: Text("Ok"))
                                    ],
                                  );
                                });
                          case 1:
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Derivability criteria"),
                                    content: Column(
                                      children: [
                                        const Text(
                                            "This application works by using the derivability criteria that works only when:"),
                                        Math.tex(
                                          "\\text{the function is continue in } [a,b], \\text{ derivable in } (a,b) - \\{x_0 \\in (a,b) \\}",
                                          textStyle: TextStyle(fontSize: 18),
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, "Ok");
                                          },
                                          child: Text("Ok"))
                                    ],
                                  );
                                });
                        }
                      },
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: ListView(children: [
                    MathInputForm(channel: _channel),
                    StreamBuilder(
                        stream: _channel.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final responseMap =
                                jsonDecode(snapshot.data.toString());
                            return Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: MathDisplay(
                                jsonResponse: responseMap,
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text(""),
                            );
                          }
                        })
                  ]),
                ),
              ),
            );
          } else {
            return const SpinKitPouringHourGlassRefined(color: Colors.black);
          }
        });
  }
}
