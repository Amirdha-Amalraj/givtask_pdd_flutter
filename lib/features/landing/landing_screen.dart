import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/givtask_logo.dart';

// ──────────────────────── BRAND PALETTE ────────────────────────
const _kPrimary = Color(0xFF2E7D32);
const _kPrimaryLight = Color(0xFF43A047);
const _kPrimaryDark = Color(0xFF1B5E20);
const _kBlue = Color(0xFF1565C0);
const _kOrange = Color(0xFFEF6C00);
const _kHeroDark = Color(0xFF060E18);
const _kHeroMid = Color(0xFF0A2215);
const _kDarkBg = Color(0xFF0F2A13);
const _kTextPrimary = Color(0xFF1E293B);
const _kTextSecondary = Color(0xFF64748B);
const _kBgLight = Color(0xFFF8FAFC);
const _kBgAlt = Color(0xFFEEF6EE);
const _kBorder = Color(0xFFE2E8F0);
const _kNavHeight = 72.0;
const _kMaxWidth = 1180.0;

// ──────────────────────── MAIN SCREEN ────────────────────────
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool _isNavScrolled = false;

  // Section keys for smooth scroll anchoring
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _statsKey = GlobalKey();
  final GlobalKey _benefitsKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final scrolled = _scrollController.offset > 30;
      if (scrolled != _isNavScrolled) {
        setState(() => _isNavScrolled = scrolled);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _kBgLight,
      endDrawer: isMobile ? _buildMobileDrawer(context) : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: _kNavHeight),
                _HeroSection(
                  heroKey: _heroKey,
                  onGetStarted: () => context.go('/role-selection'),
                  onLearnMore: () => _scrollTo(_aboutKey),
                ),
                _AboutSection(sectionKey: _aboutKey),
                _FeaturesSection(sectionKey: _featuresKey),
                _HowItWorksSection(sectionKey: _howItWorksKey),
                _MissionSection(sectionKey: _statsKey),
                _BenefitsSection(sectionKey: _benefitsKey),
                _FaqSection(sectionKey: _faqKey),
                _ContactSection(sectionKey: _contactKey),
                const _FooterSection(),
              ],
            ),
          ),
          // Sticky nav overlay
          Positioned(
            top: 0, left: 0, right: 0,
            child: _NavBar(
              isScrolled: _isNavScrolled,
              isMobile: isMobile,
              onLogoTap: () => _scrollTo(_heroKey),
              onAboutTap: () => _scrollTo(_aboutKey),
              onFeaturesTap: () => _scrollTo(_featuresKey),
              onHowItWorksTap: () => _scrollTo(_howItWorksKey),
              onContactTap: () => _scrollTo(_contactKey),
              onLoginTap: () => context.go('/role-selection?action=login'),
              onRegisterTap: () => context.go('/role-selection?action=register'),
              onMenuTap: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      width: 280,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const GivTaskLogo(size: 28),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ...[
                ('Home', _heroKey),
                ('About', _aboutKey),
                ('Features', _featuresKey),
                ('How It Works', _howItWorksKey),
                ('Contact', _contactKey),
              ].map((item) => ListTile(
                title: Text(item.$1, style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w500, color: _kTextPrimary,
                )),
                onTap: () {
                  Navigator.pop(context);
                  _scrollTo(item.$2);
                },
                contentPadding: EdgeInsets.zero,
              )),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/role-selection?action=login');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _kPrimary,
                    side: const BorderSide(color: _kPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/role-selection?action=register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Get Started Free'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────── STICKY NAV BAR ────────────────────────
class _NavBar extends StatelessWidget {
  final bool isScrolled;
  final bool isMobile;
  final VoidCallback onLogoTap;
  final VoidCallback onAboutTap;
  final VoidCallback onFeaturesTap;
  final VoidCallback onHowItWorksTap;
  final VoidCallback onContactTap;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;
  final VoidCallback onMenuTap;

  const _NavBar({
    required this.isScrolled,
    required this.isMobile,
    required this.onLogoTap,
    required this.onAboutTap,
    required this.onFeaturesTap,
    required this.onHowItWorksTap,
    required this.onContactTap,
    required this.onLoginTap,
    required this.onRegisterTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: _kNavHeight,
      decoration: BoxDecoration(
        color: isScrolled ? Colors.white : Colors.transparent,
        boxShadow: isScrolled
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 2))]
            : [],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // Logo
                GestureDetector(
                  onTap: onLogoTap,
                  child: Row(
                    children: [
                      GivTaskLogo(
                        size: 30,
                        color: isScrolled ? _kPrimary : Colors.white,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (!isMobile) ...[
                  _NavLink('About', isScrolled: isScrolled, onTap: onAboutTap),
                  _NavLink('Features', isScrolled: isScrolled, onTap: onFeaturesTap),
                  _NavLink('How It Works', isScrolled: isScrolled, onTap: onHowItWorksTap),
                  _NavLink('Contact', isScrolled: isScrolled, onTap: onContactTap),
                  const SizedBox(width: 20),
                  _NavButton(
                    label: 'Login',
                    outlined: true,
                    isScrolled: isScrolled,
                    onTap: onLoginTap,
                  ),
                  const SizedBox(width: 10),
                  _NavButton(
                    label: 'Register',
                    outlined: false,
                    isScrolled: isScrolled,
                    onTap: onRegisterTap,
                  ),
                ] else ...[
                  IconButton(
                    icon: Icon(Icons.menu_rounded,
                        color: isScrolled ? _kTextPrimary : Colors.white, size: 28),
                    onPressed: onMenuTap,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool isScrolled;
  final VoidCallback onTap;
  const _NavLink(this.label, {required this.isScrolled, required this.onTap});
  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: _hovered ? FontWeight.w600 : FontWeight.w500,
              color: _hovered
                  ? _kPrimary
                  : (widget.isScrolled ? _kTextPrimary : Colors.white.withValues(alpha: 0.85)),
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final bool outlined;
  final bool isScrolled;
  final VoidCallback onTap;
  const _NavButton({required this.label, required this.outlined, required this.isScrolled, required this.onTap});
  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = widget.isScrolled ? _kPrimary : Colors.white;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          decoration: BoxDecoration(
            color: widget.outlined
                ? (_hovered ? effectiveBorderColor.withValues(alpha: 0.1) : Colors.transparent)
                : (_hovered ? _kPrimaryDark : _kPrimary),
            border: Border.all(color: widget.outlined ? effectiveBorderColor : _kPrimary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(widget.label, style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: widget.outlined
                ? effectiveBorderColor
                : Colors.white,
          )),
        ),
      ),
    );
  }
}

// ──────────────────────── SHARED HELPERS ────────────────────────
class _SectionWrapper extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  const _SectionWrapper({required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxWidth),
          child: child,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, textAlign: TextAlign.center, style: GoogleFonts.inter(
          fontSize: 36, fontWeight: FontWeight.w800,
          color: _kTextPrimary,
          height: 1.2,
        )),
        const SizedBox(height: 16),
        Text(subtitle, textAlign: TextAlign.center, style: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w400,
          color: _kTextSecondary,
          height: 1.6,
        )),
      ],
    );
  }
}

// ──────────────────────── HERO SECTION ────────────────────────
class _HeroSection extends StatelessWidget {
  final GlobalKey heroKey;
  final VoidCallback onGetStarted;
  final VoidCallback onLearnMore;

  const _HeroSection({required this.heroKey, required this.onGetStarted, required this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      key: heroKey,
      width: double.infinity,
      constraints: BoxConstraints(minHeight: isMobile ? 580 : 680),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kHeroDark, _kHeroMid, Color(0xFF0A1A0E), _kHeroDark],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Background decorative circles
          Positioned(top: -60, right: -60, child: _DecorCircle(size: 320, color: _kPrimary.withValues(alpha: 0.06))),
          Positioned(bottom: -80, left: -80, child: _DecorCircle(size: 280, color: _kBlue.withValues(alpha: 0.05))),
          Positioned(top: 100, left: w * 0.3, child: _DecorCircle(size: 180, color: _kPrimaryLight.withValues(alpha: 0.04))),
          // Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _kMaxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: isMobile ? 48 : 72,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _kPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: _kPrimaryLight.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: _kPrimaryLight, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text('Skill-Based Social Impact Platform', style: GoogleFonts.inter(
                            color: _kPrimaryLight, fontSize: 13, fontWeight: FontWeight.w500,
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Headline
                    Text(
                      'Connect Skills.\nCreate Impact.\nChange Lives.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: isMobile ? 38 : 58,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Subheadline
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 660),
                      child: Text(
                        'GivTask matches skilled volunteers and freelancers with NGOs that need their expertise. Make a difference with the skills you already have.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: isMobile ? 16 : 19,
                          height: 1.65,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // CTAs
                    Wrap(
                      spacing: 16, runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _HeroButton(
                          label: 'Get Started Free',
                          icon: Icons.arrow_forward_rounded,
                          isPrimary: true,
                          onTap: onGetStarted,
                        ),
                        _HeroButton(
                          label: 'See How It Works',
                          icon: Icons.play_circle_outline_rounded,
                          isPrimary: false,
                          onTap: onLearnMore,
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _DecorCircle({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

class _HeroButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;
  const _HeroButton({required this.label, required this.icon, required this.isPrimary, required this.onTap});
  @override
  State<_HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<_HeroButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_hovered ? _kPrimaryLight : _kPrimary)
                : Colors.white.withValues(alpha: _hovered ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(12),
            border: widget.isPrimary ? null : Border.all(color: Colors.white.withValues(alpha: 0.4)),
            boxShadow: widget.isPrimary && _hovered
                ? [BoxShadow(color: _kPrimary.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 6))]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label, style: GoogleFonts.inter(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700,
              )),
              const SizedBox(width: 8),
              Icon(widget.icon, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}



// ──────────────────────── ABOUT SECTION ────────────────────────
class _AboutSection extends StatelessWidget {
  final GlobalKey sectionKey;
  const _AboutSection({required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return _SectionWrapper(
      backgroundColor: Colors.white,
      child: Column(
        key: sectionKey,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _kBgAlt, borderRadius: BorderRadius.circular(50),
            ),
            child: Text('ABOUT GIVTASK', style: GoogleFonts.inter(
              color: _kPrimary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5,
            )),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: const _SectionTitle(
              title: 'Bridging the Gap Between Skills and Social Impact',
              subtitle: 'We connect NGOs with talented volunteers and skilled freelancers who want their work to mean more.',
            ),
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(children: _aboutCards())
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _aboutCards().map((c) => Expanded(child: c)).toList(),
                ),
        ],
      ),
    );
  }

  List<Widget> _aboutCards() {
    final items = [
      (Icons.hub_rounded, _kPrimary, 'Our Mission',
          'To democratize social impact by making it easy for skilled individuals to contribute meaningfully to causes they care about.'),
      (Icons.visibility_rounded, _kBlue, 'Our Vision',
          'A world where every NGO has access to the skills it needs, and every skilled person can make a real difference.'),
      (Icons.diamond_rounded, _kOrange, 'Our Values',
          'Transparency, inclusivity, and impact. We believe that meaningful work — paid or voluntary — deserves recognition.'),
    ];
    return items.asMap().entries.map((e) {
      final i = e.key;
      final item = e.value;
      return Padding(
        padding: EdgeInsets.only(
          right: i < 2 ? 20 : 0,
          bottom: 20,
        ),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _kBgLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: item.$2.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.$1, color: item.$2, size: 28),
              ),
              const SizedBox(height: 20),
              Text(item.$3, style: GoogleFonts.inter(
                fontSize: 18, fontWeight: FontWeight.w700, color: _kTextPrimary,
              )),
              const SizedBox(height: 10),
              Text(item.$4, style: GoogleFonts.inter(
                fontSize: 15, color: _kTextSecondary, height: 1.65,
              )),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// ──────────────────────── FEATURES SECTION ────────────────────────
class _FeaturesSection extends StatelessWidget {
  final GlobalKey sectionKey;
  const _FeaturesSection({required this.sectionKey});

  static const _features = [
    (Icons.psychology_rounded, _kPrimary, 'AI-Powered Matching',
        'Smart algorithm matches NGO needs with the right volunteers or freelancers based on verified skills.'),
    (Icons.verified_rounded, _kBlue, 'Skill Verification',
        'Built-in skill quizzes and endorsements ensure quality work across all assignments.'),
    (Icons.timeline_rounded, _kOrange, 'Milestone Tracking',
        'Break tasks into milestones. Track progress, approve deliverables, and ensure accountability.'),
    (Icons.card_membership_rounded, _kPrimary, 'Digital Certificates',
        'Volunteers earn shareable certificates for completed work, building their professional portfolio.'),
    (Icons.payments_rounded, _kBlue, 'Integrated Payments',
        'Seamless payment flow for freelance tasks with milestone-based disbursements.'),
    (Icons.groups_rounded, _kOrange, 'Team Collaboration',
        'Apply as teams for large-scale projects. Coordinate, communicate, and deliver together.'),
    (Icons.analytics_rounded, _kPrimary, 'Impact Analytics',
        'NGOs get detailed reports on volunteer hours, task completion rates, and social impact metrics.'),
    (Icons.chat_rounded, _kBlue, 'Real-time Messaging',
        'Built-in chat between NGOs, volunteers, and freelancers for seamless communication.'),
    (Icons.star_rounded, _kOrange, 'Review System',
        'Transparent reviews build trust. Both NGOs and contributors can rate their experiences.'),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final isTablet = w >= 768 && w < 1024;
    final columns = isMobile ? 1 : (isTablet ? 2 : 3);

    return _SectionWrapper(
      backgroundColor: _kBgLight,
      child: Column(
        key: sectionKey,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: _kBgAlt, borderRadius: BorderRadius.circular(50)),
            child: Text('PLATFORM FEATURES', style: GoogleFonts.inter(
              color: _kPrimary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5,
            )),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: const _SectionTitle(
              title: 'Everything You Need to Create Impact',
              subtitle: 'A complete platform built for NGOs, volunteers, and freelancers to collaborate effectively.',
            ),
          ),
          const SizedBox(height: 56),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 2.2 : (isTablet ? 1.6 : 1.5),
            ),
            itemCount: _features.length,
            itemBuilder: (context, index) {
              final f = _features[index];
              return _FeatureCard(icon: f.$1, color: f.$2, title: f.$3, description: f.$4);
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  const _FeatureCard({required this.icon, required this.color, required this.title, required this.description});
  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _hovered ? widget.color.withValues(alpha: 0.4) : _kBorder),
          boxShadow: [
            BoxShadow(
              color: _hovered ? widget.color.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.04),
              blurRadius: _hovered ? 20 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _hovered ? widget.color.withValues(alpha: 0.15) : widget.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: widget.color, size: 26),
            ),
            const SizedBox(height: 16),
            Text(widget.title, style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w700, color: _kTextPrimary,
            )),
            const SizedBox(height: 8),
            Expanded(
              child: Text(widget.description, style: GoogleFonts.inter(
                fontSize: 13.5, color: _kTextSecondary, height: 1.6,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────── HOW IT WORKS ────────────────────────
class _HowItWorksSection extends StatefulWidget {
  final GlobalKey sectionKey;
  const _HowItWorksSection({required this.sectionKey});
  @override
  State<_HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<_HowItWorksSection> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const _ngoSteps = [
    (Icons.business_center_rounded, 'Register your NGO', 'Sign up, complete your organisation profile, and submit verification documents.'),
    (Icons.add_task_rounded, 'Post a Task', 'Describe what you need — volunteer help or freelance expertise — and set milestones.'),
    (Icons.people_alt_rounded, 'Review Applicants', 'Browse AI-matched candidates. Review profiles, skills, and reviews before selecting.'),
    (Icons.track_changes_rounded, 'Track & Approve', 'Monitor progress through milestones. Approve deliverables and release payments.'),
  ];

  static const _volunteerSteps = [
    (Icons.person_add_alt_1_rounded, 'Create your Profile', 'Sign up as a volunteer, add your skills, and get verified through our skill quiz system.'),
    (Icons.search_rounded, 'Discover Opportunities', 'Browse tasks that match your interests and skills, or let AI suggest the best matches.'),
    (Icons.send_rounded, 'Apply & Get Accepted', 'Submit your application with a cover message. Track your application status in real-time.'),
    (Icons.emoji_events_rounded, 'Complete & Get Certified', 'Do great work, submit milestones, and earn digital certificates for your portfolio.'),
  ];

  static const _freelancerSteps = [
    (Icons.badge_rounded, 'Set up your Portfolio', 'Create a freelancer profile showcasing your professional skills, portfolio, and experience.'),
    (Icons.work_history_rounded, 'Find Paid Projects', 'Browse paid tasks posted by NGOs. Filter by skill, budget, and duration.'),
    (Icons.handshake_rounded, 'Agree on Milestones', 'Negotiate terms, set milestone payments, and start working with contract protection.'),
    (Icons.account_balance_wallet_rounded, 'Deliver & Get Paid', 'Submit milestone deliverables. Get paid automatically upon NGO approval.'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      key: widget.sectionKey,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxWidth),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: _kBgAlt, borderRadius: BorderRadius.circular(50)),
                child: Text('HOW IT WORKS', style: GoogleFonts.inter(
                  color: _kPrimary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5,
                )),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: const _SectionTitle(
                  title: 'Simple Steps to Get Started',
                  subtitle: 'Whether you\'re an NGO, volunteer, or freelancer — getting started takes minutes.',
                ),
              ),
              const SizedBox(height: 40),
              // Tab selector
              Container(
                decoration: BoxDecoration(
                  color: _kBgLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _kBorder),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: _kPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: _kTextSecondary,
                  labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
                  unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'For NGOs'),
                    Tab(text: 'For Volunteers'),
                    Tab(text: 'For Freelancers'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: isMobile ? 800 : 240,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _StepGrid(steps: _ngoSteps, isMobile: isMobile),
                    _StepGrid(steps: _volunteerSteps, isMobile: isMobile),
                    _StepGrid(steps: _freelancerSteps, isMobile: isMobile),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepGrid extends StatelessWidget {
  final List<(IconData, String, String)> steps;
  final bool isMobile;
  const _StepGrid({required this.steps, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: steps.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _StepCard(step: e.key + 1, icon: e.value.$1, title: e.value.$2, description: e.value.$3),
        )).toList(),
      );
    }
    return Row(
      children: steps.asMap().entries.expand((e) => [
        Expanded(child: _StepCard(step: e.key + 1, icon: e.value.$1, title: e.value.$2, description: e.value.$3)),
        if (e.key < steps.length - 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Icon(Icons.arrow_forward_rounded, color: _kPrimary.withValues(alpha: 0.3), size: 24),
          ),
      ]).toList(),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int step;
  final IconData icon;
  final String title;
  final String description;
  const _StepCard({required this.step, required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kBgLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: const BoxDecoration(color: _kPrimary, shape: BoxShape.circle),
                child: Center(child: Text('$step', style: GoogleFonts.inter(
                  color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14,
                ))),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: _kPrimary, size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: _kTextPrimary)),
          const SizedBox(height: 8),
          Text(description, style: GoogleFonts.inter(fontSize: 13, color: _kTextSecondary, height: 1.55)),
        ],
      ),
    );
  }
}

// ──────────────────────── MISSION SECTION ────────────────────────
class _MissionSection extends StatelessWidget {
  final GlobalKey sectionKey;
  const _MissionSection({required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kDarkBg, Color(0xFF1A3A1E), _kDarkBg],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxWidth),
          child: Column(
            children: [
              Text('Our Mission', style: GoogleFonts.inter(
                color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800,
              )),
              const SizedBox(height: 12),
              Text('Why GivTask exists and who we serve.', style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.65), fontSize: 17,
              )),
              const SizedBox(height: 56),
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Text(
                  'GivTask connects NGOs, Volunteers, and Freelancers to collaborate on meaningful volunteer opportunities and paid projects. We believe in helping communities while enabling users to develop skills, build their portfolios, and make a positive impact in the world.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500, height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────── BENEFITS SECTION ────────────────────────
class _BenefitsSection extends StatelessWidget {
  final GlobalKey sectionKey;
  const _BenefitsSection({required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return _SectionWrapper(
      backgroundColor: _kBgLight,
      child: Column(
        key: sectionKey,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50), border: Border.all(color: _kBorder)),
            child: Text('WHY GIVTASK', style: GoogleFonts.inter(
              color: _kPrimary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5,
            )),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: const _SectionTitle(
              title: 'Built for Everyone Who Wants to Make a Difference',
              subtitle: 'Specific benefits designed for each type of user on our platform.',
            ),
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  children: [
                    _BenefitCard(
                      icon: Icons.business_rounded, color: _kPrimary,
                      title: 'For NGOs', tagline: 'Find the talent you need.',
                      benefits: ['Access a pool of verified volunteers and freelancers', 'AI-powered skill matching saves you hours of searching', 'Post paid or unpaid tasks with ease', 'Milestone-based tracking ensures accountability', 'In-depth analytics on your organisation\'s impact', 'Build your NGO profile and attract top contributors'],
                    ),
                    const SizedBox(height: 24),
                    _BenefitCard(
                      icon: Icons.volunteer_activism_rounded, color: _kOrange,
                      title: 'For Volunteers', tagline: 'Contribute your skills. Grow your impact.',
                      benefits: ['Find meaningful opportunities that match your skills', 'Build a verifiable portfolio of impact work', 'Earn digital certificates for your contributions', 'Track volunteer hours for academic and professional use', 'Climb the leaderboard and get recognised', 'Network with NGOs and fellow changemakers'],
                    ),
                    const SizedBox(height: 24),
                    _BenefitCard(
                      icon: Icons.work_rounded, color: _kBlue,
                      title: 'For Freelancers', tagline: 'Do good work. Get paid fairly.',
                      benefits: ['Access exclusive freelance projects from mission-driven NGOs', 'Secure milestone-based payment structure', 'Build a portfolio that stands out from the crowd', 'Transparent reviews build your freelance reputation', 'Work flexibly from anywhere in the world', 'Manage invoices and earnings in one dashboard'],
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _BenefitCard(
                      icon: Icons.business_rounded, color: _kPrimary,
                      title: 'For NGOs', tagline: 'Find the talent you need.',
                      benefits: ['Access a pool of verified volunteers and freelancers', 'AI-powered skill matching saves hours', 'Post paid or unpaid tasks with ease', 'Milestone-based tracking ensures accountability', 'In-depth analytics on your impact', 'Build your NGO profile and attract contributors'],
                    )),
                    const SizedBox(width: 24),
                    Expanded(child: _BenefitCard(
                      icon: Icons.volunteer_activism_rounded, color: _kOrange,
                      title: 'For Volunteers', tagline: 'Contribute your skills. Grow your impact.',
                      benefits: ['Find opportunities that match your skills', 'Build a verifiable portfolio of impact work', 'Earn digital certificates for contributions', 'Track volunteer hours for professional use', 'Climb the leaderboard and get recognised', 'Network with NGOs and changemakers'],
                    )),
                    const SizedBox(width: 24),
                    Expanded(child: _BenefitCard(
                      icon: Icons.work_rounded, color: _kBlue,
                      title: 'For Freelancers', tagline: 'Do good work. Get paid fairly.',
                      benefits: ['Access exclusive NGO freelance projects', 'Secure milestone-based payment structure', 'Build a portfolio that stands out', 'Transparent reviews build your reputation', 'Work flexibly from anywhere', 'Manage invoices and earnings easily'],
                    )),
                  ],
                ),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String tagline;
  final List<String> benefits;
  const _BenefitCard({required this.icon, required this.color, required this.title, required this.tagline, required this.benefits});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 20),
          Text(title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: _kTextPrimary)),
          const SizedBox(height: 6),
          Text(tagline, style: GoogleFonts.inter(fontSize: 14, color: color, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          ...benefits.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 7, height: 7,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(b, style: GoogleFonts.inter(fontSize: 14, color: _kTextSecondary, height: 1.5))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}


// ──────────────────────── FAQ SECTION ────────────────────────
class _FaqSection extends StatelessWidget {
  final GlobalKey sectionKey;
  const _FaqSection({required this.sectionKey});

  static const _faqs = [
    ('Is GivTask free to use for volunteers?',
     'Yes! Volunteers can join GivTask, browse opportunities, apply for tasks, and receive certificates completely free. There are no hidden fees.'),
    ('How does GivTask verify NGOs?',
     'NGOs go through a verification process where they submit registration documents, tax-exempt status, and organisation details. Our team reviews and approves each NGO before they can post tasks.'),
    ('How are freelancers paid?',
     'Freelancers are paid through our secure milestone payment system. When an NGO approves a milestone deliverable, the payment is automatically released to the freelancer\'s wallet for withdrawal.'),
    ('Can I switch between being a volunteer and a freelancer?',
     'Yes! You can apply to both volunteer tasks (unpaid) and freelance projects (paid) on GivTask. Your profile clearly indicates your skills and preferences.'),
    ('What types of tasks can NGOs post?',
     'NGOs can post any skill-based task: website development, graphic design, data analysis, content writing, social media management, video production, legal support, accounting, and more.'),
    ('How does the AI matching work?',
     'Our AI analyses the skills required for a task, then cross-references them with verified user profiles, past work, quiz scores, and ratings to suggest the best-matched candidates.'),
    ('Are digital certificates recognised?',
     'GivTask certificates include a QR verification code and can be shared on LinkedIn, CVs, and portfolios. They are recognised by partner universities and corporate volunteer programs.'),
    ('What happens if there is a dispute?',
     'Our platform has a structured dispute resolution process. Both parties can submit evidence, and our moderation team will review and resolve the dispute within 5 business days.'),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      backgroundColor: _kBgLight,
      child: Column(
        key: sectionKey,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50), border: Border.all(color: _kBorder)),
            child: Text('FAQ', style: GoogleFonts.inter(
              color: _kPrimary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5,
            )),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: const _SectionTitle(
              title: 'Frequently Asked Questions',
              subtitle: 'Got questions? We\'ve got answers. If you don\'t find what you need, reach out to us.',
            ),
          ),
          const SizedBox(height: 56),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              children: _faqs.map((faq) => _FaqItem(question: faq.$1, answer: faq.$2)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _expanded ? _kPrimary.withValues(alpha: 0.3) : _kBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            title: Text(widget.question, style: GoogleFonts.inter(
              fontSize: 15.5, fontWeight: FontWeight.w600, color: _kTextPrimary,
            )),
            trailing: AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  color: _expanded ? _kPrimary : _kTextSecondary),
            ),
            onExpansionChanged: (v) => setState(() => _expanded = v),
            children: [
              Text(widget.answer, style: GoogleFonts.inter(
                fontSize: 14.5, color: _kTextSecondary, height: 1.7,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────── CONTACT SECTION ────────────────────────
class _ContactSection extends StatefulWidget {
  final GlobalKey sectionKey;
  const _ContactSection({required this.sectionKey});
  @override
  State<_ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<_ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _submitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      key: widget.sectionKey,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1628), Color(0xFF0A2B12), Color(0xFF0A1628)],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxWidth),
          child: isMobile
              ? Column(children: [_contactInfo(), const SizedBox(height: 48), _contactForm()])
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _contactInfo()),
                    const SizedBox(width: 60),
                    Expanded(child: _contactForm()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _contactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Get in Touch', style: GoogleFonts.inter(
          color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800, height: 1.2,
        )),
        const SizedBox(height: 16),
        Text(
          'Have questions about GivTask? We\'d love to hear from you. Send us a message and we\'ll respond within 24 hours.',
          style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.7), fontSize: 17, height: 1.65),
        ),
        const SizedBox(height: 40),
        ...[
          (Icons.email_rounded, 'Email Us', 'hello@givtask.org'),
          (Icons.location_on_rounded, 'Our Office', 'Mumbai, India & Remote'),
          (Icons.support_agent_rounded, 'Support Hours', 'Mon–Fri, 9am–6pm IST'),
        ].map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _kPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.$1, color: _kPrimaryLight, size: 22),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.$2, style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.5), fontSize: 12, fontWeight: FontWeight.w500)),
                  Text(item.$3, style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _contactForm() {
    if (_submitted) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, color: _kPrimaryLight, size: 64),
            const SizedBox(height: 20),
            Text('Message Sent!', style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text('Thank you for reaching out. We\'ll get back to you within 24 hours.', textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.7), fontSize: 15, height: 1.6)),
          ],
        ),
      );
    }

    final inputDeco = InputDecoration(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.08),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kPrimaryLight, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
      labelStyle: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.5)),
      hintStyle: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.3)),
    );

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameCtrl,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: inputDeco.copyWith(labelText: 'Your Name', prefixIcon: const Icon(Icons.person_outline, color: Colors.white54)),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              style: GoogleFonts.inter(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              decoration: inputDeco.copyWith(labelText: 'Email Address', prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54)),
              validator: (v) {
                if (v?.isEmpty ?? true) return 'Required';
                if (!v!.contains('@')) return 'Invalid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _msgCtrl,
              style: GoogleFonts.inter(color: Colors.white),
              maxLines: 4,
              decoration: inputDeco.copyWith(labelText: 'Your Message', alignLabelWithHint: true),
              validator: (v) => (v?.length ?? 0) < 10 ? 'Please enter at least 10 characters' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: Size.zero,
                ),
                child: Text('Send Message', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────── FOOTER ────────────────────────
class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      color: const Color(0xFF040D0A),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxWidth),
          child: Column(
            children: [
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _footerBrand(),
                        const SizedBox(height: 40),
                        ..._footerColumns(isMobile),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _footerBrand()),
                        const SizedBox(width: 40),
                        ..._footerColumns(isMobile).map((c) => Expanded(child: c)),
                      ],
                    ),
              const SizedBox(height: 48),
              Divider(color: Colors.white.withValues(alpha: 0.08)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                children: [
                  Text('© 2025 GivTask. All rights reserved.',
                      style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.4), fontSize: 13)),
                  if (!isMobile) Row(
                    children: [
                      _FooterLink('Privacy Policy', onTap: () {}),
                      _FooterLink('Terms of Service', onTap: () {}),
                      _FooterLink('Cookie Policy', onTap: () {}),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.volunteer_activism, color: _kPrimaryLight, size: 28),
            const SizedBox(width: 10),
            Text('GivTask', style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            'Connecting skilled individuals with NGOs that need their expertise. Create real impact with the skills you have.',
            style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.5), fontSize: 14, height: 1.7),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SocialIcon(Icons.language, onTap: () {}),
            const SizedBox(width: 8),
            _SocialIcon(Icons.link, onTap: () {}),
            const SizedBox(width: 8),
            _SocialIcon(Icons.alternate_email, onTap: () {}),
          ],
        ),
      ],
    );
  }

  List<Widget> _footerColumns(bool isMobile) {
    final columns = [
      ('Platform', ['For NGOs', 'For Volunteers', 'For Freelancers', 'Pricing', 'How It Works']),
      ('Company', ['About Us', 'Blog', 'Careers', 'Press', 'Contact']),
      ('Support', ['Help Center', 'Privacy Policy', 'Terms of Service', 'Cookie Policy', 'Status']),
    ];
    return columns.map((col) => Padding(
      padding: isMobile ? const EdgeInsets.only(bottom: 32) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(col.$1, style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ...col.$2.map((link) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _FooterLink(link, onTap: () {}),
          )),
        ],
      ),
    )).toList();
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink(this.label, {required this.onTap});
  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(widget.label, style: GoogleFonts.inter(
            color: _hovered ? _kPrimaryLight : Colors.white.withValues(alpha: 0.45),
            fontSize: 13.5,
            fontWeight: _hovered ? FontWeight.w500 : FontWeight.w400,
          )),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialIcon(this.icon, {required this.onTap});
  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _hovered ? _kPrimary.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Icon(widget.icon, color: _hovered ? _kPrimaryLight : Colors.white.withValues(alpha: 0.5), size: 18),
        ),
      ),
    );
  }
}
