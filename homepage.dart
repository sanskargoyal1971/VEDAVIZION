import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'API_Service.dart';

class PlantIdentificationPage extends StatefulWidget {
  @override
  _PlantIdentificationPageState createState() =>
      _PlantIdentificationPageState();
}

class _PlantIdentificationPageState extends State<PlantIdentificationPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _name;
  String? _description;
  String? _remedies;
  bool _isLoading = false; // Track loading state

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _submitImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true; // Show loading spinner
    });

    try {
      final response = await ApiService.submitImage(_image!);
      setState(() {
        _name = response['name'];
        _description = response['description'];
        _remedies = response['remedies'];
      });
    } catch (error) {
      // Handle error here, for example, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch plant information")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1E), // Dark background
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Text(
                    'VedaVision',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB8E986), // Pastel green
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFF4D4D4D), width: 2),
                      color: Color(0xFF2C2C2E),
                    ),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.nature_people,
                                size: 100,
                                color: Color(0xFFB8E986), // Pastel green
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Give us a plant',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFB8E986),
                                ),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: Icon(Icons.photo_library, color: Colors.black),
                        label: Text(
                          'Gallery',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB8E986), // Pastel green
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _takePhoto,
                        icon: Icon(Icons.camera_alt, color: Colors.black),
                        label: Text(
                          'Camera',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB8E986), // Pastel green
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitImage,
                    child: Text(
                      'Identify Plant',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB8E986), // Pastel green
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_name != null &&
                      _description != null &&
                      _remedies != null)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plant Name: $_name',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB8E986), // Pastel green
                            ),
                          ),
                          SizedBox(height: 10),
                          ExpansionTile(
                            title: Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFB8E986),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  _description ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFB8E986),
                                  ),
                                ),
                              ),
                            ],
                            backgroundColor: Color(0xFF1C1C1E),
                          ),
                          ExpansionTile(
                            title: Text(
                              'Remedies',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFB8E986),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  _remedies ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFB8E986),
                                  ),
                                ),
                              ),
                            ],
                            backgroundColor: Color(0xFF1C1C1E),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54, // Semi-transparent background
              child: Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Color(0xFFB8E986), // Pastel green
                  size: 80.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
