import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../widgets/notification_card.dart';
import '../utils/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // قائمة الإشعارات السياحية الـ 9
  final List<NotificationModel> dummyNotifications = [
    NotificationModel(
      id: '1',
      title: 'مهرجان الرمان في إربد',
      description: 'انضم إلينا هذا الأسبوع في مهرجان الرمان السنوي لتجربة المنتجات المحلية وتراث الشمال.',
      type: 'event',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      actionText: 'عرض التفاصيل',
    ),
    NotificationModel(
      id: '2',
      title: 'خصم على تذاكر تلفريك عجلون',
      description: 'احصل على خصم 15% على تذاكر التلفريك عند الحجز المسبق عبر التطبيق اليوم.',
      type: 'offer',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      actionText: 'احجز الآن',
    ),
    NotificationModel(
      id: '3',
      title: 'اكتشف مسار وادي الريان',
      description: 'تم توثيق مسار جديد يمر عبر بساتين وادي الريان، مثالي لمحبي المشي والمغامرات الطبيعية.',
      type: 'recommendation',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    NotificationModel(
      id: '4',
      title: 'حالة الطقس في أم قيس',
      description: 'الأجواء ربيعية وصافية بامتياز اليوم في أم قيس، وقت مثالي لالتقاط الصور التذكارية لإطلالة طبريا.',
      type: 'weather',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    NotificationModel(
      id: '5',
      title: 'أمسية ثقافية في بيت عرار',
      description: 'لا تفوت حضور الأمسية الشعرية والتراثية في بيت الشاعر مصطفى وهبي التل مساء الغد.',
      type: 'event',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      isRead: false,
    ),
    NotificationModel(
      id: '6',
      title: 'أضف تقييمك لمعالم جرش',
      description: 'هل زرت مدينة جرش الأثرية مؤخراً؟ شارك تجربتك وساعد السياح الآخرين في تخطيط رحلتهم.',
      type: 'recommendation',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      actionText: 'إضافة تقييم',
    ),
    NotificationModel(
      id: '7',
      title: 'عروض الإقامة في أكواخ سد زقلاب',
      description: 'استفد من العروض الخاصة على حجوزات الأكواخ الخشبية في سد زقلاب   .',
      type: 'offer',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
      actionText: 'عرض الأكواخ',
    ),
    NotificationModel(
      id: '8',
      title: 'دليلك لأفضل المطاعم التراثية',
      description: 'بناءً على تفضيلاتك، جمعنا لك قائمة بأشهر المطاعم التي تقدم المأكولات المحلية والمكمورة في الشمال.',
      type: 'recommendation',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: false,
      actionText: 'عرض القائمة',
    ),
    NotificationModel(
      id: '9',
      title: 'تنبيه جوي لزوار المرتفعات',
      description: 'يتوقع تشكل الضباب الكثيف في ساعات الصباح الباكر على طريق إربد-عجلون، يرجى القيادة بحذر.',
      type: 'weather',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      isRead: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // دالة لحساب عدد الإشعارات غير المقروءة ديناميكياً لكل تصنيف
  int _getUnreadCount(String category) {
    if (category == 'all') {
      return dummyNotifications.where((n) => !n.isRead).length;
    } else if (category == 'offer') {
      return dummyNotifications.where((n) => n.type == 'offer' && !n.isRead).length;
    } else if (category == 'event') {
      return dummyNotifications.where((n) => n.type == 'event' && !n.isRead).length;
    } else if (category == 'recommendation') {
      return dummyNotifications.where((n) => (n.type == 'recommendation' || n.type == 'weather') && !n.isRead).length;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'التنبيهات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: context.color.primary,
            ),
          ),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  int currentTab = _tabController.index;

                  for (var notification in dummyNotifications) {
                    if (currentTab == 0) {
                      notification.isRead = true;
                    } else if (currentTab == 1 && notification.type == 'offer') {
                      notification.isRead = true;
                    } else if (currentTab == 2 && notification.type == 'event') {
                      notification.isRead = true;
                    } else if (currentTab == 3 && 
                              (notification.type == 'recommendation' || notification.type == 'weather')) {
                      notification.isRead = true;
                    }
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'تم تحديث حالة التنبيهات بنجاح',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: context.color.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: context.color.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text('تحديد كمقروء'),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: context.color.primaryContainer,
              child: Text(
                'أ',
                style: TextStyle(
                  color: context.color.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: context.color.primary,
            unselectedLabelColor: context.color.outline,
            indicatorColor: context.color.primary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              _buildTabWithBadge('الكل', _getUnreadCount('all')),
              _buildTabWithBadge('عروض', _getUnreadCount('offer')),
              _buildTabWithBadge('فعاليات', _getUnreadCount('event')),
              _buildTabWithBadge('توصيات', _getUnreadCount('recommendation')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNotificationList(dummyNotifications),
            _buildNotificationList(dummyNotifications.where((n) => n.type == 'offer').toList()),
            _buildNotificationList(dummyNotifications.where((n) => n.type == 'event').toList()),
            _buildNotificationList(dummyNotifications.where((n) => n.type == 'recommendation' || n.type == 'weather').toList()),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لتصميم التبويب مع عداد إشعارات ديناميكي بجانبه
  Tab _buildTabWithBadge(String title, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: context.color.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Text(
          'لا توجد إشعارات حالياً',
          style: TextStyle(color: context.color.onSurfaceVariant),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationCard(
          notification: notifications[index],
          onTap: () {
            // بمجرد الضغط على الإشعار، تتحول حالته إلى مقروء وينقص العداد تلقائياً
            setState(() {
              notifications[index].isRead = true;
            });
          },
          onActionTap: () {},
        );
      },
    );
  }
}