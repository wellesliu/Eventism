import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../shared/widgets/toast_service.dart';

class ListEventPage extends StatefulWidget {
  const ListEventPage({super.key});

  @override
  State<ListEventPage> createState() => _ListEventPageState();
}

class _ListEventPageState extends State<ListEventPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEventType;
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
          // Form section
          _buildFormSection(context, isMobile),
          // Pricing section
          _buildPricing(context, isMobile),
          // FAQ section
          _buildFAQ(context, isMobile),
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
            Color(0xFF064E3B),
            EventismTheme.primaryDark,
            EventismTheme.primary,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'List Your Event',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Reach thousands of attendees and vendors across Australia',
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
              _buildStat('10K+', 'Monthly Visitors'),
              _buildStat('500+', 'Events Listed'),
              _buildStat('1000+', 'Vendors Connected'),
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
        icon: Icons.visibility,
        title: 'Increased Visibility',
        description: 'Get discovered by thousands of potential attendees searching for events in your area.',
      ),
      _Benefit(
        icon: Icons.storefront,
        title: 'Vendor Management',
        description: 'Easily manage vendor applications and connect with quality stallholders.',
      ),
      _Benefit(
        icon: Icons.calendar_month,
        title: 'Calendar Integration',
        description: 'Your events appear on our interactive calendar and map views.',
      ),
      _Benefit(
        icon: Icons.analytics,
        title: 'Analytics Dashboard',
        description: 'Track views, saves, and engagement with detailed analytics.',
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
            'Why List With Us?',
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
              color: EventismTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(benefit.icon, color: EventismTheme.primary),
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

  Widget _buildFormSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 32 : 48,
      ),
      color: EventismTheme.background,
      child: Column(
        children: [
          Text(
            'Get Started',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us about your event and we\'ll get you set up',
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
                      labelText: 'Event Name',
                      hintText: 'e.g., Summer Night Markets',
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Organization Name',
                      hintText: 'Your company or organization',
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedEventType,
                    decoration: const InputDecoration(
                      labelText: 'Event Type',
                    ),
                    items: AppConstants.organizerEventTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedEventType = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    decoration: const InputDecoration(
                      labelText: 'City',
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
                      labelText: 'Tell us about your event',
                      hintText: 'Describe your event, expected attendance, etc.',
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
                            'Thanks! We\'ll be in touch soon.',
                            icon: Icons.check_circle,
                          );
                        }
                      },
                      child: const Text('Submit Application'),
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

  Widget _buildPricing(BuildContext context, bool isMobile) {
    final plans = [
      _Plan(
        name: 'Basic',
        price: 'Free',
        description: 'Perfect for small community events',
        features: [
          'Single event listing',
          'Basic analytics',
          'Email support',
        ],
        isPopular: false,
      ),
      _Plan(
        name: 'Pro',
        price: '\$29/mo',
        description: 'For regular event organizers',
        features: [
          'Unlimited events',
          'Advanced analytics',
          'Vendor management tools',
          'Priority support',
          'Featured placement',
        ],
        isPopular: true,
      ),
      _Plan(
        name: 'Enterprise',
        price: 'Custom',
        description: 'For large organizations',
        features: [
          'Everything in Pro',
          'Custom branding',
          'API access',
          'Dedicated account manager',
          'Multi-user accounts',
        ],
        isPopular: false,
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
            'Simple Pricing',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the plan that fits your needs',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: plans.map((p) => SizedBox(
              width: isMobile ? double.infinity : 300,
              child: _buildPlanCard(context, p),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, _Plan plan) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: plan.isPopular ? EventismTheme.primary : EventismTheme.border,
          width: plan.isPopular ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: EventismTheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Most Popular',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (plan.isPopular) const SizedBox(height: 12),
          Text(
            plan.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            plan.price,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: EventismTheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            plan.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ...plan.features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: EventismTheme.success, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(f, style: Theme.of(context).textTheme.bodySmall)),
              ],
            ),
          )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: plan.isPopular
                ? FilledButton(
                    onPressed: () => ToastService.info(context, 'Coming soon!'),
                    child: const Text('Get Started'),
                  )
                : OutlinedButton(
                    onPressed: () => ToastService.info(context, 'Coming soon!'),
                    child: const Text('Get Started'),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ(BuildContext context, bool isMobile) {
    final faqs = [
      _FAQ('How long does approval take?', 'Most events are approved within 24-48 hours.'),
      _FAQ('Can I edit my event after listing?', 'Yes, you can update your event details anytime.'),
      _FAQ('What types of events can I list?', 'We accept markets, festivals, fairs, expos, and community events.'),
      _FAQ('How do I manage vendor applications?', 'Pro and Enterprise plans include vendor management tools.'),
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
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 32),
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: faqs.map((faq) => _buildFAQItem(context, faq)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, _FAQ faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EventismTheme.border),
      ),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              faq.answer,
              style: Theme.of(context).textTheme.bodyMedium,
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

class _Plan {
  final String name;
  final String price;
  final String description;
  final List<String> features;
  final bool isPopular;

  _Plan({
    required this.name,
    required this.price,
    required this.description,
    required this.features,
    required this.isPopular,
  });
}

class _FAQ {
  final String question;
  final String answer;

  _FAQ(this.question, this.answer);
}
