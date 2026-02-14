import 'package:flutter/material.dart';

class CaptureGuideOverlay extends StatelessWidget {
  const CaptureGuideOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('Alineá el ticket dentro del marco')),
    );
  }
}
