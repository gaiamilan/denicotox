import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Impact{

  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';
  static String stepsEndpoint = 'data/v1/steps/patients/';
  static String hrEndpoint = 'data/v1/heart_rate/patients/';
  static String restingHREndpoint = 'data/v1/resting_heart_rate/patients/';

  //static String username = 'gq9MVRmZK8';
  //static String password = '12345678!';

  static String patientUsername = 'Jpefaq6m58';

  static String impactUsername = 'Jpefaq6m58';


//This method allows to refresh the stored JWT in SharedPreferences
   Future<int> refreshTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    if (refresh != null) {
      final body = {'refresh': refresh};

      //Get the response
      print('Calling: $url');
      final response = await http.post(Uri.parse(url), body: body);

      //If the response is OK, set the tokens in SharedPreferences to the new values
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final sp = await SharedPreferences.getInstance();
        await sp.setString('access', decodedResponse['access']);
        await sp.setString('refresh', decodedResponse['refresh']);
      } //if

      //Just return the status code
      return response.statusCode;
    }
    return 401;
  } //_refreshTokens

   Future<int> getAndStoreTokens(String username, String password ) async {

    //Create the request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': username, 'password': password};

    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If response is OK, decode it and store the tokens. Otherwise do nothing.
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
  } //_getAndStoreTokens

Future<void> clearTokens() async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.remove('access'); //clean all the data that I had stored
  sp.remove('refresh');
}



  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
   Future<dynamic> fetchStepData(DateTime date) async {

    //Get the stored access token (Note that this code does not work if the tokens are null)
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    //If access token is expired, refresh it
    if(JwtDecoder.isExpired(access!)){
      await refreshTokens();
      access = sp.getString('access');
    }//if
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    //Create the (representative) request
    final url = '${Impact.baseUrl}${Impact.stepsEndpoint}${Impact.patientUsername}/day/$formattedDate/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    
    //if OK parse the response, otherwise return null
    var result;
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    } //if

    //Return the result
    return result;

  } //_requestData

 //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
   Future<dynamic> fetcHRData(DateTime date) async {

    //Get the stored access token (Note that this code does not work if the tokens are null)
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    //If access token is expired, refresh it
    if(JwtDecoder.isExpired(access!)){
      await refreshTokens();
      access = sp.getString('access');
    }//if
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    //Create the (representative) request
    final url = '${Impact.baseUrl}${Impact.hrEndpoint}${Impact.patientUsername}/day/$formattedDate/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    
    //if OK parse the response, otherwise return null
    var result;
    
    print(response.statusCode);
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    } //if

    //Return the result
    return result;

  } //_requestData


 //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
   Future<dynamic> fetcRestingHRData(DateTime date) async {

    //Get the stored access token (Note that this code does not work if the tokens are null)
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    //If access token is expired, refresh it
    if(JwtDecoder.isExpired(access!)){
      await refreshTokens();
      access = sp.getString('access');
    }//if
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    //Create the (representative) request
    final url = '${Impact.baseUrl}${Impact.restingHREndpoint}${Impact.patientUsername}/day/$formattedDate/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    
    //if OK parse the response, otherwise return null
    var result;
    print(response.statusCode);
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    } //if

    //Return the result
    return result;

  } //_requestData

}//Impact

  