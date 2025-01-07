import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/services/user/logout.dart'; // Servizio logout
import 'package:gamerverse/services/user/Get_user_info.dart'; // Servizio per ottenere dati utente
import 'package:gamerverse/services/user/update_user_service.dart'; // Servizio per aggiornare dati utente
import 'package:gamerverse/services/user/delete_user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // Importa la libreria per la selezione delle immagini
import 'dart:io'; // Per gestire i file immagine

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  Map<String, dynamic>? userData; // Contiene i dati utente
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  File? _profileImage; // Variabile per l'immagine del profilo

  @override
  void initState() {
    super.initState();
    fetchUserData();

    // Aggiungi listener per abilitare/disabilitare i pulsanti in tempo reale
    nameController.addListener(() => setState(() {}));
    usernameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    oldPasswordController.addListener(() => setState(() {}));
    newPasswordController.addListener(() => setState(() {}));
    repeatPasswordController.addListener(() => setState(() {}));
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await UserProfileService.getUserByUid();

    if (response['success']) {
      setState(() {
        userData = response['data'];
        isLoading = false;

        // Popola i controller con i dati dell'utente
        nameController.text = userData?['name'] ?? '';
        usernameController.text = userData?['username'] ?? '';
        emailController.text = userData?['email'] ?? '';
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Error fetching data')),
      );
    }
  }

  // Funzione per cambiare l'immagine del profilo
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _profileImage = _selectedImage;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _profileImage = _selectedImage;
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your Account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteUserAccount();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUserAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('user_uid');

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found.')),
      );
      return;
    }

    final response = await DeleteUserService.deleteUser(uid);

    if (response.containsKey('message')) {
      // If there's a "message" key, account was deleted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully.')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else if (response.containsKey('error')) {
      // If there's an "error" key, handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response['error']}')),
      );
    } else {
      // Handle unexpected response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected response from server.')),
      );
    }
  }

//Function for the updating of the account
  Future<void> updateUserData() async {
    if (oldPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Old password is required')),
      );
      return;
    }

    if (newPasswordController.text.isNotEmpty &&
        newPasswordController.text != repeatPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    String? uploadedImageUrl;

    // Verifica se è stata selezionata una nuova immagine
    if (_profileImage != null) {
      // Se sì, carica l'immagine
      uploadedImageUrl = await UpdateUserService.uploadImage(_profileImage!);

      if (uploadedImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image.')),
        );
        return;
      }
    }

    // Aggiorna i dati utente
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('user_uid');

    // Crea i dati da inviare
    final dataToUpdate = {
      'name': nameController.text,
      'username': usernameController.text,
      'email': emailController.text,
      'password': oldPasswordController.text,
      'new_password': newPasswordController.text,
      'uid': uid,
      // Aggiungi profile_picture solo se è stato selezionato un nuovo profilo
      if (uploadedImageUrl != null) 'profile_picture': uploadedImageUrl,
    };

    // Esegui la richiesta per aggiornare i dati
    final response = await UpdateUserService.updateUser(dataToUpdate);

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      fetchUserData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(response['message'] ?? 'Failed to update profile')),
      );
    }
  }

  bool _hasChanges() {
    return (nameController.text != (userData?['name'] ?? '') ||
        usernameController.text != (userData?['username'] ?? '') ||
        emailController.text != (userData?['email'] ?? '') ||
        oldPasswordController.text.isNotEmpty ||
        newPasswordController.text.isNotEmpty ||
        repeatPasswordController.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: Text(
          userData?['username'] ?? 'Account Settings',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.darkGreen,
      ),
      body: (isLoading)
          ? Center(child: CircularProgressIndicator(color: Colors.teal))
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 25,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Immagine del profilo
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showImageSourceOptions();
                                    },
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey[800],
                                      backgroundImage: _profileImage != null
                                          ? FileImage(_profileImage!)
                                          : (userData?['profile_picture'] !=
                                                      null &&
                                                  userData!['profile_picture']
                                                      .isNotEmpty
                                              ? NetworkImage(
                                                  userData!['profile_picture'])
                                              : null),
                                      child: _profileImage == null &&
                                              userData?['profile_picture'] ==
                                                  null
                                          ? const Icon(Icons.person,
                                              size: 40, color: Colors.white70)
                                          : null,
                                    ),
                                  ),
                                  const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.blue,
                                      child: Icon(Icons.edit,
                                          size: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        textSelectionTheme:
                                            const TextSelectionThemeData(
                                                selectionHandleColor:
                                                    AppColors.mediumGreen,
                                                cursorColor:
                                                    AppColors.mediumGreen,
                                                selectionColor:
                                                    AppColors.mediumGreen),
                                      ),
                                      child: TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Name',
                                          labelStyle:
                                              TextStyle(color: Colors.white70),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.mediumGreen),
                                          ),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        textSelectionTheme:
                                            const TextSelectionThemeData(
                                                selectionHandleColor:
                                                    AppColors.mediumGreen,
                                                cursorColor:
                                                    AppColors.mediumGreen,
                                                selectionColor:
                                                    AppColors.mediumGreen),
                                      ),
                                      child: TextField(
                                        controller: usernameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Username',
                                          labelStyle:
                                              TextStyle(color: Colors.white70),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.mediumGreen),
                                          ),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Modify Account',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 10),

                          // Email
                          Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: const TextSelectionThemeData(
                                  selectionHandleColor: AppColors.mediumGreen,
                                  cursorColor: AppColors.mediumGreen,
                                  selectionColor: AppColors.mediumGreen),
                            ),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white70),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.mediumGreen),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Password Fields
                          Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: const TextSelectionThemeData(
                                  selectionHandleColor: AppColors.mediumGreen,
                                  cursorColor: AppColors.mediumGreen,
                                  selectionColor: AppColors.mediumGreen),
                            ),
                            child: TextField(
                              controller: oldPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Old Password',
                                labelStyle: TextStyle(color: Colors.white70),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.mediumGreen),
                                ),
                              ),
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: const TextSelectionThemeData(
                                  selectionHandleColor: AppColors.mediumGreen,
                                  cursorColor: AppColors.mediumGreen,
                                  selectionColor: AppColors.mediumGreen),
                            ),
                            child: TextField(
                              controller: newPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'New Password',
                                labelStyle: TextStyle(color: Colors.white70),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.mediumGreen),
                                ),
                              ),
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: const TextSelectionThemeData(
                                  selectionHandleColor: AppColors.mediumGreen,
                                  cursorColor: AppColors.mediumGreen,
                                  selectionColor: AppColors.mediumGreen),
                            ),
                            child: TextField(
                              controller: repeatPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Repeat Password',
                                labelStyle: TextStyle(color: Colors.white70),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.mediumGreen),
                                ),
                              ),
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Pulsanti Conferma/Annulla
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close,
                                    size: 40, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    // Questo forzerà un refresh del widget senza fare nulla di più
                                    fetchUserData();
                                  });
                                },
                              ),
                              const SizedBox(width: 40),
                              IconButton(
                                icon: const Icon(Icons.check,
                                    size: 40, color: Colors.green),
                                onPressed: _hasChanges()
                                    ? updateUserData
                                    : null, // Disabilita se non ci sono modifiche
                              ),
                            ],
                          ),
                          const Spacer(),

                          // Pulsante Logout
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                final result =
                                    await LogoutService.logout(context);
                                if (result['success']) {
                                  // Optionally, show a success message if the logout is successful
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result['message'])),
                                  );
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                } else {
                                  // Show an error message if logout fails
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result['message'])),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 105, vertical: 15),
                                backgroundColor: const Color(0xff3e6259),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Logout',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Pulsante Elimina Account
                          Center(
                            child: ElevatedButton(
                              onPressed: () => _showDeleteConfirmation(),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 15),
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Delete Account',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar:
          const CustomBottomNavBar(currentIndex: 2), // Navbar personalizzata
    );
  }
}
