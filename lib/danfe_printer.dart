import 'package:danfe/danfe.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class DanfePrinter {
  DanfePrinter._();

  Future<void> bufferDanfe(Danfe? danfe, PaperSize sizePaper) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(sizePaper, profile);
    List<int> bytes = [];
    // Print image

    bytes += generator.text('GROCERYLY',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text('889  Watson Lane', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('New Braunfels, TX', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: 830-221-1234', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Web: www.example.com', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 7),
      PosColumn(text: 'Price', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: 'Total', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: '2', width: 1),
      PosColumn(text: 'ONION RINGS', width: 7),
      PosColumn(text: '0.99', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '1.98', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'PIZZA', width: 7),
      PosColumn(text: '3.45', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '3.45', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'SPRING ROLLS', width: 7),
      PosColumn(text: '2.99', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '2.99', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: '3', width: 1),
      PosColumn(text: 'CRUNCHY STICKS', width: 7),
      PosColumn(text: '0.85', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '2.55', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);
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
          text: '\$10.97',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    bytes += generator.row([
      PosColumn(text: 'Cash', width: 8, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(text: '\$15.00', width: 4, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Change', width: 8, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(text: '\$4.03', width: 4, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    bytes += generator.feed(2);
    bytes += generator.text('Thank you!', styles: const PosStyles(align: PosAlign.center, bold: true));
    final now = DateTime.now();
    bytes += generator.text(now.toIso8601String(), styles: const PosStyles(align: PosAlign.center), linesAfter: 2);
    bytes += generator.qrcode('example.com');
    bytes += generator.feed(1);
    bytes += generator.cut();
  }
}
