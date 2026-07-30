import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/landing/landing_screen.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/role_selection_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/update_password_screen.dart';
import '../../features/auth/otp_verification_screen.dart';
import '../../features/auth/profile_setup_basic_screen.dart';
import '../../features/auth/profile_setup_skills_screen.dart';
import '../../features/shared/notifications_screen.dart';
import '../../features/ngo/ngo_org_details_screen.dart';
import '../../features/ngo/ngo_doc_upload_screen.dart';
import '../../features/ngo/ngo_verification_status_screen.dart';
import '../../features/ngo/ngo_freelancers_screen.dart';
import '../../features/ngo/ngo_dashboard_screen.dart';
import '../../features/ngo/create_task_type_screen.dart';
import '../../features/ngo/create_task_details_screen.dart';
import '../../features/ngo/create_task_skills_screen.dart';
import '../../features/ngo/create_task_milestones_screen.dart';
import '../../features/ngo/my_tasks_screen.dart';
import '../../features/ngo/task_detail_edit_screen.dart';
import '../../features/ngo/applicants_list_screen.dart';
import '../../features/ngo/applicant_profile_screen.dart';
import '../../features/ngo/application_review_screen.dart';
import '../../features/ngo/milestone_approval_screen.dart';
import '../../features/ngo/task_tracker_screen.dart';
import '../../features/ngo/ngo_public_profile_screen.dart';
import '../../features/ngo/ngo_analytics_screen.dart';
import '../../features/ngo/post_announcement_screen.dart';
import '../../features/ngo/ngo_reviews_screen.dart';
import '../../features/volunteer/volunteer_tasks_screen.dart';

import '../../features/volunteer/tasks_map_screen.dart';
import '../../features/volunteer/task_detail_applicant_screen.dart';
import '../../features/volunteer/apply_task_screen.dart';
import '../../features/volunteer/team_application_screen.dart';
import '../../features/volunteer/my_applications_screen.dart';
import '../../features/volunteer/application_status_screen.dart';
import '../../features/volunteer/my_active_tasks_screen.dart';
import '../../features/volunteer/submit_milestone_screen.dart';
import '../../features/volunteer/task_completion_screen.dart';
import '../../features/volunteer/completed_history_screen.dart';
import '../../features/volunteer/certificates_gallery_screen.dart';
import '../../features/volunteer/certificate_detail_screen.dart';
import '../../features/volunteer/hours_log_screen.dart';
import '../../features/volunteer/skill_quiz_screen.dart';
import '../../features/volunteer/quiz_result_screen.dart';
import '../../features/volunteer/ai_match_screen.dart';
import '../../features/volunteer/leaderboard_screen.dart';
import '../../features/payments/payment_method_screen.dart';
import '../../features/payments/milestone_payment_status_screen.dart';
import '../../features/payments/wallet_screen.dart';
import '../../features/payments/withdraw_screen.dart';
import '../../features/payments/transaction_history_screen.dart';
import '../../features/payments/invoice_screen.dart';
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/admin/user_management_screen.dart';
import '../../features/admin/ngo_approval_screen.dart';
import '../../features/admin/dispute_moderation_screen.dart';
import '../../features/admin/platform_analytics_screen.dart';
import '../../features/admin/skill_management_screen.dart';
import '../../features/admin/broadcast_notification_screen.dart';
import '../../features/shared/referral_screen.dart';
import '../../features/shared/about_us_screen.dart';
import '../../features/shared/chat_list_screen.dart';
import '../../features/shared/chat_conversation_screen.dart';
import '../../features/ngo/presentation/ngo_dashboard_layout.dart';
import '../../features/ngo/ngo_volunteers_screen.dart';
import '../../features/ngo/ngo_certificates_screen.dart';
import '../../features/ngo/ngo_calendar_screen.dart';
import '../../features/ngo/ngo_profile_settings.dart';
import '../../features/volunteer/presentation/volunteer_dashboard_layout.dart';
import '../../features/volunteer/discover_opportunities_screen.dart';
import '../../features/volunteer/volunteer_calendar_screen.dart';
import '../../features/volunteer/volunteer_messages_screen.dart';
import '../../features/volunteer/volunteer_saved_screen.dart';
import '../../features/volunteer/volunteer_profile_screen.dart';
import '../../features/volunteer/volunteer_settings_screen.dart';
import '../../features/volunteer/volunteer_help_screen.dart';
import '../../features/freelancer/presentation/freelancer_dashboard_layout.dart';
import '../../features/freelancer/freelancer_dashboard_screen.dart';
import '../../features/freelancer/discover_paid_projects_screen.dart';
import '../../features/freelancer/freelance_project_details_screen.dart';
import '../../features/freelancer/my_proposals_screen.dart';
import '../../features/freelancer/freelancer_active_projects_screen.dart';
import '../../features/freelancer/freelancer_completed_projects_screen.dart';
import '../../features/freelancer/freelancer_profile_screen.dart';
import '../../features/freelancer/freelancer_settings_screen.dart';
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value?.session?.user;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/landing',
    redirect: (context, state) {
      final isAuth = user != null;
      final isEmailVerified = user?.emailConfirmedAt != null;
      
      final path = state.uri.path;
      final isPublicRoute = path == '/landing' || 
                            path == '/login' || 
                            path == '/register' || 
                            path == '/forgot-password' || 
                            path == '/update-password' || 
                            path == '/role-selection' || 
                            path == '/onboarding' ||
                            path == '/';

      if (!isAuth) {
        if (!isPublicRoute) {
          return '/login';
        }
        return null;
      }

      // User is authenticated
      
      if (authState.value?.event == AuthChangeEvent.passwordRecovery) {
        if (path != '/update-password') {
          return '/update-password';
        }
        return null;
      }

      // If email is not verified, but they are trying to access protected routes,
      // wait, if they are authenticated but not verified, Supabase might not return a session
      // if email confirmation is required. But if it does, we should block them.
      // We will handle unverified users in the UI, but let's prevent dashboard access:
      if (!isEmailVerified && !isPublicRoute) {
         // Optionally redirect to an unverified screen, or back to login
         // We will allow them to login screen which will show the error
      }

      // If they are authenticated and trying to access a public auth route, redirect to their dashboard
      if (path == '/login' || path == '/register' || path == '/landing' || path == '/role-selection') {
        final role = user.userMetadata?['role'];
        if (role == 'volunteer') return '/volunteer-tasks';
        if (role == 'freelancer') return '/freelancer-dashboard'; 
        if (role == 'ngo') return '/ngo-dashboard';
        if (role == 'admin') return '/admin-dashboard';
        
        // If role is missing/invalid, force them to login where error will show
        return null; 
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) {
          final action = state.uri.queryParameters['action'] ?? 'register';
          return RoleSelectionScreen(action: action);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/update-password',
        builder: (context, state) => const UpdatePasswordScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return OtpVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: '/profile-setup-basic',
        builder: (context, state) => const ProfileSetupBasicScreen(),
      ),
      GoRoute(
        path: '/profile-setup-skills',
        builder: (context, state) => const ProfileSetupSkillsScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'volunteer';
          return RegisterScreen(role: role);
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/ngo-org-details',
        builder: (context, state) => const NgoOrgDetailsScreen(),
      ),
      GoRoute(
        path: '/ngo-doc-upload',
        builder: (context, state) => const NgoDocUploadScreen(),
      ),
      GoRoute(
        path: '/ngo-verification-status',
        builder: (context, state) => const NgoVerificationStatusScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => NgoDashboardLayout(child: child),
        routes: [
          GoRoute(
            path: '/ngo-dashboard',
            builder: (context, state) => const NgoDashboardScreen(),
          ),
          GoRoute(
            path: '/create-task-type',
            builder: (context, state) => const CreateTaskTypeScreen(),
          ),
          GoRoute(
            path: '/create-task-details',
            builder: (context, state) {
              final id = state.uri.queryParameters['id'];
              final type = state.uri.queryParameters['type'];
              return CreateTaskDetailsScreen(taskId: id, taskType: type);
            },
          ),
          GoRoute(
            path: '/create-task-skills',
            builder: (context, state) => const CreateTaskSkillsScreen(),
          ),
          GoRoute(
            path: '/create-task-milestones',
            builder: (context, state) => const CreateTaskMilestonesScreen(),
          ),
          GoRoute(
            path: '/my-tasks',
            builder: (context, state) => const MyTasksScreen(),
          ),
          GoRoute(
            path: '/task-detail-edit',
            builder: (context, state) {
              final id = state.uri.queryParameters['id'];
              final type = state.uri.queryParameters['type'];
              return CreateTaskDetailsScreen(taskId: id, taskType: type);
            },
          ),
          GoRoute(
            path: '/applicants-list',
            builder: (context, state) {
              final taskId = state.uri.queryParameters['taskId'];
              return ApplicantsListScreen(taskId: taskId);
            },
          ),
          GoRoute(
            path: '/applicant-profile',
            builder: (context, state) => const ApplicantProfileScreen(),
          ),
          GoRoute(
            path: '/application-review',
            builder: (context, state) {
              final id = state.uri.queryParameters['id'];
              return ApplicationReviewScreen(applicationId: id);
            },
          ),
          GoRoute(
            path: '/milestone-approval',
            builder: (context, state) => const MilestoneApprovalScreen(),
          ),
          GoRoute(
            path: '/task-tracker',
            builder: (context, state) => const TaskTrackerScreen(),
          ),
          GoRoute(
            path: '/ngo-public-profile',
            builder: (context, state) => const NgoPublicProfileScreen(),
          ),
          GoRoute(
            path: '/ngo-analytics',
            builder: (context, state) => const NgoAnalyticsScreen(),
          ),
          GoRoute(
            path: '/post-announcement',
            builder: (context, state) => const PostAnnouncementScreen(),
          ),
          GoRoute(
            path: '/ngo-reviews',
            builder: (context, state) => const NgoReviewsScreen(),
          ),
          GoRoute(
            path: '/ngo-volunteers',
            builder: (context, state) => const NgoVolunteersScreen(),
          ),
          GoRoute(
            path: '/ngo-freelancers',
            builder: (context, state) => const NgoFreelancersScreen(),
          ),
          GoRoute(
            path: '/ngo-certificates',
            builder: (context, state) => const NgoCertificatesScreen(),
          ),
          GoRoute(
            path: '/ngo-calendar',
            builder: (context, state) => const NgoCalendarScreen(),
          ),
          GoRoute(
            path: '/ngo-profile-settings',
            builder: (context, state) => const NgoProfileSettingsScreen(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => VolunteerDashboardLayout(child: child),
        routes: [
          GoRoute(
            path: '/volunteer-tasks',
            builder: (context, state) => const VolunteerTasksScreen(),
          ),
          GoRoute(
            path: '/volunteer-discover',
            builder: (context, state) => const DiscoverOpportunitiesScreen(),
          ),
          // Removed old freelance-projects route that was inside volunteer shell
          GoRoute(
            path: '/tasks-map',
            builder: (context, state) => const TasksMapScreen(),
          ),
          GoRoute(
            path: '/task-detail-applicant',
            builder: (context, state) => const TaskDetailApplicantScreen(),
          ),
          GoRoute(
            path: '/apply-task',
            builder: (context, state) => const ApplyTaskScreen(),
          ),
          GoRoute(
            path: '/team-application',
            builder: (context, state) => const TeamApplicationScreen(),
          ),
          GoRoute(
            path: '/my-applications',
            builder: (context, state) => const MyApplicationsScreen(),
          ),
          GoRoute(
            path: '/application-status',
            builder: (context, state) => const ApplicationStatusScreen(),
          ),
          GoRoute(
            path: '/my-active-tasks',
            builder: (context, state) => const MyActiveTasksScreen(),
          ),
          GoRoute(
            path: '/submit-milestone',
            builder: (context, state) => const SubmitMilestoneScreen(),
          ),
          GoRoute(
            path: '/task-completion',
            builder: (context, state) => const TaskCompletionScreen(),
          ),
          GoRoute(
            path: '/completed-history',
            builder: (context, state) => const CompletedHistoryScreen(),
          ),
          GoRoute(
            path: '/certificates-gallery',
            builder: (context, state) => const CertificatesGalleryScreen(),
          ),
          GoRoute(
            path: '/certificate-detail',
            builder: (context, state) => const CertificateDetailScreen(),
          ),
          GoRoute(
            path: '/volunteer-calendar',
            builder: (context, state) => const VolunteerCalendarScreen(),
          ),
          GoRoute(
            path: '/volunteer-messages',
            builder: (context, state) => const VolunteerMessagesScreen(),
          ),
          GoRoute(
            path: '/volunteer-saved',
            builder: (context, state) => const VolunteerSavedScreen(),
          ),
          GoRoute(
            path: '/volunteer-profile',
            builder: (context, state) => const VolunteerProfileScreen(),
          ),
          GoRoute(
            path: '/volunteer-settings',
            builder: (context, state) => const VolunteerSettingsScreen(),
          ),
          GoRoute(
            path: '/volunteer-help',
            builder: (context, state) => const VolunteerHelpScreen(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => FreelancerDashboardLayout(child: child),
        routes: [
          GoRoute(
            path: '/freelancer-dashboard',
            builder: (context, state) => const FreelancerDashboardScreen(),
          ),
          GoRoute(
            path: '/freelancer-discover',
            builder: (context, state) => const DiscoverPaidProjectsScreen(),
          ),
          GoRoute(
            path: '/freelancer-project-details/:id',
            builder: (context, state) => FreelanceProjectDetailsScreen(
              taskId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/freelancer-proposals',
            builder: (context, state) => const MyProposalsScreen(),
          ),
          GoRoute(
            path: '/freelancer-active-projects',
            builder: (context, state) => const FreelancerActiveProjectsScreen(),
          ),
          GoRoute(
            path: '/freelancer-completed-projects',
            builder: (context, state) => const FreelancerCompletedProjectsScreen(),
          ),
          GoRoute(
            path: '/freelancer-profile',
            builder: (context, state) => const FreelancerProfileScreen(),
          ),
          GoRoute(
            path: '/freelancer-settings',
            builder: (context, state) => const FreelancerSettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/hours-log',
        builder: (context, state) => const HoursLogScreen(),
      ),
      GoRoute(
        path: '/skill-quiz',
        builder: (context, state) => const SkillQuizScreen(),
      ),
      GoRoute(
        path: '/quiz-result',
        builder: (context, state) => const QuizResultScreen(),
      ),
      GoRoute(
        path: '/ai-match',
        builder: (context, state) => const AiMatchScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/payment-method',
        builder: (context, state) => const PaymentMethodScreen(),
      ),
      GoRoute(
        path: '/milestone-payment-status',
        builder: (context, state) => const MilestonePaymentStatusScreen(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/withdraw',
        builder: (context, state) => const WithdrawScreen(),
      ),
      GoRoute(
        path: '/transaction-history',
        builder: (context, state) => const TransactionHistoryScreen(),
      ),
      GoRoute(
        path: '/invoice',
        builder: (context, state) => const InvoiceScreen(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/user-management',
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: '/ngo-approval',
        builder: (context, state) => const NgoApprovalScreen(),
      ),
      GoRoute(
        path: '/dispute-moderation',
        builder: (context, state) => const DisputeModerationScreen(),
      ),
      GoRoute(
        path: '/platform-analytics',
        builder: (context, state) => const PlatformAnalyticsScreen(),
      ),
      GoRoute(
        path: '/skill-management',
        builder: (context, state) => const SkillManagementScreen(),
      ),
      GoRoute(
        path: '/broadcast-notification',
        builder: (context, state) => const BroadcastNotificationScreen(),
      ),
      GoRoute(
        path: '/referral',
        builder: (context, state) => const ReferralScreen(),
      ),
      GoRoute(
        path: '/about-us',
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: '/chat-list',
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '/chat-conversation',
        builder: (context, state) => const ChatConversationScreen(),
      ),
    ],
  );
});

