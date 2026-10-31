import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';
import '../../home/presentation/home_screen.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) => MainShell(
        currentRoute: AppRoutes.offers,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text('Special Offers', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('A little something special for your next find.', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 18),
            _OfferCard(kicker: 'WEEKEND DEAL', title: 'Up to 40% off',
                description: 'Refresh your favorites with special weekend prices.',
                foreground: const Color(0xFF5B5FEF), background: const Color(0xFFE9E9FF), icon: Icons.weekend_rounded),
            _OfferCard(kicker: 'NEW SEASON', title: 'New arrivals',
                description: 'Discover fresh picks selected just for you.',
                foreground: const Color(0xFF0D9488), background: const Color(0xFFDDF8F3), icon: Icons.auto_awesome_rounded),
            _OfferCard(kicker: 'LIMITED TIME', title: 'Extra savings',
                description: 'Find selected items at a special price.',
                foreground: const Color(0xFFEA580C), background: const Color(0xFFFFEAD9), icon: Icons.bolt_rounded),
          ],
        ),
      );
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.kicker, required this.title, required this.description,
    required this.foreground, required this.background, required this.icon});
  final String kicker, title, description;
  final Color foreground, background;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(24)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .75), borderRadius: BorderRadius.circular(20)),
              child: Text(kicker, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: foreground))),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: foreground)),
            const SizedBox(height: 6),
            Text(description, style: TextStyle(color: foreground.withValues(alpha: .85), height: 1.35)),
          ])),
          const SizedBox(width: 8),
          Container(width: 76, height: 76,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .7), shape: BoxShape.circle),
            child: Icon(icon, size: 42, color: foreground)),
        ]),
      );
}
