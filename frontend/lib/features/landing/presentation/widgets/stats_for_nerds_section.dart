import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';

/// Stats For Nerds Section - Technical deep-dive for developers
/// Showcases the ML/AI architecture and implementation details
class StatsForNerdsSection extends StatelessWidget {
  const StatsForNerdsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 100,
      ),
      decoration: BoxDecoration(
        color: AppTheme.darkBg,
        border: Border(
          top: BorderSide(
            color: AppTheme.darkBorder.withOpacity(0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          _buildSectionHeader(isDesktop),
          const SizedBox(height: 60),
          _buildTechStack(isDesktop, isTablet),
          const SizedBox(height: 50),
          _buildMLPipeline(isDesktop, isTablet),
          const SizedBox(height: 50),
          _buildArchitectureDetails(isDesktop, isTablet),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDesktop) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.accentCyan.withOpacity(0.1),
            border: Border.all(
              color: AppTheme.accentCyan.withOpacity(0.3),
            ),
          ),
          child: const Text(
            'TECHNICAL SPECS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.accentCyan,
              letterSpacing: 1.5,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 24),
        Text(
          'Stats For Nerds 🤓',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 48 : 32,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimaryDark,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 100.ms)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isDesktop ? 700 : double.infinity),
          child: Text(
            'Diving deep into the ML/AI architecture, tech stack, and engineering decisions that power the platform. '
            '100% free for development and 100 users—no vendor lock-in.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              color: AppTheme.textSecondaryDark,
              height: 1.6,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildTechStack(bool isDesktop, bool isTablet) {
    return _buildNerdCard(
      title: '⚡ Tech Stack',
      isDesktop: isDesktop,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTechRow('Frontend', 'Flutter Web (CanvasKit)', AppTheme.primaryPurple),
          _buildTechRow('Backend', 'Go 1.24 (Chi Router, Clean Architecture)', AppTheme.accentCyan),
          _buildTechRow('Database', 'Supabase (PostgreSQL + Realtime + Auth)', AppTheme.success),
          _buildTechRow('Event Bus', 'NATS JetStream (Embedded)', AppTheme.warning),
          _buildTechRow('LLM', 'Groq API (Llama 3 70B @ 500 tok/s)', AppTheme.info),
          _buildTechRow('Vector DB', 'Chroma (embedded, no server needed)', Color(0xFF8B5CF6)),
          _buildTechRow('Embeddings', 'HuggingFace Inference (30K req/mo free)', AppTheme.accentPink),
          _buildTechRow('Search', 'Tavily AI (1K req/mo free)', AppTheme.success),
          _buildTechRow('Orchestration', 'LangChainGo (Go-native)', AppTheme.info),
          _buildTechRow('Deployment', 'Vercel (Frontend) + Render (Backend)', AppTheme.primaryPurple),
        ],
      ),
    );
  }

  Widget _buildMLPipeline(bool isDesktop, bool isTablet) {
    return _buildNerdCard(
      title: '🧠 ML/AI Pipeline',
      isDesktop: isDesktop,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPipelineStep(
            '1. RAG (Retrieval-Augmented Generation)',
            'Vector DB stores 50+ study techniques. User query → HuggingFace embeddings (all-MiniLM-L6-v2) → Chroma semantic search → Top 3 relevant docs → Context for LLM',
            Iconsax.book_1,
            AppTheme.success,
          ),
          const SizedBox(height: 16),
          _buildPipelineStep(
            '2. Internet Search Integration',
            'Goal created → Tavily AI searches latest courses/tutorials → Structured results (title, URL, content, score) → Merged with RAG context → Study plan includes web resources',
            Iconsax.search_normal_1,
            AppTheme.accentCyan,
          ),
          const SizedBox(height: 16),
          _buildPipelineStep(
            '3. LangChain Orchestration',
            'Chains: StudyPlanChain (RAG + Search + LLM) | NudgeChain (Prompt template + Groq) | Proper prompt engineering with variable injection',
            Iconsax.cpu,
            AppTheme.primaryPurple,
          ),
          const SizedBox(height: 16),
          _buildPipelineStep(
            '4. A/B Testing Framework',
            'Experiment variants stored in DB. Consistent hashing assigns users. Track impressions + conversions. Compare prompt effectiveness (baseline vs fine-tuned)',
            Iconsax.chart_square,
            AppTheme.warning,
          ),
          const SizedBox(height: 16),
          _buildPipelineStep(
            '5. Fine-Tuning Pipeline',
            'Export successful nudges (led to user action) → Format as JSONL instruction pairs → Train LoRA adapters on Llama 3 8B via Unsloth (Google Colab FREE GPU)',
            Iconsax.timer_1,
            AppTheme.accentPink,
          ),
          const SizedBox(height: 16),
          _buildPipelineStep(
            '6. Focus Coach Agent',
            'LLM with tool use: get_streak_info | get_goal_progress | get_focus_stats | search_study_tips. User asks "How am I doing?" → Agent queries DB → Returns data-driven insights',
            Iconsax.message_programming,
            AppTheme.info,
          ),
        ],
      ),
    );
  }

  Widget _buildArchitectureDetails(bool isDesktop, bool isTablet) {
    return _buildNerdCard(
      title: '🏗️ Architecture Highlights',
      isDesktop: isDesktop,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArchPoint('Clean Architecture', 'Handler → Service → Repository pattern. NATS event bus for async ops'),
          _buildArchPoint('RLS Everywhere', 'Row Level Security on all Supabase tables. Zero trust model'),
          _buildArchPoint('Realtime Presence', 'Supabase Channels for squad body doubling (WebSockets, not polling)'),
          _buildArchPoint('Wake Lock API', 'Screen stays on during focus sessions (Web API, mobile-friendly)'),
          _buildArchPoint('Tab Visibility Tracking', 'Page Visibility API auto-pauses sessions on tab switch'),
          _buildArchPoint('Event-Driven', 'NATS streams: activity.logged, streak.risk, squad.joined → Subscribers react'),
          _buildArchPoint('Breathing Animation', 'Pulsing circles + aurora gradient (4s cycle, 20s rotation) for focus ambiance'),
          _buildArchPoint('Zero-Cost ML', 'Embedded Chroma, free HuggingFace & Tavily tiers, Groq free tier (6K req/day)'),
        ],
      ),
    );
  }



  Widget _buildNerdCard({
    required String title,
    required bool isDesktop,
    required Widget content,
  }) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 40 : 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppTheme.darkSurface,
        border: Border.all(
          color: AppTheme.darkBorder.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isDesktop ? 28 : 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryDark,
            ),
          ),
          const SizedBox(height: 24),
          content,
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildTechRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryDark,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondaryDark,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineStep(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.darkCard,
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryDark,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Iconsax.tick_square,
            color: AppTheme.accentCyan,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryDark,
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: const TextStyle(
                      color: AppTheme.textSecondaryDark,
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
}
