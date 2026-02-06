import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// A floating action button that appears when the user scrolls down
/// and scrolls back to the top when tapped.
class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;
  final double showOffset;
  final Widget? child;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
    this.showOffset = 200,
    this.child,
  });

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final shouldShow = widget.scrollController.offset > widget.showOffset;
    if (shouldShow != _isVisible) {
      setState(() => _isVisible = shouldShow);
      if (shouldShow) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton.small(
        onPressed: _scrollToTop,
        backgroundColor: EventismTheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: widget.child ?? const Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}

/// A wrapper that provides a scroll controller and optional scroll-to-top button.
class ScrollableWithTopButton extends StatefulWidget {
  final Widget Function(ScrollController scrollController) builder;
  final bool showButton;
  final double buttonShowOffset;

  const ScrollableWithTopButton({
    super.key,
    required this.builder,
    this.showButton = true,
    this.buttonShowOffset = 200,
  });

  @override
  State<ScrollableWithTopButton> createState() => _ScrollableWithTopButtonState();
}

class _ScrollableWithTopButtonState extends State<ScrollableWithTopButton> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(_scrollController),
        if (widget.showButton)
          Positioned(
            right: 16,
            bottom: 16,
            child: ScrollToTopButton(
              scrollController: _scrollController,
              showOffset: widget.buttonShowOffset,
            ),
          ),
      ],
    );
  }
}

/// A mixin to easily add scroll-to-top functionality to any stateful widget.
mixin ScrollToTopMixin<T extends StatefulWidget> on State<T> {
  late ScrollController scrollController;
  bool showScrollToTop = false;
  double scrollThreshold = 200;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = scrollController.offset > scrollThreshold;
    if (shouldShow != showScrollToTop) {
      setState(() => showScrollToTop = shouldShow);
    }
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  Widget buildScrollToTopButton() {
    return AnimatedOpacity(
      opacity: showScrollToTop ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedScale(
        scale: showScrollToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton.small(
          onPressed: showScrollToTop ? scrollToTop : null,
          backgroundColor: EventismTheme.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }
}
