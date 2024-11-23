import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  PredictionPageState createState() => PredictionPageState();
}

class PredictionPageState extends State<PredictionPage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _smokerController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();

  String _predictionResult = '';

  Future<void> _predict() async {
    final Map<String, dynamic> requestData = {
      'age': int.parse(_ageController.text),
      'sex': int.parse(_sexController.text),
      'bmi': double.parse(_bmiController.text),
      'children': int.parse(_childrenController.text),
      'smoker': int.parse(_smokerController.text),
      'region': int.parse(_regionController.text),
    };

    // Make sure to use the correct URL for your deployed model API
    final response = await http.post(
      Uri.parse('https://fastapi-app-5-x4ai.onrender.com/predict'), // Correct URL for the deployed API
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );

    if (response.statusCode == 200) {
      setState(() {
        // The response body should contain the prediction value, so display it here
        _predictionResult = 'Predicted Charge: ${json.decode(response.body)['prediction']}';
      });
    } else {
      setState(() {
        _predictionResult = 'Error: ${response.body}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _sexController,
              decoration: const InputDecoration(labelText: 'Sex (0 for Male, 1 for Female)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _bmiController,
              decoration: const InputDecoration(labelText: 'BMI'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _childrenController,
              decoration: const InputDecoration(labelText: 'Children'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _smokerController,
              decoration: const InputDecoration(labelText: 'Smoker (0 for No, 1 for Yes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _regionController,
              decoration: const InputDecoration(labelText: 'Region (numeric)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predict,
              child: const Text('Get Prediction'),
            ),
            const SizedBox(height: 20),
            Text(
              _predictionResult,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
