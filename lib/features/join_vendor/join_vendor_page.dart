import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../shared/widgets/toast_service.dart';

class JoinVendorPage extends StatefulWidget {
  const JoinVendorPage({super.key});

  @override
  State<JoinVendorPage> createState() => _JoinVendorPageState();
}

class _JoinVendorPageState extends State<JoinVendorPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero section
          _buildHero(context, isMobile),
          // Benefits section
          _buildBenefits(context, isMobile),
          // How it works
          _buildHowItWorks(context, isMobile),
          // Form section
          _buildFormSection(context, isMobile),
          // Testimonials
          _buildTestimonials(context, isMobile),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 40 : 64,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C4A6E), // Dark blue
            EventismTheme.cta,
            Color(0xFF38BDF8), // Light blue
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Grow Your Business',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Join our vendor network and connect with events across Australia',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Stats
          Wrap(
            spacing: isMobile ? 24 : 48,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildStat('500+', 'Events'),
              _buildStat('1000+', 'Vendors'),
              _buildStat('15+', 'Cities'),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () {
                  // Scroll to form
                  Scrollable.ensureVisible(
                    _formKey.currentContext ?? context,
                    duration: const Duration(milliseconds: 500),
                  );
                },
                icon: const Icon(Icons.arrow_downward),
                label: const Text('Apply Now'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: EventismTheme.cta,
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () => context.go('/browse?vendors=true'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text('Browse Opportunities'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefits(BuildContext context, bool isMobile) {
    final benefits = [
      _Benefit(
        icon: Icons.search,
        title: 'Discover Events',
        description: 'Browse hundreds of events accepting vendors, from local markets to major festivals.',
      ),
      _Benefit(
        icon: Icons.connect_without_contact,
        title: 'Direct Contact',
        description: 'Connect directly with event organizers and skip the middleman.',
      ),
      _Benefit(
        icon: Icons.calendar_today,
        title: 'Plan Ahead',
        description: 'See upcoming events months in advance and plan your calendar.',
      ),
      _Benefit(
        icon: Icons.star,
        title: 'Build Your Profile',
        description: 'Showcase your products and get discovered by organizers.',
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 32 : 48,
      ),
      child: Column(
        children: [
          Text(
            'Why Join Eventism?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: benefits.map((b) => SizedBox(
              width: isMobile ? double.infinity : 280,
              child: _buildBenefitCard(context, b),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(BuildContext context, _Benefit benefit) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EventismTheme.cta.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(benefit.icon, color: EventismTheme.cta),
          ),
          const SizedBox(height: 16),
          Text(
            benefit.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            benefit.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks(BuildContext context, bool isMobile) {
    final steps = [
      _Step('1', 'Create Profile', 'Sign up and showcase your products or services'),
      _Step('2', 'Browse Events', 'Find events that match your business'),
      _Step('3', 'Apply', 'Send applications directly to organizers'),
      _Step('4', 'Get Booked', 'Receive confirmations and grow your business'),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 32 : 48,
      ),
      color: EventismTheme.background,
      child: Column(
        children: [
          Text(
            'How It Works',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: isMobile ? 16 : 32,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: steps.map((s) => SizedBox(
              width: isMobile ? double.infinity : 220,
              child: _buildStepCard(context, s),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, _Step step) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: EventismTheme.cta,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              step.number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          step.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          step.description,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 32 : 48,
      ),
      child: Column(
        children: [
          Text(
            'Join Our Network',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your vendor profile and start connecting with events',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: EventismTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: EventismTheme.border),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Business Name',
                      hintText: 'Your business or brand name',
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Contact Name',
                      hintText: 'Your name',
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    items: AppConstants.vendorCategories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    decoration: const InputDecoration(
                      labelText: 'Primary Location',
                    ),
                    items: AppConstants.australianCities.map((city) {
                      return DropdownMenuItem(value: city, child: Text(city));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCity = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'your@email.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Website or Instagram',
                      hintText: 'https:// or @handle',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tell us about your business',
                      hintText: 'What do you sell? What makes you unique?',
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          ToastService.success(
                            context,
                            'Welcome! Your profile is being reviewed.',
                            icon: Icons.check_circle,
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: EventismTheme.cta,
                      ),
                      child: const Text('Create Profile'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonials(BuildContext context, bool isMobile) {
    final testimonials = [
      _Testimonial(
        name: 'Sarah M.',
        business: 'Sunny Side Candles',
        quote: 'Eventism helped me find the perfect markets for my candle business. I\'ve tripled my monthly sales!',
      ),
      _Testimonial(
        name: 'Jake T.',
        business: 'Pocket Pierogies',
        quote: 'The direct connection to organizers saves so much time. No more endless email chains.',
      ),
      _Testimonial(
        name: 'Emma L.',
        business: 'Wild Thread Studio',
        quote: 'I love being able to plan my calendar months in advance. Game changer for my business.',
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 32 : 48,
      ),
      color: EventismTheme.background,
      child: Column(
        children: [
          Text(
            'What Vendors Say',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: testimonials.map((t) => SizedBox(
              width: isMobile ? double.infinity : 320,
              child: _buildTestimonialCard(context, t),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(BuildContext context, _Testimonial testimonial) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (i) => const Icon(
              Icons.star,
              color: EventismTheme.warning,
              size: 18,
            )),
          ),
          const SizedBox(height: 16),
          Text(
            '"${testimonial.quote}"',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            testimonial.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            testimonial.business,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: EventismTheme.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

class _Benefit {
  final IconData icon;
  final String title;
  final String description;

  _Benefit({required this.icon, required this.title, required this.description});
}

class _Step {
  final String number;
  final String title;
  final String description;

  _Step(this.number, this.title, this.description);
}

class _Testimonial {
  final String name;
  final String business;
  final String quote;

  _Testimonial({required this.name, required this.business, required this.quote});
}
