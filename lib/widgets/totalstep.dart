import 'package:denicotox/models/stepdata.dart'; 


int calculateTotalSteps(List<StepData> data) {
  
/*
  SOMMAR PASSI DI SOLI GIORNI DIVERSI
   int currentSteps = totalStepsBox.get('totalSteps', defaultValue: 0) ?? 0;
  totalStepsBox.put('totalSteps', currentSteps + totalStepsofDay); //aggiorno database  
  int totalSteps = totalStepsBox.get('totalsteps', defaultValue: 0) ?? 0; //DATABASE
  */


  return data.fold(0, (sum, item) => sum + item.value);

}