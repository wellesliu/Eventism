import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import 'toast_service.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return Container(
      color: EventismTheme.textPrimary,
      child: Column(
        children: [
          // Newsletter section
          _buildNewsletterSection(context, isMobile),
          // Main footer content
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 64,
              vertical: isMobile ? 32 : 48,
            ),
            child: isMobile
                ? _buildMobileFooter(context)
                : _buildDesktopFooter(context),
          ),
          // Bottom bar
          _buildBottomBar(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildNewsletterSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 32 : 40,
      ),
      decoration: BoxDecoration(
        color: EventismTheme.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: isMobile
          ? Column(
              children: [
                _buildNewsletterText(context),
                const SizedBox(height: 16),
                _buildNewsletterInput(context),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildNewsletterText(context)),
                const SizedBox(width: 32),
                SizedBox(
                  width: 400,
                  child: _buildNewsletterInput(context),
                ),
              ],
            ),
    );
  }

  Widget _buildNewsletterText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stay in the loop',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Get the latest events and opportunities delivered to your inbox.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ),
      ],
    );
  }

  Widget _buildNewsletterInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: () {
            ToastService.success(
              context,
              'Thanks for subscribing!',
              icon: Icons.check_circle,
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: EventismTheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          child: const Text('Subscribe'),
        ),
      ],
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand column
        Expanded(
          flex: 2,
          child: _buildBrandColumn(context),
        ),
        const SizedBox(width: 48),
        // Discover column
        Expanded(
          child: _buildFooterColumn(
            context,
            title: 'Discover',
            links: [
              _FooterLink('Browse Events', '/browse'),
              _FooterLink('Map View', '/map'),
              _FooterLink('Calendar', '/calendar'),
              _FooterLink('About Us', '/about'),
            ],
          ),
        ),
        // For Vendors column
        Expanded(
          child: _buildFooterColumn(
            context,
            title: 'For Vendors',
            links: [
              _FooterLink('Vendor Opportunities', '/browse?vendors=true'),
              _FooterLink('Find Vendors', '/vendors/directory'),
              _FooterLink('For Vendors', '/vendors'),
            ],
          ),
        ),
        // For Organizers column
        Expanded(
          child: _buildFooterColumn(
            context,
            title: 'For Organizers',
            links: [
              _FooterLink('List Your Event', null, isModal: true),
              _FooterLink('Find Organizers', '/organizers'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrandColumn(context),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFooterColumn(
                context,
                title: 'Discover',
                links: [
                  _FooterLink('Browse Events', '/browse'),
                  _FooterLink('Map View', '/map'),
                  _FooterLink('Calendar', '/calendar'),
                ],
              ),
            ),
            Expanded(
              child: _buildFooterColumn(
                context,
                title: 'For Vendors',
                links: [
                  _FooterLink('Opportunities', '/browse?vendors=true'),
                  _FooterLink('Directory', '/vendors/directory'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    EventismTheme.primary,
                    EventismTheme.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 18,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 18,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Connecting communities through amazing events.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
        ),
        const SizedBox(height: 20),
        // Social icons
        Row(
          children: [
            _buildSocialIcon(Icons.camera_alt_outlined, 'Instagram'),
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.music_note_outlined, 'TikTok'),
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.facebook_outlined, 'Facebook'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildFooterColumn(
    BuildContext context, {
    required String title,
    required List<_FooterLink> links,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: link.isModal
                    ? () {
                        // Show coming soon toast
                        ToastService.info(
                          context,
                          'Coming soon!',
                          icon: Icons.construction,
                        );
                      }
                    : link.path != null
                        ? () => GoRouter.of(context).go(link.path!)
                        : null,
                child: Text(
                  link.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: isMobile
          ? Column(
              children: [
                Text(
                  '© 2026 ${AppConstants.appName}. All rights reserved.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                ),
                const SizedBox(height: 12),
                _buildLegalLinks(context),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2026 ${AppConstants.appName}. All rights reserved.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                ),
                _buildLegalLinks(context),
              ],
            ),
    );
  }

  Widget _buildLegalLinks(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLegalLink(context, 'Privacy Policy'),
        _buildLegalDivider(context),
        _buildLegalLink(context, 'Terms of Service'),
        _buildLegalDivider(context),
        _buildLegalLink(context, 'Contact'),
      ],
    );
  }

  Widget _buildLegalLink(BuildContext context, String label) {
    return InkWell(
      onTap: () {
        ToastService.info(context, 'Coming soon!', icon: Icons.construction);
      },
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
      ),
    );
  }

  Widget _buildLegalDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        '|',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.3),
            ),
      ),
    );
  }
}

class _FooterLink {
  final String label;
  final String? path;
  final bool isModal;

  const _FooterLink(this.label, this.path, {this.isModal = false});
}
