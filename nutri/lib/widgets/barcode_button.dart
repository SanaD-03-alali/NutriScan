import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/barcode_result_screen.dart';

class BarcodeButton extends StatelessWidget {
  const BarcodeButton({super.key});

  Future<void> _scanBarcode(BuildContext context) async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission required to scan barcodes')),
        );
        return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: const BarcodeScannerScreen(),
        ),
      ),
    );
  }

  void _enterBarcodeManually(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String barcode = '';
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Barcode',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => barcode = value,
                  decoration: const InputDecoration(
                    hintText: 'Enter barcode number',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (barcode.isNotEmpty) {
                          barcode = barcode.replaceAll(RegExp(r'\s+'), '');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarcodeResultScreen(barcode: barcode),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1C0E), // Darker green
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF2F5A3D), // Light accent color
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.greenAccent.withOpacity(0.1),
          highlightColor: Colors.greenAccent.withOpacity(0.05),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: const Color(0xFF0C2311), // Dark theme color
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.green[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.camera_alt, color: Colors.greenAccent),
                          title: const Text('Scan Barcode', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pop(context);
                            _scanBarcode(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.edit, color: Colors.greenAccent),
                          title: const Text('Enter Manually', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pop(context);
                            _enterBarcodeManually(context);
                          },
                        ),
                        const SizedBox(height: 20), // Extra bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: Row(
            children: [
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F4A32), // Medium dark green
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.greenAccent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.greenAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Scan Barcode',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Or enter barcode manually',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.greenAccent,
                size: 16,
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
            facing: CameraFacing.back,
            torchEnabled: false,
          ),
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final String? code = barcodes.first.rawValue;
              if (code != null) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarcodeResultScreen(barcode: code),
                  ),
                );
              }
            }
          },
        ),
        CustomPaint(
          painter: ScannerOverlayPainter(),
          child: const SizedBox.expand(),
        ),
      ],
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaSize = size.width * 0.7;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;
    final double right = left + scanAreaSize;
    final double bottom = top + scanAreaSize;

    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5);

    final Paint borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw background overlay
    Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    Path scanArea = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(left, top, right, bottom),
        const Radius.circular(12),
      ));

    final Path finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      scanArea,
    );

    canvas.drawPath(finalPath, backgroundPaint);

    // Draw corner markers
    const double markerLength = 30.0;

    // Top left corner
    canvas.drawLine(Offset(left, top + markerLength), Offset(left, top), borderPaint);
    canvas.drawLine(Offset(left, top), Offset(left + markerLength, top), borderPaint);

    // Top right corner
    canvas.drawLine(Offset(right - markerLength, top), Offset(right, top), borderPaint);
    canvas.drawLine(Offset(right, top), Offset(right, top + markerLength), borderPaint);

    // Bottom left corner
    canvas.drawLine(Offset(left, bottom - markerLength), Offset(left, bottom), borderPaint);
    canvas.drawLine(Offset(left, bottom), Offset(left + markerLength, bottom), borderPaint);

    // Bottom right corner
    canvas.drawLine(Offset(right - markerLength, bottom), Offset(right, bottom), borderPaint);
    canvas.drawLine(Offset(right, bottom), Offset(right, bottom - markerLength), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 