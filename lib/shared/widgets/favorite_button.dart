import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/providers/favorites_provider.dart';
import 'toast_service.dart';

class FavoriteButton extends ConsumerStatefulWidget {
  final String eventId;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showBackground;
  final VoidCallback? onToggle;

  const FavoriteButton({
    super.key,
    required this.eventId,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
    this.showBackground = false,
    this.onToggle,
  });

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    final isFavorite = ref.read(isEventFavoritedProvider(widget.eventId));

    // Trigger animation
    _controller.forward(from: 0);

    // Toggle favorite
    await ref.read(favoritesProvider.notifier).toggleFavorite(widget.eventId);

    // Show toast
    if (mounted) {
      ToastService.show(
        context,
        isFavorite ? 'Removed from favorites' : 'Added to favorites',
        icon: isFavorite ? Icons.heart_broken : Icons.favorite,
      );
    }

    widget.onToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isEventFavoritedProvider(widget.eventId));
    final activeColor = widget.activeColor ?? Colors.red;
    final inactiveColor = widget.inactiveColor ?? EventismTheme.textMuted;

    final button = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: widget.size,
            color: isFavorite ? activeColor : inactiveColor,
          ),
        );
      },
    );

    if (widget.showBackground) {
      return Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          onTap: _toggleFavorite,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(widget.size * 0.35),
            child: button,
          ),
        ),
      );
    }

    return IconButton(
      onPressed: _toggleFavorite,
      icon: button,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: widget.size + 8,
        minHeight: widget.size + 8,
      ),
    );
  }
}

class FavoriteIconButton extends ConsumerWidget {
  final String eventId;
  final double size;

  const FavoriteIconButton({
    super.key,
    required this.eventId,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isEventFavoritedProvider(eventId));

    return IconButton(
      onPressed: () async {
        await ref.read(favoritesProvider.notifier).toggleFavorite(eventId);
        if (context.mounted) {
          ToastService.show(
            context,
            isFavorite ? 'Removed from favorites' : 'Added to favorites',
            icon: isFavorite ? Icons.heart_broken : Icons.favorite,
          );
        }
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        size: size,
        color: isFavorite ? Colors.red : EventismTheme.textMuted,
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: size + 8,
        minHeight: size + 8,
      ),
    );
  }
}
