import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<String> voucherImages = List.generate(
    10,
    (index) => 'assets/voucher_${index + 1}.jpeg',
  );

  HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Vouchers'),
      ),
      body: ListView.builder(
        itemCount: voucherImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

            //conversione immagine in scala di grigi usando una matrice di trasformazione dei colori.
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, 0, // red
                0.2126, 0.7152, 0.0722, 0, 0, // green
                0.2126, 0.7152, 0.0722, 0, 0, // blue
                0, 0, 0, 1, 0,               // alpha
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  voucherImages[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}