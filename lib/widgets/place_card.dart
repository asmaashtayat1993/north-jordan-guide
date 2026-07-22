
import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/constants.dart';

class PlaceCard extends StatelessWidget {
  final String title;
  final String location;
  final double rating;
  final String imageUrl;
  final VoidCallback? onCardTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const PlaceCard({
    Key? key,
    required this.title,
    required this.location,
    required this.rating,
    required this.imageUrl,
    this.onCardTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        height: 240, // يمكن استبدالها بمتغير من ملف Constants
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. الصورة مع معالجة الأخطاء
              _buildBackgroundImage(),

              // 2. زر المفضلة المفصول
              Positioned(
                top: 16,
                left: 16,
                child: _FavoriteButton(
                  isFavorite: isFavorite,
                  onTap: onFavoriteTap,
                ),
              ),

              // 3. البطاقة الزجاجية السفلية المفصولة
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _GlassInfoCard(
                  title: title,
                  location: location,
                  rating: rating,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

// ==========================================
// Sub-Widgets (تطبيق مبدأ المسؤولية الواحدة)
// ==========================================

class _FavoriteButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isFavorite;

  const _FavoriteButton({
    Key? key,
    this.onTap,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: context.color.primary,
          size: 20,
        ),
      ),
    );
  }
}

class _GlassInfoCard extends StatelessWidget {
  final String title;
  final String location;
  final double rating;

  const _GlassInfoCard({
    Key? key,
    required this.title,
    required this.location,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRatingBadge(context),
              _buildTextInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.color.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            rating.toStringAsFixed(1), // لضمان عرض رقم عشري واحد دائماً
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.color.onSecondaryContainer,
              fontSize: 14,
            ),
          ),
          Icon(
            Icons.star, // تعديل لشكل النجمة الممتلئة لتدل على التقييم
            size: 12,
            color: context.color.onSecondaryContainer,
          ),
        ],
      ),
    );
  }

  Widget _buildTextInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: context.color.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // حماية الكود من تمدد النص
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.color.primary.withOpacity(0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: context.color.primary.withOpacity(0.8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}