import 'package:derivative_calculator/shared_prefs_helper.dart';
import 'package:flutter/material.dart';

class IpAddressForm extends StatefulWidget {
  const IpAddressForm({super.key});
  @override
  State<IpAddressForm> createState() => _IpAddressFormState();
}

class _IpAddressFormState extends State<IpAddressForm> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ip Address configuration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                "Enter the server's Ip address or URL",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Ip address or URL",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FilledButton(
                  onPressed: () {
                    PrefsHelper.setIp(_controller.text);
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      "Enter",
                      style: TextStyle(fontSize: 16),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
