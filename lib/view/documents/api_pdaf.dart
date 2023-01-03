import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfApi {
  static Future<File> generate({
    required ByteData imageSignature,
  }) async {
    final document = PdfDocument();
    final page = document.pages.add();
    drawSignature(page, imageSignature);
    return saveFile(document);
  }

  static void drawSignature(PdfPage page, ByteData imageSignature) {
    final pageSize = page.getClientSize();
    final PdfBitmap image = PdfBitmap(imageSignature.buffer.asUint8List());
    page.graphics.drawImage(image,
        Rect.fromLTWH(pageSize.width - 120, pageSize.height - 200, 100, 40));
  }
  static Future<File> saveFile(PdfDocument document) async {
    Future<List<int>> bytes = document.save();
    var androidPath;
    var filePath;
    File file;
    String fileName = 'CAO-signature.png';
    String newPath="";
    if (Platform.isAndroid) {
      newPath = '/storage/emulated/0/Download';
    } else if (Platform.isIOS) {
      newPath = (await getTemporaryDirectory()).path;
    }

    filePath = newPath + "/documentSignature.pdf";
    file = File(filePath);
    file.writeAsBytes(await bytes);
    document.dispose();
    return file;
  }
}
