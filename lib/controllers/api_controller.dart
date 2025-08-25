import 'package:cargoapp/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class ApiController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<DataModel> objects = <DataModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchObjects();
  }

  Future<void> fetchObjects({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        objects.clear();
        currentPage.value = 1;
      }

      isLoading.value = true;
      final result = await _apiService.fetchObjects();
      objects.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch objects: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<DataModel?> fetchObjectById(String id) async {
    try {
      return await _apiService.fetchObjectById(id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch object: ${e.toString()}');
      return null;
    }
  }

  Future<void> createObject(DataModel object) async {
    try {
      isLoading.value = true;
      final result = await _apiService.createObject(object);
      objects.insert(0, result);
      Get.back();
      Get.snackbar('Success', 'Object created successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create object: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateObject(String id, DataModel object) async {
    try {
      isLoading.value = true;

      // Optimistic update
      final index = objects.indexWhere((obj) => obj.id == id);
      if (index != -1) {
        objects[index] = object.copyWith(id: id);
      }

      final result = await _apiService.updateObject(id, object);

      if (index != -1) {
        objects[index] = result;
      }

      Get.back();
      Get.snackbar('Success', 'Object updated successfully!');
    } catch (e) {
      // Revert optimistic update on error
      fetchObjects();
      Get.snackbar('Error', 'Failed to update object: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteObject(String id) async {
    try {
      // Optimistic update
      final originalList = List<DataModel>.from(objects);
      objects.removeWhere((obj) => obj.id == id);

      final success = await _apiService.deleteObject(id);

      if (success) {
        Get.snackbar('Success', 'Object deleted successfully!');
      } else {
        // Revert on failure
        objects.assignAll(originalList);
      }
    } catch (e) {
      // Revert optimistic update on error
      fetchObjects();
      Get.snackbar('Error', 'Failed to delete object: ${e.toString()}');
    }
  }

  void showDeleteDialog(String id, String name) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Object'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              deleteObject(id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
