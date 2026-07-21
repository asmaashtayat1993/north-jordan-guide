import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/favorites_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/dummy_login_screen.dart';

class ProfileScreen1 extends StatefulWidget {
  const ProfileScreen1({super.key});

  @override
  State<ProfileScreen1> createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen1> {
  late Future<UserModel?> _userFuture;
  bool _isDarkMode = false;

void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }
  @override
  void initState() {
    super.initState();
    _userFuture = UserService().getUserData('xTJAyyUFukWfYBK4fuGvesgucUf2');
  }

  void _goToEditProfile(UserModel currentUser) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(currentUser: currentUser),
      ),
    );
    if (result != null && result is UserModel) {
      setState(() {});
    }
  }
  Future<void> _logout() async {
    try {
      await UserService().signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const DummyLoginScreen(),
        ),
        (Route<dynamic> route) => false, 
      );
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 60),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data available'));
          }
          UserModel user = snapshot.data!;

          bool isArabic = true;
          String currentUserId =
            AuthService().getCurrentUserId() ?? 'xTJAyyUFukWfYBK4fuGvesgucUf2';
              
          return Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: context.color.surfaceContainerHighest,
                      backgroundImage: user.profileImageUrl != null
                          ? NetworkImage(user.profileImageUrl!)
                          : null,
                      child: user.profileImageUrl == null
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: context.color.primary,
                            )
                          : null
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.displayName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color:context.color.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'مستكشف الطبيعة • ${user.location ?? 'إربد'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.color.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: CustomButton(
                        text: 'تعديل الملف الشخصي',
                        onPressed: () => _goToEditProfile(user),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            
                            child: _StatCardTile(
                              count: user.tripsCount.toString(),
                              title: 'رحلة',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FutureBuilder<String>(
                              future: FavoritesService().getFavoritesCount(currentUserId),
                              builder: (context, snapshot) {
                                String favCount = snapshot.data ?? '0';
                                return _StatCardTile(
                                  count: favCount,
                                  title: 'مفضلة',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: context.color.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          
                          _MenuOptionTile(
                            title: 'رحلاتي',
                            icon: Icons.route_outlined,
                            customColor: Colors.purple,
                            onTap: () {
                              
                            },
                          ),
                          _MenuOptionTile(
                            title: 'الأماكن المحفوظة',
                            icon: Icons.bookmark_border,
                            customColor: Colors.teal,
                            onTap: () {},
                          ),
                          _MenuOptionTile(
                            title: 'اللغة',
                            icon: Icons.language,
                            subtitle: 'العربية',
                            customColor: Colors.purple,
                            onTap: () {},
                          ),
                          _MenuOptionTile(
                            title: 'الإشعارات',
                            icon: Icons.notifications_active_outlined,
                            customColor: Colors.teal,
                            onTap: () {},
                          ),
                          _SwitchOptionTile(
                            title: 'الوضع الليلي',
                            icon: Icons.dark_mode_outlined,
                            isSwitched: _isDarkMode,
                            customColor: Colors.purple,
                            onChanged: _toggleTheme,
                          ),
                          _MenuOptionTile(
                            title: 'مركز المساعدة',
                            icon: Icons.help_outline,
                            customColor: Colors.teal,
                            onTap: () {},
                          ),
                          _MenuOptionTile(
                            title: 'تسجيل الخروج',
                            icon: Icons.logout,
                            isLogout: true,
                            onTap: _logout,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class _StatCardTile extends StatelessWidget {
  final String count;
  final String title;

  const _StatCardTile({
    required this.count,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color:context.color.outlineVariant),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.color.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color:context.color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}


class _MenuOptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLogout;
  final Color? customColor;
  final String? subtitle;
  final VoidCallback? onTap;

  const _MenuOptionTile({
    required this.title,
    required this.icon,
    this.isLogout = false,
    this.customColor,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLogout
        ? context.color.error
        : (customColor ??context.color.primary);

    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isLogout ? color : context.color.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: context.color.onSurfaceVariant,
              ),
            )
          : null,
      trailing: isLogout
          ? null
          : const Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
    );
  }
}


class _SwitchOptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSwitched;
  final ValueChanged<bool> onChanged;
  final Color? customColor;

  const _SwitchOptionTile({
    required this.title,
    required this.icon,
    required this.isSwitched,
    required this.onChanged,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = customColor ??context.color.primary;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: context.color.onSurface,
        ),
      ),
      trailing: Switch(
        value: isSwitched,
        onChanged: onChanged,
        activeThumbColor: context.color.primary,
      ),
    );
  }
}