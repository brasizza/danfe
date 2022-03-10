import 'package:danfe/danfe.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';

class DanfePrinter {
  final PaperSize paperSize;
  DanfePrinter(this.paperSize) {
    Intl.defaultLocale = 'pt_BR';
  }
  String formatMoneyMilhar(String number, {String modeda = '', String simbolo = ''}) {
    NumberFormat formatter = NumberFormat.currency(decimalDigits: 2, symbol: simbolo);
    return formatter.format(double.parse(number));
  }

  String formatNumber(String number) {
    String result;
    result = NumberFormat('###.##').format(double.parse(number));
    return result;
    // NumberFormat();
  }

  Future<List<int>> bufferDanfe(Danfe? danfe) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);
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
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
          linesAfter: 1);
    }

    bytes += generator.rawBytes([27, 97, 48]);
    bytes += generator.text("CPF/CNPJ do consumidor: " + (danfe?.dados?.dest?.cpf ?? ''), styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text("Nota : " + (danfe?.dados?.ide?.nNF ?? ''), styles: const PosStyles(align: PosAlign.left));
    bytes += generator.feed(1);
    bytes += generator.row([
      PosColumn(text: 'DESCRICAO', width: 7),
      PosColumn(text: 'QTD', width: 1),
      PosColumn(text: 'VLUN', width: 3, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: 'VLTOT', width: 3, styles: const PosStyles(align: PosAlign.right)),
    ]);
    if (danfe?.dados?.det != null) {
      for (Det det in danfe!.dados!.det!) {
        bytes += generator.row([
          PosColumn(text: det.prod?.xProd ?? '', width: 7),
          PosColumn(text: formatNumber(det.prod?.qCom ?? ''), width: 1),
          PosColumn(text: formatMoneyMilhar(det.prod?.vUnCom ?? '', modeda: 'pt_BR', simbolo: r'R$'), width: 3),
          PosColumn(text: formatMoneyMilhar(det.prod?.vProd ?? '', modeda: 'pt_BR', simbolo: r'R$'), width: 3),
        ]);
      }
    }

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: formatMoneyMilhar(danfe?.dados?.total?.valorTotal ?? '', modeda: 'pt_BR', simbolo: r'R$'),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);
    bytes += generator.qrcode(danfe?.qrcodePrinter ?? '');
    bytes += generator.feed(1);
    bytes += generator.hr(ch: '=', linesAfter: 1);

    bytes += generator.cut();

    return bytes;
  }
}
