import 'package:flutter/material.dart';
import 'package:denicotox/models/heartratedata.dart';
import 'package:denicotox/models/stepdata.dart'; 
import 'package:denicotox/models/restingheartrate.dart';
import 'package:denicotox/services/impact.dart';


class DataProvider extends ChangeNotifier {
 //DateTime currentDate = DateTime.now();


  //This serves as database of the application
  List<StepData> stepData = [];
      //This serves as database of the application
  List<HeartRateData> heartRateData = [];
  List<int> valueHR = [];
  List<RestingHeartRateData> restingHeartRateData = [];
  final impactInstance = Impact();
  int voucherEvidenziatoIndex = 0; // Define the voucherEvidenziatoIndex variable



 Future<void> getDataOfDay(DateTime date) async{
    // reset the values to show loading animation
   _loading();
    // heartRates = await getHeartRateData(date);
    await fetchHRData(date);
    await fetchRestingHRData(date);
    await fetchStepData(date);
    print('New data fetched for date: $date');
  
    notifyListeners();
  }

    void _loading() {
    heartRateData = [];
    restingHeartRateData = [];
    notifyListeners();
  }


  //Method to fetch step data from the server
  Future<void> fetchStepData(DateTime date) async {

    //Get the response
    final data = await impactInstance.fetchStepData(date);

    //if OK parse the response adding all the elements to the list, otherwise do nothing
    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        stepData.add(
            StepData.fromJson(data['data']['date'], data['data']['data'][i]));
      } //for

      //remember to notify the listeners
      notifyListeners();
    }//if

  }//fetchStepData



  //Method to fetch heart rate data from the server
  Future<void> fetchHRData(DateTime date) async {
    //Get the response
    final data = await impactInstance.fetcHRData(date);

    //if OK parse the response adding all the elements to the list, otherwise do nothing
    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        heartRateData.add(
            HeartRateData.fromJson(data['data']['date'], data['data']['data'][i]));

      } //for

      //remember to notify the listeners
      notifyListeners();
    }//if

  }//fetchStepData

 //Method to fetch resting heart rate data from the server
  Future<void> fetchRestingHRData(DateTime date) async {
    //Get the response
    final data = await impactInstance.fetcRestingHRData(date);

    //if OK parse the response adding all the elements to the list, otherwise do nothing
    if (data != null) {
      restingHeartRateData.add(
            RestingHeartRateData.fromJson(data['data']['date'], data['data']['data']));
      } //for
      //remember to notify the listeners
      notifyListeners();


  }//fetchStepData


  //Method to clear the "memory"
  void clearData() {
    stepData.clear();
    heartRateData.clear();
    restingHeartRateData.clear();

  }//clearData
  
List stars = [] ;

  //Method to use to add a star.
void addStar(int toAdd) {
stars.add(toAdd);
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  }//addStar
void update(){
  //This method can be used to update the data provider
  //for example after a change in the database.
  notifyListeners();
}

  //Method to use to delete a star
  void deleteStar(int index){
    stars.remove(index);
    //Call the notifyListeners() method to alert that someth
    //ing happened.
    notifyListeners();
  }//deleteStar
  

}



