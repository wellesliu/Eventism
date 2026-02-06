import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// A consistent error state widget for displaying errors across the app.
class ErrorState extends StatelessWidget {
  final String? title;
  final String? message;
  final String? errorDetails;
  final VoidCallback? onRetry;
  final bool showIcon;
  final bool compact;

  const ErrorState({
    super.key,
    this.title,
    this.message,
    this.errorDetails,
    this.onRetry,
    this.showIcon = true,
    this.compact = false,
  });

  factory ErrorState.network({
    VoidCallback? onRetry,
  }) =>
      ErrorState(
        title: 'Connection Error',
        message: 'Please check your internet connection and try again.',
        onRetry: onRetry,
      );

  factory ErrorState.notFound({
    String itemType = 'item',
  }) =>
      ErrorState(
        title: '$itemType Not Found',
        message: 'The $itemType you\'re looking for doesn\'t exist or has been removed.',
      );

  factory ErrorState.generic({
    String? errorDetails,
    VoidCallback? onRetry,
  }) =>
      ErrorState(
        title: 'Something Went Wrong',
        message: 'An unexpected error occurred. Please try again.',
        errorDetails: errorDetails,
        onRetry: onRetry,
      );

  factory ErrorState.loading({
    VoidCallback? onRetry,
  }) =>
      ErrorState(
        title: 'Loading Failed',
        message: 'We couldn\'t load the content. Please try again.',
        onRetry: onRetry,
      );

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildFull(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: EventismTheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: EventismTheme.error.withValues(alpha: 0.7),
                ),
              ),
            if (showIcon) const SizedBox(height: 24),
            Text(
              title ?? 'Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: EventismTheme.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (errorDetails != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: EventismTheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorDetails!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: EventismTheme.textMuted,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventismTheme.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: EventismTheme.error.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 24,
            color: EventismTheme.error.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? 'Error',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (message != null)
                  Text(
                    message!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: EventismTheme.textSecondary,
                        ),
                  ),
              ],
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              color: EventismTheme.error,
            ),
        ],
      ),
    );
  }
}

/// A widget that shows a loading indicator with optional message.
class LoadingState extends StatelessWidget {
  final String? message;
  final bool compact;

  const LoadingState({
    super.key,
    this.message,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          if (message != null) ...[
            const SizedBox(width: 12),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: EventismTheme.textSecondary,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
