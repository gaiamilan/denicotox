import 'package:flutter/material.dart';
import 'package:denicotox/providers/data_provider.dart';
import 'package:provider/provider.dart';

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
      body: Consumer<DataProvider>(
        builder: (context, data, child) {
          // Ricrea una lista con l’evidenziato in cima
          List<int> indices = List.generate(voucherImages.length, (i) => i);
          if (data.voucherEvidenziatoIndex != null) {
            int idx = data.voucherEvidenziatoIndex!;
            indices.remove(idx);
            indices.insert(0, idx);
          }

          return ListView.builder(
            itemCount: indices.length,
            itemBuilder: (context, i) {
              int index = indices[i];
              bool isEvidenziato = index == data.voucherEvidenziatoIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: isEvidenziato
                      ? Image.asset(
                          voucherImages[index],
                          fit: BoxFit.cover,
                        )
                      : ColorFiltered(
                          colorFilter: const ColorFilter.matrix(<double>[
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0, 0, 0, 1, 0,
                          ]),
                          child: Image.asset(
                            voucherImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
