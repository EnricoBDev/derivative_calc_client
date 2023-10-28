import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MathDisplay extends StatelessWidget {
  MathDisplay({super.key, required this.jsonResponse});

  final Map jsonResponse;

  String formatPointKind(String rawKind) {
    switch (rawKind) {
      case "corner_point":
        return "corner point";
      case "derivable_point":
        return "derivable point";
      case "vertical_tangent":
        return "vertical tangent";
      case "cusp":
        return "cusp";
      case "stationary_point":
        return "stationary point";
      default:
        return "";
    }
  }

  late final pointKind = formatPointKind(jsonResponse["points"][0]["kind"]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Math.tex(
          "\\text{The derivative is: \\hspace{1mm}} ${jsonResponse["derivative"]}",
          textStyle: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 15,
        ),
        Math.tex(
          "\\text{Point\\hspace{1mm}} (${jsonResponse["points"][0]["x_0"]}, ${jsonResponse["points"][0]["y_0"]})  \\text{\\hspace{1mm} is a ${pointKind}}",
          textStyle: TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
