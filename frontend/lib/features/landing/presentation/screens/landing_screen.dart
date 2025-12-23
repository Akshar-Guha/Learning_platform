import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/hero_section.dart';
import '../widgets/features_section.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/stats_section.dart';
import '../widgets/stats_for_nerds_section.dart';
import '../widgets/cta_section.dart';

/// Landing Screen - The main marketing/conversion page
/// 
/// Features:
/// - Hero section with animated gradient background
/// - Features grid showing app capabilities
/// - How it works step-by-step guide
/// - Stats section with animated counters
/// - Final CTA section
/// 
/// Scalability:
/// - Add new sections by creating widgets and adding to _sections list
/// - Features can be extended via FeatureData model
/// - Each section is self-contained and reusable
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showNavbar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showNavbar = _scrollController.offset > 100;
    if (showNavbar != _showNavbar) {
      setState(() => _showNavbar = showNavbar);
    }
  }

  void _scrollToFeatures() {
    final screenHeight = MediaQuery.of(context).size.height;
    _scrollController.animateTo(
      screenHeight * 0.95,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Main scrollable content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Hero Section
              SliverToBoxAdapter(
                child: HeroSection(
                  onLearnMore: _scrollToFeatures,
                ),
              ),
              
              // Features Section
              const SliverToBoxAdapter(
                child: FeaturesSection(),
              ),
              
              // How It Works Section
              const SliverToBoxAdapter(
                child: HowItWorksSection(),
              ),
              
              // Stats Section
              const SliverToBoxAdapter(
                child: StatsSection(),
              ),
              
              // Stats For Nerds Section (Technical Deep-Dive)
              const SliverToBoxAdapter(
                child: StatsForNerdsSection(),
              ),
              
              // CTA Section
              const SliverToBoxAdapter(
                child: CTASection(),
              ),
              
              // Footer
              SliverToBoxAdapter(
                child: _buildFooter(),
              ),
            ],
          ),
          
          // Floating navbar (appears on scroll)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            top: _showNavbar ? 0 : -80,
            left: 0,
            right: 0,
            child: _buildFloatingNavbar(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.darkBg.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.darkBorder.withOpacity(0.5),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Logo
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'ULP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimaryDark,
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Nav actions
            TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: AppTheme.textSecondaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go(AppRoutes.signup),
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        border: Border(
          top: BorderSide(
            color: AppTheme.darkBorder.withOpacity(0.5),
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo and tagline
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'ULP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimaryDark,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Rise Together • Built for Gen-Z Learners',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryDark.withOpacity(0.8),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Social links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Iconsax.instagram),
              _buildSocialIcon(Iconsax.message),
              _buildSocialIcon(Iconsax.global),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Copyright
          Text(
            '© 2025 ULP. All rights reserved.',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryDark.withOpacity(0.6),
            ),
          ),
          
          const SizedBox(height: 8),
          
              // Created by Umbra
              InkWell(
                onTap: () async {
                  final url = Uri.parse('https://umbra-portfolio.vercel.app/');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Created by ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryDark.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        'Umbra',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple.withOpacity(0.8),
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

  Widget _buildSocialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.darkCard,
          border: Border.all(
            color: AppTheme.darkBorder.withOpacity(0.5),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppTheme.textSecondaryDark,
        ),
      ),
    );
  }
}
