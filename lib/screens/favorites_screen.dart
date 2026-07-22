import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place_model.dart';
import '../widgets/place_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // معرف وهمي مؤقت يمثل المستخدم الحالي (يُستبدل لاحقاً بمعرف المستخدم الفعلي)
  final String currentUserId = 'test_user_123';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context),
              _buildTabBar(context),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPlacesList(),
                    const Center(child: Text('لا توجد مطاعم محفوظة حالياً')),
                    const Center(child: Text('لا توجد مسارات محفوظة حالياً')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مفضلاتك',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'جميع الأماكن والمسارات التي نالت إعجابك في مكان واحد.',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.outline,
        indicatorColor: Theme.of(context).colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: const [
          Tab(text: 'المعالم\nالمحفوظة'),
          Tab(text: 'المطاعم\nالمحفوظة'),
          Tab(text: 'المسارات\nالمحفوظة'),
        ],
      ),
    );
  }

  // هذه الدالة هي قلب الشاشة، وتقوم بالاتصال المباشر مع قاعدة البيانات
  Widget _buildPlacesList() {
    return StreamBuilder<QuerySnapshot>(
      // 1. تحديد مسار البيانات في السيرفر
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('favorites')
          .snapshots(),
          
      builder: (context, snapshot) {
        // حالة الانتظار وجلب البيانات
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // حالة عدم وجود بيانات
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'لم تقم بإضافة أي معالم للمفضلة بعد',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }

        // 2. تحويل بيانات السيرفر إلى قائمة من نوع Place باستخدام ملف الليدر كما هو
        final places = snapshot.data!.docs.map((doc) {
          return Place.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        // 3. بناء القائمة وعرضها
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: places.length,
          itemBuilder: (context, index) {
            final place = places[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: PlaceCard(
                title: place.name,
                location: place.tags.isNotEmpty ? place.tags[0] : 'موقع غير محدد',
                rating: place.ratingAvg,
                imageUrl: place.images.isNotEmpty ? place.images[0] : '',
                isFavorite: true,
                onFavoriteTap: () async {
                  // حذف العنصر مباشرة من قاعدة البيانات عند الضغط على زر الحذف
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserId)
                      .collection('favorites')
                      .doc(place.id)
                      .delete();
                      
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إزالة ${place.name} من المفضلة'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onCardTap: () {
                  // الانتقال إلى شاشة التفاصيل
                },
              ),
            );
          },
        );
      },
    );
  }
}