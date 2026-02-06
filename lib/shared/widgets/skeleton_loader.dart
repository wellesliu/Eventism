import 'package:flutter/material.dart';

import '../../core/theme.dart';

class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final bool isCircle;

  const SkeletonLoader({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
    this.isCircle = false,
  });

  factory SkeletonLoader.circle({required double size}) => SkeletonLoader(
        width: size,
        height: size,
        isCircle: true,
      );

  factory SkeletonLoader.text({double? width, double height = 16}) =>
      SkeletonLoader(
        width: width,
        height: height,
        borderRadius: 4,
      );

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.isCircle
                ? null
                : BorderRadius.circular(widget.borderRadius),
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                Color(0xFFE5E7EB),
                Color(0xFFF3F4F6),
                Color(0xFFE5E7EB),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class EventCardSkeleton extends StatelessWidget {
  const EventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          const ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: SkeletonLoader(height: 140),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                SkeletonLoader.text(width: 180, height: 18),
                const SizedBox(height: 8),
                // Date
                SkeletonLoader.text(width: 120, height: 14),
                const SizedBox(height: 6),
                // Location
                SkeletonLoader.text(width: 150, height: 14),
                const SizedBox(height: 12),
                // Tags
                Row(
                  children: [
                    SkeletonLoader(width: 60, height: 24, borderRadius: 12),
                    const SizedBox(width: 8),
                    SkeletonLoader(width: 80, height: 24, borderRadius: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VendorCardSkeleton extends StatelessWidget {
  const VendorCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          const ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: SkeletonLoader(height: 120),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and name row
                Row(
                  children: [
                    SkeletonLoader.circle(size: 40),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLoader.text(width: 120, height: 16),
                        const SizedBox(height: 4),
                        SkeletonLoader.text(width: 80, height: 12),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Categories
                Row(
                  children: [
                    SkeletonLoader(width: 70, height: 24, borderRadius: 12),
                    const SizedBox(width: 8),
                    SkeletonLoader(width: 90, height: 24, borderRadius: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileHeaderSkeleton extends StatelessWidget {
  const ProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Banner
        const SkeletonLoader(height: 200),
        // Profile info
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                margin: const EdgeInsets.only(top: -50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: SkeletonLoader.circle(size: 100),
              ),
              const SizedBox(width: 24),
              // Name and tagline
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader.text(width: 200, height: 24),
                    const SizedBox(height: 8),
                    SkeletonLoader.text(height: 16),
                    const SizedBox(height: 16),
                    SkeletonLoader.text(width: 150, height: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
