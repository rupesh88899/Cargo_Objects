import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/api_controller.dart';
import 'detail_screen.dart';
import 'create_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ApiController apiController = Get.find<ApiController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objects'),
        actions: [
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundImage: authController.user?.photoURL != null
                  ? NetworkImage(authController.user!.photoURL!)
                  : null,
              child: authController.user?.photoURL == null
                  ? Icon(Icons.person)
                  : null,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(authController.user?.displayName ?? 'User'),
                  subtitle: Text(authController.user?.email ?? ''),
                ),
              ),
              PopupMenuItem(
                onTap: () => authController.signOut(),
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (apiController.isLoading.value && apiController.objects.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (apiController.objects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No objects found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => apiController.fetchObjects(isRefresh: true),
                  child: Text('Refresh'),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => apiController.fetchObjects(isRefresh: true),
          child: ListView.builder(
            itemCount: apiController.objects.length,
            itemBuilder: (context, index) {
              final object = apiController.objects[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      object.name.isNotEmpty ? object.name[0].toUpperCase() : 'O',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    object.name,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${object.id ?? 'Unknown'}'),
                      Text(
                        object.dataString,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.to(() => DetailScreen(object: object)),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => CreateEditScreen()),
        child: Icon(Icons.add),
      ),
    );
  }
}