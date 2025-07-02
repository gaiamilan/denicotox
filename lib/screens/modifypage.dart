import 'package:denicotox/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:denicotox/screens/profilePage.dart';

class ModifyPage extends StatefulWidget {
  const ModifyPage({super.key});

  @override
  State<ModifyPage> createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers per i campi testuali
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cigarettesPerDayController = TextEditingController();
  final TextEditingController _motivationController = TextEditingController();

  // Variabili per i campi a scelta (Radio Buttons)
  String? _gender;
  String? _cigaretteType;
  String? _exerciseIntensity;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = sp.getString('nome') ?? '';
      _gender = sp.getString('sesso');
      _ageController.text = (sp.getInt('eta')?.toString()) ?? '';
      _cigarettesPerDayController.text = (sp.getInt('nr_sigarette')?.toString()) ?? '';
      _cigaretteType = sp.getString('tipo');
      _motivationController.text = sp.getString('motivazione') ?? '';
      _exerciseIntensity = sp.getString('attività_fisica');
    });
  }

  Future<void> _saveProfileData() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('nome', _nameController.text);
    await sp.setString('sesso', _gender ?? '');
    await sp.setInt('eta', int.tryParse(_ageController.text) ?? 0);
    await sp.setInt('nr_sigarette', int.tryParse(_cigarettesPerDayController.text) ?? 0);
    await sp.setString('tipo', _cigaretteType ?? '');
    await sp.setString('motivazione', _motivationController.text);
    await sp.setString('attività_fisica', _exerciseIntensity ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _cigarettesPerDayController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modify Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nome
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),

              // Sesso
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

              // Età
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),

              // Sigarette al giorno
              TextFormField(
                controller: _cigarettesPerDayController,
                decoration: InputDecoration(labelText: 'Cigarettes per day'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),

              // Tipo di sigarette
              Text('Cigarette type:'),
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
              SizedBox(height: 16),

              // Motivazione
              TextFormField(
                controller: _motivationController,
                decoration: InputDecoration(labelText: 'Motivation to quit smoking'),
              ),
              SizedBox(height: 16),

              // Attività fisica
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

              SizedBox(height: 24),

              // Bottone Salva
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await _saveProfileData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated successfully!')),
                    );
                    final userProvider = Provider.of<DataProvider>(context, listen: false);
                    userProvider.setNome(_nameController.text); 
                    Navigator.pop(context, MaterialPageRoute(builder: (context) => ProfilePage()),);
                  }
                },
                child: Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}