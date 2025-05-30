import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:denicotox/screens/homepage.dart';

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
        title: Text('Modulo di Registrazione'),
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
                decoration: InputDecoration(labelText: 'Come ti chiami?'),
                onSaved: (value) => _name = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obbligatorio' : null,
              ),
              SizedBox(height: 16),

              // Sesso (maschio/femmina)
              Text('Sesso:'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Maschio'),
                      value: 'Maschio',
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Femmina'),
                      value: 'Femmina',
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Quanti anni hai?
              TextFormField(
                decoration: InputDecoration(labelText: 'Quanti anni hai?'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _age = int.tryParse(value ?? ''),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obbligatorio' : null,
              ),
              SizedBox(height: 16),

              // Quante sigarette fumi al giorno?
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Quante sigarette fumi al giorno?'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _cigarettesPerDay = int.tryParse(value ?? ''),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obbligatorio' : null,
              ),
              SizedBox(height: 16),

              // Che tipo di sigarette fumi?
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Che tipo di sigarette fumi?'),
                onSaved: (value) => _cigaretteType = value,
              ),
              SizedBox(height: 16),

              // Cosa ti ha spinto a smettere?
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Cosa ti ha spinto a smettere?'),
                onSaved: (value) => _motivation = value,
              ),
              SizedBox(height: 16),

              // Attività fisica e intensità
              Text('Pratichi attività fisica?'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Si'),
                      value: 'Si',
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
              SizedBox(height: 16),

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
                      SnackBar(content: Text('Modulo inviato con successo!')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homepage(),
                      ),
                    );
                  }
                ,
                child: Text('Invia'),
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