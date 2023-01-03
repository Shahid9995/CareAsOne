import 'package:careAsOne/view/documents/api_pdaf.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:open_file/open_file.dart' ;
import 'dart:ui' as ui;
class SignatureSeeker extends StatefulWidget {
  const SignatureSeeker({Key? key}) : super(key: key);

  @override
  _SignatureSeekerState createState() => _SignatureSeekerState();
}

class _SignatureSeekerState extends State<SignatureSeeker> {
  final signatureKey = GlobalKey<SfSignaturePadState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Signature"),
          Container(
              child: SfSignaturePad(
                backgroundColor: Colors.yellow.withOpacity(0.2),
                key: signatureKey,
              )),
          TextButton(child: Text("Submit"), onPressed: () async {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) =>
                    Center(child: CircularProgressIndicator(),));
            final image = await signatureKey.currentState!.toImage();
            final imagSign = await image.toByteData(
                format: ui.ImageByteFormat.png);

            final file = await PdfApi.generate(imageSignature: imagSign!);
            Navigator.pop(context);
            await OpenFile.open(file.path);
          },),
        ],
      ),
    );
  }
}