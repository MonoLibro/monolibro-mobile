import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/paragraph.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    RsaKeyHelper().encodePublicKeyToPem
    return const SizedBox(
        child: Center(
            child: Paragraph(
                color: Color(0xFFFFFFFF),
                text: "hello world"
            )
        )
    );
  }
}
