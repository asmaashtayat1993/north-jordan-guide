import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../widgets/custom_text_field.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel currentUser;
  const EditProfileScreen({Key? key, required this.currentUser})
    : super(key: key);
  @override
  State<EditProfileScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final UserService _userService = UserService();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.currentUser.displayName,
    );
    _phoneController = TextEditingController(
      text: widget.currentUser.phoneNumber,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    setState(() {
      _isLoading = true;
    });
    UserModel updatedUser = UserModel(
      id: widget.currentUser.id,
      displayName: _nameController.text.trim(),
      email: widget.currentUser.email,
      phoneNumber: _phoneController.text.trim(),
      role: widget.currentUser.role,
      tripsCount: widget.currentUser.tripsCount,
    );
    bool success = await _userService.updateUserData(updatedUser);
    setState(() {
      _isLoading = false;
    });
    if (success) {
  
    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      'تم تحديث البيانات بنجاح!',
      style: TextStyle(color: context.color.onSecondary), 
    ),
    backgroundColor: context.color.secondary, 
  ),
);

      
      Navigator.pop(context, updatedUser); 
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء التحديث، يرجى المحاولة لاحقاً.',
            style: TextStyle(color: context.color.onError), 
          ),
        backgroundColor: context.color.error,
       ),
      );
  
    }
  }
File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar
      
      (title: const Text('تعديل الملف الشخصي'),
  
      ),
      body:Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            children: [
              
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: context.color.primary.withOpacity(0.1),
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!) as ImageProvider
                            : (widget.currentUser.profileImageUrl != null ?
                             NetworkImage(widget.currentUser.profileImageUrl!) : null),
                  
                        child: (_selectedImage == null && widget.currentUser.profileImageUrl == null)
                            ? Icon(Icons.person, size: 60, color: context.color.primary)
                            : null,
                      ),
                    ),
                    
                    Positioned(
                      bottom: 0,
                      right: 4, 
                      child: GestureDetector(
                        onTap: _pickImage, 
                        child: CircleAvatar(
                          radius: 18,
                          
                          backgroundColor: context.color.primary,
                          
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
          
              Center(
                child: Text(
                  'تحديث بياناتك الشخصية',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              
              const SizedBox(height: 40), 

          
          
              CustomTextField(
                label: 'الاسم الكامل',
                controller: _nameController,
              
                prefixIcon: Icons.person_outline, 
              ),
              
              const SizedBox(height: 24),
              
              CustomTextField(
                label: 'رقم الهاتف',
                controller: _phoneController,
                prefixIcon: Icons.phone_android,
              ),
              
              const SizedBox(height: 50), 

              
              CustomButton(
                text: 'حفظ التعديلات',
                onPressed: saveChanges,
              ),
            ],
          ),
          
  
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3), 
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      
      );
  }
}
