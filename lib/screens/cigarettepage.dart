import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart'; // x istogramma
import 'dart:convert'; //converte oggetti Dart in JSON x salvare in formato json le sigarette fumate x giorno x costruire grafico

class CigarettePage extends StatefulWidget {
  const CigarettePage({super.key});

  @override
  _CigarettePageState createState() => _CigarettePageState();
}

class _CigarettePageState extends State<CigarettePage> {
  String _motivation = '';
  String _frasimotivazionali = '';
  bool _showSadFace = true;
  bool _giaInseritoOggi = false;
  Map<String, dynamic> _datiSigarette = {}; //salva i dati delle siga negli ultimi 7 giorni

  final List<String> _frasi = [
    'Smettere di fumare oggi è il primo passo verso un domani più sano.',
    'Ogni giorno senza sigarette è una vittoria per il tuo corpo e la tua mente.',
    'Non lasciare che una sigaretta controlli la tua vita: tu sei più forte.',
    'Il vero coraggio è dire no al fumo e sì a te stesso.',
    'La tua salute è il tuo bene più prezioso, proteggila scegliendo di smettere.',
    'Respira libertà, smetti di fumare.',
    'Ogni sigaretta che non accendi è un dono che fai ai tuoi polmoni.',
    'La vita è troppo bella per sprecarla con il fumo.',
    'Smettere di fumare è un viaggio, non una destinazione. Fai un passo alla volta.',
    'Se puoi immaginarlo, puoi farlo: smetti di fumare e vivi al meglio.',
  ];

  final TextEditingController _sigaretteController = TextEditingController(); //legge ciò che scrive l user nello spazio risposta
  int? _sigaretteFumate;

  @override
  void initState() {
    super.initState();
    _loadMotivationAndStartDelay();
    _checkIfAlreadyInsertedToday();
    _loadSigarettePerSettimana();
  }

  //Aggiungo uno stato per salvare i dati mappa e caricali nel initState
  Future<void> _loadSigarettePerSettimana() async {
    final sp = await SharedPreferences.getInstance();
    final String? jsonData = sp.getString('sigarette_per_giorno');
    if (jsonData != null) {
      setState(() {
        _datiSigarette = json.decode(jsonData);
      });
    }
  }

  // per controllare se il numero di sigarette è stato gia inserito quel giorno
  Future<void> _checkIfAlreadyInsertedToday() async {
    final sp = await SharedPreferences.getInstance();
    final String? jsonData = sp.getString('sigarette_per_giorno');
    if (jsonData != null) {
      Map<String, dynamic> datiSalvati = json.decode(jsonData);
      final oggi = DateTime.now();
      final chiaveData =
          "${oggi.year}-${oggi.month.toString().padLeft(2, '0')}-${oggi.day.toString().padLeft(2, '0')}";
      if (datiSalvati.containsKey(chiaveData)) {
        setState(() {
          _giaInseritoOggi = true;
          _sigaretteFumate = datiSalvati[chiaveData];
        });
      }
    }
  }

  Future<void> _loadMotivationAndStartDelay() async {
    await Future.delayed(Duration(seconds: 2));
    final sp = await SharedPreferences.getInstance();
    final String? savedMotivation = sp.getString('motivazione');

    setState(() {
      _motivation = savedMotivation ?? 'Nessuna motivazione salvata';
      _showSadFace = false;
    });
  }

  void _cambiaFrase() {
    setState(() {
      _frasimotivazionali = (_frasi..shuffle()).first; //doppio punto x mescolare le frasi e restituire la nuova lista mescolata
    });
  }

  //salvare giorno x giorno le siga
  Future<void> _salvaSigarette() async {
    final text = _sigaretteController.text;
    final numero = int.tryParse(text);
    if (numero != null) {
      final sp = await SharedPreferences.getInstance();
      final String? jsonData = sp.getString('sigarette_per_giorno'); //salva il dato in sigarette_per_giorno nel file json
      //Se esiste già un JSON salvato, lo decodifica da stringa a mappa (Map<String, dynamic>). Se non esiste, crea una mappa vuota {}.
      Map<String, dynamic> datiSalvati =
          jsonData != null ? json.decode(jsonData) : {};

      final oggi = DateTime.now(); //data di oggi
      //Crea una stringa della data in formato YYYY-MM-DD
      final chiaveData =
          "${oggi.year}-${oggi.month.toString().padLeft(2, '0')}-${oggi.day.toString().padLeft(2, '0')}";

      datiSalvati[chiaveData] = numero;
      await sp.setString('sigarette_per_giorno', json.encode(datiSalvati));

      setState(() {
        _sigaretteFumate = numero;
        _sigaretteController.clear();
        _giaInseritoOggi = true; // dopo il salvataggio disabilito input
      });
    }
  }

  List<BarChartGroupData> _buildBarChartData(Map<String, dynamic> datiSalvati) {
    final oggi = DateTime.now();
    List<BarChartGroupData> barGroups = [];

    // COSTRUZIONE ISTOGRAMMA ANDAMENTO SIGA
    // ultimi 7 giorni 
    for (int i = 6; i >= 0; i--) {
      final giorno = oggi.subtract(Duration(days: i)); //prendo la data di i giorni fa rispetto oggi
      final chiaveData =
          "${giorno.year}-${giorno.month.toString().padLeft(2, '0')}-${giorno.day.toString().padLeft(2, '0')}";
      final valore = datiSalvati[chiaveData] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: 6 - i, // 0..6, 0 è 7 giorni fa, 6 è oggi
          barRods: [
            BarChartRodData(
              toY: valore.toDouble(),
              color: Colors.blue,
              width: 20,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Hai fumato')),
    body: Center(
      child: _showSadFace
          ? Icon(Icons.sentiment_dissatisfied, size: 100, color: Colors.red)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ricordati perché stai smettendo...',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  _motivation,
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                if (_frasimotivazionali.isNotEmpty) ...[
                  SizedBox(height: 40),
                  Text(
                    _frasimotivazionali,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _cambiaFrase,
                  child: Text('Mostra frase motivazionale'),
                ),
                SizedBox(height: 50),
                if (!_giaInseritoOggi) ...[
                  Text('Quante sigarette hai fumato oggi?'),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _sigaretteController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Numero',
                      ),
                      onChanged:(valore){
                        int numeroSigarette= int.tryParse(valore)?? 0;
                        //int giornoOggi =DateTime.now().weekday;
                        final oggi =DateTime.now();
                        final chiaveData=
                        "${oggi.year}-${oggi.month.toString().padLeft(2,'0')}-${oggi.day.toString().padLeft(2,'0')}";
                        setState((){
                          _datiSigarette[chiaveData]=numeroSigarette;
                        });
                      }
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _salvaSigarette,
                    child: Text('Salva'),
                  ),
                ] else ...[
                  Text(
                    'Hai già registrato $_sigaretteFumate sigarette oggi.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
                SizedBox(height: 50),
                Text(
                  'Andamento ultimi 7 giorni',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: BarChart(
                    BarChartData(
                      maxY: 20,
                      barGroups: _buildBarChartData(_datiSigarette),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final oggi = DateTime.now().toLocal();
                              //final giorno = oggi.add(Duration(days: value.toInt()));
                              final giorno = oggi.subtract(Duration(days: 6 - value.toInt())); //i giorni sono indicizzati al contrario, indicizzo correttamente
                              final giornoSettimana = ['L', 'Ma', 'Me', 'G', 'V', 'S','D'][giorno.weekday-1];
                              //giornoSettimana contiene la lettera del giorno corrispondente a giorno.
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(giornoSettimana, style: TextStyle(fontWeight: FontWeight.bold)),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    ),
  );
}
}
