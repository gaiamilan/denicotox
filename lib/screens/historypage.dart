import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:denicotox/providers/data_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<String> voucherImages = List.generate(
    10,
    (index) => 'assets/voucher_${index + 1}.jpeg',
  );

  List<int> evidenziatiIndices = [];

  @override
  void initState() {
    super.initState();
    _loadEvidenziatiIndices();
  }

  Future<void> _loadEvidenziatiIndices() async {
    final prefs = await SharedPreferences.getInstance();
    final indicesStringList = prefs.getStringList('evidenziati_indices') ?? [];
    //print("Loaded indices: $indicesStringList");

    setState(() {
      evidenziatiIndices =
          indicesStringList.map((s) => int.tryParse(s)).whereType<int>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Vouchers'),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (evidenziatiIndices.isEmpty) {
            return const Center(child: Text("Nessun voucher sbloccato ancora."));
          }

          // Rimuove duplicati, ordina per mantenere ordine visivo
          final uniqueIndices = evidenziatiIndices.toSet().toList();
          uniqueIndices.sort();

          // Crea una lista di tutti gli indici delle immagini
          List<int> allIndices = List.generate(voucherImages.length, (i) => i);

          // Ordina mettendo prima gli evidenziati
          allIndices.sort((a, b) {
            if (uniqueIndices.contains(a) && !uniqueIndices.contains(b)) return -1;
            if (!uniqueIndices.contains(a) && uniqueIndices.contains(b)) return 1;
            return 0;
          });

          return ListView.builder(
            itemCount: allIndices.length,
            itemBuilder: (context, i) {
              final index = allIndices[i];
              final isEvidenziato = uniqueIndices.contains(index);

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
