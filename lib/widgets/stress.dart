import 'dart:math';

double stress(heartRateData,restingHeartRateData) {
// Lista di battiti cardiaci (BPM) rilevati nel tempo
List<int> valueHR= [];
for (var heart in heartRateData) {
  valueHR.add(heart.value);
}

List<double> restingHR= [];

for (var r in restingHeartRateData) {
  restingHR.add(r.value);
  print(restingHR);
}
print('Resting HR: $restingHR');  
// Calcolo degli intervalli RR in millisecondi
List<int> rrIntervals = bpmToRRIntervals(valueHR);

// Calcolo SDNN (deviazione standard RR) 
double sdnn = calculateSDNN(rrIntervals);
//print('SDNN (ms): ${sdnn.toStringAsFixed(2)}');

double rmssd = calculateRMSSD(rrIntervals);
//print('RMSSD (ms): ${rmssd.toStringAsFixed(2)}');

//print('Battito a riposo (RHR): $restingHR');

// Calcolo livello di stress combinato (0 = rilassato, 1 = stressato)
double stressScore = calculateStressScore(sdnn, rmssd, restingHR[0].toDouble())*100;
print('Livello di stress (0-100): ${stressScore.toStringAsFixed(0)}');
//tostringAsFixed(0) usa 0 cifre decimali

// Interpretazione qualitativa
String interpretation = interpretStressScore(stressScore);
print('Interpretazione: $interpretation');

return stressScore;
}



//funzioni 
/// Converte una lista di BPM in lista di intervalli RR in ms
List<int> bpmToRRIntervals(List<int> bpmValues) {
return bpmValues.map((bpm) => (60000 / bpm).round()).toList();
}

/// Calcola la deviazione standard (SDNN) degli intervalli RR
double calculateSDNN(List<int> rr) {
if (rr.length < 2) return 0.0;

double mean = rr.reduce((a, b) => a + b) / rr.length;
double variance = rr.map((r) => pow(r - mean, 2)).reduce((a, b) => a + b) / rr.length;
return sqrt(variance);
}


double calculateRMSSD(List<int> rr) {
  if (rr.length < 2) return 0.0;

  List<double> diffSquared = [];

  for (int i = 1; i < rr.length; i++) {
    double diff = (rr[i] - rr[i - 1]).toDouble();
    diffSquared.add(diff * diff);
  }

  double meanSquaredDiff = diffSquared.reduce((a, b) => a + b) / diffSquared.length;
  return sqrt(meanSquaredDiff);
}

/// Calcola un punteggio di stress normalizzato da 0 a 1
double calculateStressScore(double sdnn,double rmssd ,double rhr) {
double normalizedHRV = ((100 - sdnn).clamp(0, 80)) / 80; // più basso SDNN = più stress
double normalizedRHR = ((rhr - 50).clamp(0, 40)) / 40; // più alto RHR = più stress
return ((normalizedHRV + normalizedRHR) / 2).clamp(0.0, 1.0);
}

/// Fornisce una interpretazione qualitativa combinando SDNN e RHR
String interpretStressScore(double score) {
  if (score < 20) return "Molto rilassato";
  if (score < 40) return "Rilassato";
  if (score < 70) return "Stressato";
  return "Altamente stressato";
}
