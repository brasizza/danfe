import 'package:danfe/danfe.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class DanfePrinter {
  DanfePrinter._();

  static Future<List<int>> bufferDanfe(Danfe? danfe, PaperSize sizePaper) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(sizePaper, profile);
    List<int> bytes = [];
    // Print image
    bytes += generator.rawBytes([27, 97, 49]);

    bytes += generator.text(danfe?.dados?.emit?.xFant ?? '', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text((danfe?.dados?.emit?.cNPJ ?? ''), styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text((danfe?.dados?.emit?.enderEmit?.xLgr ?? '') + ', ' + ((danfe?.dados?.emit?.enderEmit?.nro ?? '')), styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();
    if ((danfe?.tipo ?? 'CFe') == 'CFe') {
      bytes += generator.text('Nota Fiscal Eletronica - SAT ',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
          linesAfter: 1);
    } else {
      bytes += generator.text('Nota Fiscal Eletronica - NFC-E ',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
          linesAfter: 1);
    }

    bytes += generator.rawBytes([27, 97, 49]);
    bytes += generator.text("CPF/CNPJ do consumidor: " + (danfe?.dados?.dest?.cpf ?? ''), styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text("Nota : " + (danfe?.dados?.ide?.nNF ?? ''), styles: const PosStyles(align: PosAlign.left));

    bytes += generator.row([
      PosColumn(text: 'DESCRICAO', width: 7),
      PosColumn(text: 'QTD', width: 1),
      PosColumn(text: 'VLUN', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: 'VLTOT', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);
    if (danfe?.dados?.det != null) {
      for (Det det in danfe!.dados!.det!) {
        bytes += generator.row([
          PosColumn(text: det.prod?.xProd ?? '', width: 7),
          PosColumn(text: det.prod?.qCom ?? '', width: 1),
          PosColumn(text: det.prod?.vUnCom ?? '', width: 2, styles: const PosStyles(align: PosAlign.right)),
          PosColumn(text: det.prod?.vProd ?? '', width: 2, styles: const PosStyles(align: PosAlign.right)),
        ]);
      }
    }

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: danfe?.dados?.total?.valorTotal ?? '',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    // bytes += generator.row([
    //   PosColumn(text: 'Cash', width: 8, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    //   PosColumn(text: '\$15.00', width: 4, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    // ]);
    // bytes += generator.row([
    //   PosColumn(text: 'Change', width: 8, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    //   PosColumn(text: '\$4.03', width: 4, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    // ]);

    // bytes += generator.feed(2);
    // bytes += generator.text('Thank you!', styles: const PosStyles(align: PosAlign.center, bold: true));
    // final now = DateTime.now();
    // bytes += generator.text(now.toIso8601String(), styles: const PosStyles(align: PosAlign.center), linesAfter: 2);
    bytes += generator.qrcode('example.com');
    bytes += generator.feed(1);
    bytes += generator.cut();

    return bytes;
  }
}
