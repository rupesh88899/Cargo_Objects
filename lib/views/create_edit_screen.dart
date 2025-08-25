import 'package:cargoapp/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../controllers/api_controller.dart';

class CreateEditScreen extends StatefulWidget {
  final DataModel? object;

  const CreateEditScreen({super.key, this.object});

  @override
  _CreateEditScreenState createState() => _CreateEditScreenState();
}

class _CreateEditScreenState extends State<CreateEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dataController = TextEditingController();
  final ApiController apiController = Get.find<ApiController>();

  bool get isEditing => widget.object != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.object!.name;
      if (widget.object!.data != null) {
        _dataController.text = jsonEncode(widget.object!.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Object' : 'Create Object')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name *',
                    hintText: 'Enter object name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _dataController,
                  decoration: InputDecoration(
                    labelText: 'Data (JSON)',
                    hintText: '{"key": "value"}',
                    helperText: 'Optional: Enter valid JSON data',
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      try {
                        jsonDecode(value);
                      } catch (e) {
                        return 'Please enter valid JSON format';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Obx(
                  () => ElevatedButton(
                    onPressed: apiController.isLoading.value
                        ? null
                        : _submitForm,
                    child: apiController.isLoading.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(isEditing ? 'Updating...' : 'Creating...'),
                            ],
                          )
                        : Text(isEditing ? 'Update Object' : 'Create Object'),
                  ),
                ),
                if (!isEditing) ...[
                  SizedBox(height: 16),
                  Text(
                    'Sample JSON data formats:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '{"color": "red", "capacity": "256GB"}',
                          style: TextStyle(fontFamily: 'monospace'),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '{"year": 2023, "price": 1200.50}',
                          style: TextStyle(fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    Map<String, dynamic>? data;
    if (_dataController.text.trim().isNotEmpty) {
      try {
        data = jsonDecode(_dataController.text) as Map<String, dynamic>;
      } catch (e) {
        Get.snackbar('Error', 'Invalid JSON format');
        return;
      }
    }

    final object = DataModel(name: _nameController.text.trim(), data: data);

    if (isEditing) {
      apiController.updateObject(widget.object!.id!, object);
    } else {
      apiController.createObject(object);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dataController.dispose();
    super.dispose();
  }
}
