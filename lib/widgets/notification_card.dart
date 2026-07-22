import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../utils/constants.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onActionTap,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isActuallyHovered = _isHovered && !widget.notification.isRead;

    final baseColor = widget.notification.isRead
        ? context.color.surface 
        : context.color.surfaceContainerHighest; 

    final hoverColor = context.color.primaryContainer; 

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.notification.isRead 
          ? SystemMouseCursors.basic 
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(bottom: 16),
          transform: Matrix4.translationValues(0, isActuallyHovered ? -5.0 : 0, 0),
          decoration: BoxDecoration(
            color: isActuallyHovered ? hoverColor : baseColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.color.onSurface.withValues(alpha: isActuallyHovered ? 0.08 : 0.03),
                blurRadius: isActuallyHovered ? 12 : 6,
                offset: Offset(0, isActuallyHovered ? 6 : 2),
              ),
            ],
            border: Border.all(
              color: isActuallyHovered 
                  ? context.color.primary.withValues(alpha: 0.3) 
                  : (widget.notification.isRead 
                      ? context.color.outlineVariant 
                      : context.color.primary.withValues(alpha: 0.2)),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NotificationSideBar(
                    type: widget.notification.type,
                    isHovered: isActuallyHovered, 
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _NotificationHeader(
                            type: widget.notification.type,
                            createdAt: widget.notification.createdAt,
                          ),
                          const SizedBox(height: 8),
                          _NotificationContent(
                            title: widget.notification.title,
                            description: widget.notification.description,
                          ),
                          if (widget.notification.actionText != null) ...[
                            const SizedBox(height: 12),
                            _NotificationActionButton(
                              text: widget.notification.actionText!,
                              onTap: widget.onActionTap,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// Sub-Widgets 
// ==========================================

class _NotificationSideBar extends StatelessWidget {
  final String type;
  final bool isHovered;

  const _NotificationSideBar({required this.type, required this.isHovered});

  Color _getTypeColor(BuildContext context) {
    switch (type) {
      case 'offer': 
        return const Color(0xFF4CAF50); // الأخضر الحشيشي للعروض
      case 'event': 
        return const Color(0xFFFDBA2A); // درجة الأصفر الذهبي المطلوبة #FDBA2A للفعاليات
      case 'weather': 
        return const Color(0xFF5DADE2); // الأزرق السماوي للطقس
      case 'recommendation': 
        return context.color.onSurfaceVariant; 
      case 'task': 
        return const Color(0xFF800020); 
      default: 
        return context.color.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isHovered ? 8 : 5, 
      decoration: BoxDecoration(
        color: _getTypeColor(context),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );
  }
}

class _NotificationHeader extends StatelessWidget {
  final String type;
  final DateTime createdAt;

  const _NotificationHeader({required this.type, required this.createdAt});

  String _getTypeLabel() {
    switch (type) {
      case 'event': return 'فعالية قادمة';
      case 'offer': return 'عرض حصري';
      case 'recommendation': return 'توصية سياحية';
      case 'weather': return 'تحديث الطقس';
      case 'task': return 'إدارة المهام';
      default: return 'تنبيه';
    }
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 60) return 'منذ ${difference.inMinutes} دقيقة';
    if (difference.inHours < 24) return 'منذ ${difference.inHours} ساعات';
    return 'منذ ${difference.inDays} أيام';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getTypeLabel(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: context.color.primary,
          ),
        ),
        Text(
          _formatTime(createdAt),
          style: TextStyle(
            fontSize: 11,
            color: context.color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _NotificationContent extends StatelessWidget {
  final String title;
  final String description;

  const _NotificationContent({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: context.color.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: context.color.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _NotificationActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _NotificationActionButton({required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: context.color.primary, 
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: context.color.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}