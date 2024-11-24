import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const PredictionApp());
}

class PredictionApp extends StatelessWidget {
  const PredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ML Prediction App',
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for numeric inputs
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();


  bool isMale = true;
  bool isSmoker = false;

  String _result = '';
  bool _isLoading = false;

  Future<void> _predict() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _result = '';
      });

      Map<String, dynamic> data = {
        "age": double.tryParse(_ageController.text) ?? 0,
        "sex": isMale,
        "bmi": double.tryParse(_bmiController.text) ?? 0,
        "children": int.tryParse(_childrenController.text) ?? 0,
        "smoker": isSmoker,
      };

      //API URL
      const String apiUrl = "https://linear-regression-model-qaq0.onrender.com/predict";


      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          final prediction = json.decode(response.body)['predicted_charges'];
          setState(() {
            _result = "Predicted Charges: \$${prediction.toStringAsFixed(2)}";
          });
        } else {
          setState(() {
            _result = "Error: ${response.body}";
          });
        }
      } catch (e) {
        setState(() {
          _result = "Error: Unable to connect to the API.";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MedInsure Cost Predictor',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color(0xFF64D2ED),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Image.asset(
                'images/medical_insurance.jpeg',
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter Details Below:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Age Input
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // BMI Input
                    TextFormField(
                      controller: _bmiController,
                      decoration: const InputDecoration(labelText: 'BMI'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your BMI';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid BMI';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Children Input
                    TextFormField(
                      controller: _childrenController,
                      decoration:
                          const InputDecoration(labelText: 'Number of Children'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of children';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Gender Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sex:'),
                        DropdownButton<bool>(
                          value: isMale,
                          items: const [
                            DropdownMenuItem(value: true, child: Text('Male')),
                            DropdownMenuItem(value: false, child: Text('Female')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              isMale = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Smoker Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Smoker:'),
                        Switch(
                          value: isSmoker,
                          onChanged: (value) {
                            setState(() {
                              isSmoker = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Predict Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _predict,
                      child: Text(_isLoading ? 'Predicting...' : 'Predict'),
                    ),
                    const SizedBox(height: 20),

                    // Result Display
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
