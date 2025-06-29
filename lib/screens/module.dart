import 'package:denicotox/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:denicotox/screens/homepage.dart';

class Module extends StatefulWidget {
  const Module({super.key});

  static const routename = 'Registration module';

  @override
  State<Module> createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _gender;
  int? _age;
  int? _cigarettesPerDay;
  String? _cigaretteType;
  String? _motivation;
  String? _exerciseIntensity;

  @override
  Widget build(BuildContext context) {
    print('${Module.routename} built');

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration module'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              // Come ti chiami?
              TextFormField(
                decoration: InputDecoration(labelText: 'What is your name?'),
                onSaved: (value) => _name = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required field' : null,
              ),
              SizedBox(height: 16),

              // Sesso (maschio/femmina)
              Text('Gender:'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Male'),
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Female'),
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                  ),
                ],
              ),

              // Quanti anni hai?
              TextFormField(
                decoration: InputDecoration(labelText: 'How old are you?'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _age = int.tryParse(value ?? ''),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required field' : null,
              ),
              SizedBox(height: 16),

              // Quante sigarette fumi al giorno?
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'How many cigarettes do you smoke per day?'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _cigarettesPerDay = int.tryParse(value ?? ''),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required field' : null,
              ),
              SizedBox(height: 16),

              // Che tipo di sigarette fumi?

              
              Text('What type of cigarettes?'),
              Column(
  children: [
    RadioListTile<String>(
      title: Text('Combustion tobacco'),
      value: 'Combustion tobacco',
      groupValue: _cigaretteType,
      onChanged: (value) => setState(() => _cigaretteType = value),
    ),
    RadioListTile<String>(
      title: Text('Heated tobacco'),
      value: 'Heated tobacco',
      groupValue: _cigaretteType,
      onChanged: (value) => setState(() => _cigaretteType = value),
    ),
    RadioListTile<String>(
      title: Text('Electronic cigarette'),
      value: 'Electronic cigarette',
      groupValue: _cigaretteType,
      onChanged: (value) => setState(() => _cigaretteType = value),
    ),
  ],
),


              // Cosa ti ha spinto a smettere?
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'What motivates you to quit smoking?'),
                onSaved: (value) => _motivation = value,
              ),
              SizedBox(height: 16),

              // Attività fisica e intensità
              Text('Do you practice physical activity?'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Yes'),
                      value: 'Yes',
                      groupValue: _exerciseIntensity,
                      onChanged: (value) => setState(() => _exerciseIntensity = value),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('No'),
                      value: 'No',
                      groupValue: _exerciseIntensity,
                      onChanged: (value) => setState(() => _exerciseIntensity = value),
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                      final sp = await SharedPreferences.getInstance();

                    sp.setString('nome', '$_name');
                    sp.setString('sesso', '$_gender');
                    sp.setInt('eta', _age!);
                    sp.setInt('nr_sigarette', _cigarettesPerDay!);
                    sp.setString('tipo', '$_cigaretteType');
                    sp.setString('motivazione', '$_motivation');
                    sp.setString('attività_fisica', '$_exerciseIntensity');

                    await _setRegistrationCompleted();
                  }                         
                    // Puoi mostrare un messaggio di successo o navigare altrove
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Form submitted successfully!')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  }
                ,
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Future<void> _setRegistrationCompleted() async {
  final sp = await SharedPreferences.getInstance();
  await sp.setBool('register_done', true);
  }

}