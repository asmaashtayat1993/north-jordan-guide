import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/constants.dart';
import '../widgets/place_card.dart';
import '../models/place.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

// ==========================================
// 1. الكلاس الرئيسي لشاشة الهوم (HomeScreen)
// ==========================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // متغير لتتبع الصفحة الحالية التي يقف عليها المستخدم
  // وظيفتها: تحديد الأيقونة النشطة بالشريط السفلي وعرض محتواها
  int _currentIndex = 0;
  String searchQuery = ''; //

  @override
  Widget build(BuildContext context) {
    // قائمة تجمع صفحات التطبيق الفرعية بناءً على رغبة الفريق والتحليل
    // وظيفتها: تبديل المحتوى المعروض بمنتصف الشاشة ديناميكياً
    final List<Widget> screens = [
      const HomeContentView(),
      const Center(child: Text('شاشة استكشف (قريباً)')),
      const Center(child: Text('شاشة المسارات (قريباً)')),
      const Center(child: Text('شاشة المفضلة (قريباً)')),
      const Center(child: Text('شاشة حسابي (قريباً)')),
    ];

    // الهيكل الأساسي الذي يبني معمارية الصفحة
    return Scaffold(
      // تحديد لون خلفية التطبيق من خلال الـ Extension النظيف للألوان
      backgroundColor: context.color.surface,

      // عرض الصفحة الحالية من المصفوفة بناءً على قيمة الـ Index
      body: screens[_currentIndex],

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ==========================================
          // انتقال وهمي (Dummy Navigation) لصفحة الخريطة
          // ==========================================
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('الخريطة'),
                  backgroundColor: context.color.surface,
                  foregroundColor: context.color.primary,
                  elevation: 0,
                ),
                body: const Center(
                  child: Text(
                    'شاشة الخريطة (قريباً) 🗺️',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        },
        backgroundColor: context.color.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.location_on, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // شريط التنقل السفلي للتطبيق (Bottom Navigation Bar)
      // وظيفتها: توفير وصول سريع وبصري لأقسام التطبيق الخمسة الأساسية
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // دالة تعمل فور نقر المستخدم على أي أيقونة بالأسفل لتحديث الصفحة
        onTap: (index) {
          setState(() {
            _currentIndex =
                index; // تغيير قيمة الصفحة النشطة وإعادة بناء الواجهة
          });
        },
        // نمط ثابت للشريط لمنع تشوه الأيقونات وحفظ المساحات بشكل موحد
        type: BottomNavigationBarType.fixed,
        selectedItemColor: context.color.primary,
        unselectedItemColor: context.color.outline,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'استكشف',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'المسارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. كود محتوى الصفحة الرئيسية (HomeContentView)
// ==========================================
class HomeContentView extends StatefulWidget {
  const HomeContentView({Key? key}) : super(key: key);

  @override
  State<HomeContentView> createState() => _HomeContentViewState();
}

class _HomeContentViewState extends State<HomeContentView> {
  String searchQuery = '';
  String selectedCategory = 'الكل';
  Position? _currentPosition;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // تشغيل الدالة فور فتح الشاشة
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // فحص إذا الـ GPS شغال بالتلفون
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    // فحص الصلاحيات وطلبها
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoadingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    // جلب الموقع الحالي وتحديث الشاشة
    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // أداة لمنع خروج محتوى الصفحة تحت شريط النوتش أو أطراف الهاتف الذكي
      child: SingleChildScrollView(
        // أداة تسمح بالتمرير العمودي لأسفل الشاشة بسلاسة دون حدوث أخطاء تجاوز المساحة (Overflow)
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- [1] قسم الترحيب المخصص  ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // استخدام FutureBuilder لجلب بيانات المستخدم المطابقة لكود
                  FutureBuilder<UserModel?>(
                    // هنا نجلب الـ uid للمستخدم الحالي من الفايربيز، ونمرره لدالة getUserData
                    future: FirebaseAuth.instance.currentUser != null
                        ? UserService().getUserData(
                            FirebaseAuth.instance.currentUser!.uid,
                          )
                        : Future.value(null),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: CircularProgressIndicator(),
                        );
                      }

                      final user = snapshot.data;
                      final userName = user?.displayName ?? 'زائر';
                      final userImage =
                          user?.profileImageUrl ??
                          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';

                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(userImage),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مرحباً،',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  // أيقونة الإشعارات (تبقى ثابتة كما هي)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.color.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.color.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: context.color.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- [2] حقل البحث الذكي مع زر التصفية البنفسجي الفاخر ---
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: TextField(
                        // هاي الدالة اللي بتتنفذ مع كل حرف بتكتبيه
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'ابحث عن وجهتك التالية...',
                          hintStyle: TextStyle(
                            color: context.color.outline,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: context.color.outline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              const SizedBox(height: 24),

              // --- [3] البانر الرئيسي (دايناميك) ---
              StreamBuilder<List<PlaceModel>>(
                stream: PlaceService().getPlaces(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 190,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox(height: 190);
                  }

                  final places = snapshot.data!;

                  // تطبيق الـ Business Logic لاختيار أعلى تقييم
                  final topRatedPlace = places.reduce(
                    (current, next) =>
                        current.ratingAvg > next.ratingAvg ? current : next,
                  );

                  // استدعاء الكلاس المستقل وتمرير البيانات له (OOP / SRP)
                  return TopPlaceBannerWidget(place: topRatedPlace);
                },
              ),
              const SizedBox(height: 24),

              // --- [4] قسم التصنيفات والـ Chips الأفقية ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'التصنيفات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.color.primary,
                    ),
                  ),
                  Text(
                    'عرض الكل',
                    style: TextStyle(
                      color: context.color.outline,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // استخراج التصنيفات وبناء الأزرار دايناميكياً
              StreamBuilder<List<PlaceModel>>(
                stream: PlaceService().getPlaces(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox(height: 45);
                  }

                  final places = snapshot.data!;
                  final categories = [
                    'الكل',
                    ...places.map((p) => p.category).toSet(),
                  ];

                  return SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category == selectedCategory;

                        IconData getCategoryIcon(String catName) {
                          if (catName == 'الكل') return Icons.grid_view;
                          if (catName.contains('طبيع')) return Icons.park;
                          if (catName.contains('تاريخ') ||
                              catName.contains('معالم'))
                            return Icons.account_balance;
                          if (catName.contains('مطعم') ||
                              catName.contains('كافيه'))
                            return Icons.restaurant;
                          return Icons.place;
                        }

                        return _buildCategoryChip(
                          context,
                          category,
                          getCategoryIcon(category),
                          isSelected,
                          () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // --- [5] قسم وجهات مختارة (عرض كروت الأماكن الكبيرة) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'وجهات مختارة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.color.primary,
                    ),
                  ),
                  Text(
                    'المزيد',
                    style: TextStyle(
                      color: context.color.outline,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // استخدام FutureBuilder لجلب البيانات
              StreamBuilder<List<PlaceModel>>(
                stream: PlaceService().getPlaces(),
                builder: (context, snapshot) {
                  // حالة التحميل
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // حالة الخطأ
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  // حالة عدم وجود بيانات
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('لا توجد أماكن مضافة حالياً'),
                    );
                  }

                  // البيانات وصلت بنجاح من قاعدة البيانات
                  final allPlaces = snapshot.data!;

                  // الفلترة الدايناميكية المزدوجة (بحث نصي + زر التصنيف)
                  final places = allPlaces.where((place) {
                    // 1. هل المكان بيطابق كلمة البحث؟
                    final matchesSearch = place.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    );

                    // 2. هل المكان بيطابق التصنيف المختار؟ (إذا كان "الكل" بنمشيها للجميع)
                    final matchesCategory =
                        selectedCategory == 'الكل' ||
                        place.category == selectedCategory;

                    // المكان لازم ينجح بالشرطين عشان ينعرض
                    return matchesSearch && matchesCategory;
                  }).toList();

                  // إذا ما لقينا أي مكان بيطابق البحث أو التصنيف
                  if (places.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'لا توجد وجهات تطابق هذا التصنيف أو البحث 🗺️',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }

                  // عرض البيانات باستخدام ListView
                  return ListView.builder(
                    shrinkWrap: true, // ضرورية لمنع أخطاء الـ Scroll
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: places.length > 3
                        ? 3
                        : places.length, // عرض 3 أماكن فقط في الهوم
                    itemBuilder: (context, index) {
                      final place = places[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: PlaceCard(
                          title: place.name,
                          location: place.category,
                          rating: place.ratingAvg,
                          // نتأكد أن مصفوفة الصور ليست فارغة لتجنب الـ Error
                          imageUrl: place.images.isNotEmpty
                              ? place.images[0]
                              : 'https://via.placeholder.com/600', // صورة افتراضية لو مافي صورة بالسيرفر
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 12),
              // --- [5] عنوان قسم بالقرب منك ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'بالقرب منك',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'المزيد',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- قسم عرض الكروت (مع حساب المسافة والفلترة) ---
              _isLoadingLocation
                  ? const Center(
                      child: CircularProgressIndicator(),
                    ) // لفة التحميل لبين ما يلقط الـ GPS
                  : _currentPosition == null
                  ? const Center(
                      child: Text(
                        'يرجى تفعيل الموقع لعرض الأماكن القريبة',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : StreamBuilder<List<PlaceModel>>(
                      stream: PlaceService().getPlaces(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const SizedBox();
                        }

                        final allPlaces = snapshot.data!;

                        // 1. الفلترة الدايناميكية المزدوجة (بحث نصي + زر التصنيف)
                        final filteredPlaces = allPlaces.where((place) {
                          final matchesSearch = place.name
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase());
                          final matchesCategory =
                              selectedCategory == 'الكل' ||
                              place.category == selectedCategory;
                          return matchesSearch && matchesCategory;
                        }).toList();

                        // 2. خوارزمية حساب المسافة والترتيب
                        List<Map<String, dynamic>> placesWithDistance = [];

                        for (var place in filteredPlaces) {
                          double distanceInKm = 0.0;
                          if (place.location != null) {
                            // حساب المسافة بالمتر بين التلفون والمكان
                            double distanceInMeters =
                                Geolocator.distanceBetween(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                  place.location!.latitude,
                                  place.location!.longitude,
                                );
                            // تحويلها لكيلومتر
                            distanceInKm = distanceInMeters / 1000;
                          }

                          placesWithDistance.add({
                            'place': place,
                            'distance': distanceInKm,
                          });
                        }

                        // ترتيب الأماكن من الأقرب للأبعد بناءً على المسافة
                        placesWithDistance.sort(
                          (a, b) => a['distance'].compareTo(b['distance']),
                        );

                        // إذا ما لقينا نتيجة بعد الفلترة، بنرجع مساحة فاضية
                        if (placesWithDistance.isEmpty) {
                          return const SizedBox();
                        }

                        // 3. عرض الكروت بعد الفلترة والترتيب
                        return SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: placesWithDistance.length,
                            itemBuilder: (context, index) {
                              final placeData = placesWithDistance[index];
                              final PlaceModel place = placeData['place'];
                              final double distance = placeData['distance'];
                              final distanceText = place.location != null
                                  ? '${distance.toStringAsFixed(1)} كم'
                                  : 'مسافة غير معروفة';

                              return _buildNearYouCard(
                                context,
                                place.name,
                                '${place.category} • $distanceText', // دمج التصنيف مع المسافة الفعلية
                                place.ratingAvg.toString(),
                                place.images.isNotEmpty
                                    ? place.images[0]
                                    : 'https://via.placeholder.com/150', // تفادي خطأ لو مافي صور
                              );
                            },
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // دالة بناء الـ Chips الخاصة بالتصنيفات (معدلة لتصبح تفاعلية)
  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? context.color.secondaryContainer : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? context.color.secondaryContainer
                : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? context.color.onSecondaryContainer
                  : context.color.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? context.color.onSecondaryContainer
                    : context.color.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة بناء كروت "بالقرب منك" الصغيرة ذات التمرير الأفقي
  Widget _buildNearYouCard(
    BuildContext context,
    String title,
    String location,
    String rating,
    String imageUrl,
  ) {
    return Container(
      width: 220, // تحديد عرض الكرت ضروري لمنع التمدد
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          // --- 1. قسم الصورة  ---
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 90,
              fit: BoxFit.cover,
              // هذا السطر السحري بيمنع الإيرور الأحمر لو الصورة خربانة
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 90,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 8),

          // --- 2. قسم النصوص (مع حماية الـ Overflow) ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow
                        .ellipsis, // وضع 3 نقاط (...) إذا كان النص طويلاً
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
// ==========================================
// الكلاسات المستقلة (تطبيق مبدأ SRP)
// ==========================================

class TopPlaceBannerWidget extends StatelessWidget {
  final PlaceModel place;

  const TopPlaceBannerWidget({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imageUrl = place.images.isNotEmpty ? place.images[0] : '';

    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. الصورة مع حماية الروابط الخربانة
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
                  size: 60,
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment
                      .topCenter, // غيرناها لـ topCenter عشان يغطي مساحة أكبر
                ),
              ),
            ),

            // 3. النصوص والزر في Row واحد لترتيب مثالي ومنع التداخل
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // قسم النصوص (Expanded تضمن عدم تجاوز النص للمساحة المتبقية)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:
                          MainAxisSize.min, // عشان العمود ياخذ مساحة نصوصه فقط
                      children: [
                        Text(
                          'أعلى تقييم ⭐ ${place.ratingAvg}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          place.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          place.category,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),
                  // زر الاستكشاف
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'استكشف\nالآن',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
