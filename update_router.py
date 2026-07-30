import os

screens = [
    "features/ngo/ngo_dashboard_screen.dart",
    "features/ngo/create_task_type_screen.dart",
    "features/ngo/create_task_details_screen.dart",
    "features/ngo/create_task_skills_screen.dart",
    "features/ngo/create_task_milestones_screen.dart",
    "features/ngo/my_tasks_screen.dart",
    "features/ngo/task_detail_edit_screen.dart",
    "features/ngo/applicants_list_screen.dart",
    "features/ngo/applicant_profile_screen.dart",
    "features/ngo/application_review_screen.dart",
    "features/ngo/milestone_approval_screen.dart",
    "features/ngo/task_tracker_screen.dart",
    "features/ngo/ngo_public_profile_screen.dart",
    "features/ngo/ngo_analytics_screen.dart",
    "features/ngo/post_announcement_screen.dart",
    "features/ngo/ngo_reviews_screen.dart",
    
    "features/volunteer/volunteer_tasks_screen.dart",
    "features/volunteer/freelance_projects_screen.dart",
    "features/volunteer/tasks_map_screen.dart",
    "features/volunteer/task_detail_applicant_screen.dart",
    "features/volunteer/apply_task_screen.dart",
    "features/volunteer/team_application_screen.dart",
    "features/volunteer/my_applications_screen.dart",
    "features/volunteer/application_status_screen.dart",
    "features/volunteer/my_active_tasks_screen.dart",
    "features/volunteer/submit_milestone_screen.dart",
    "features/volunteer/task_completion_screen.dart",
    "features/volunteer/completed_history_screen.dart",
    "features/volunteer/certificates_gallery_screen.dart",
    "features/volunteer/certificate_detail_screen.dart",
    "features/volunteer/hours_log_screen.dart",
    "features/volunteer/skill_quiz_screen.dart",
    "features/volunteer/quiz_result_screen.dart",
    "features/volunteer/ai_match_screen.dart",
    "features/volunteer/leaderboard_screen.dart",
    
    "features/payments/payment_method_screen.dart",
    "features/payments/milestone_payment_status_screen.dart",
    "features/payments/wallet_screen.dart",
    "features/payments/withdraw_screen.dart",
    "features/payments/transaction_history_screen.dart",
    "features/payments/invoice_screen.dart",
    
    "features/admin/admin_dashboard_screen.dart",
    "features/admin/user_management_screen.dart",
    "features/admin/ngo_approval_screen.dart",
    "features/admin/dispute_moderation_screen.dart",
    "features/admin/platform_analytics_screen.dart",
    "features/admin/skill_management_screen.dart",
    "features/admin/broadcast_notification_screen.dart",
    
    "features/shared/referral_screen.dart",
    "features/shared/about_us_screen.dart",
    "features/shared/chat_list_screen.dart",
    "features/shared/chat_conversation_screen.dart"
]

def to_camel_case(snake_str):
    components = snake_str.split('_')
    return ''.join(x.title() for x in components)

imports = []
routes = []

for screen in screens:
    basename = os.path.basename(screen)
    route_name = basename.replace('_screen.dart', '').replace('_', '-')
    class_name = to_camel_case(basename.replace('.dart', ''))
    
    imports.append(f"import '../../{screen}';")
    routes.append(f"""      GoRoute(
        path: '/{route_name}',
        builder: (context, state) => const {class_name}(),
      ),""")

router_path = "lib/core/routing/app_router.dart"

with open(router_path, 'r') as f:
    content = f.read()

# Insert imports
import_block = "\n".join(imports)
content = content.replace("import '../../features/ngo/ngo_verification_status_screen.dart';", f"import '../../features/ngo/ngo_verification_status_screen.dart';\n{import_block}")

# Insert routes
route_block = "\n".join(routes)
content = content.replace("      GoRoute(\n        path: '/ngo-verification-status',\n        builder: (context, state) => const NgoVerificationStatusScreen(),\n      ),", f"      GoRoute(\n        path: '/ngo-verification-status',\n        builder: (context, state) => const NgoVerificationStatusScreen(),\n      ),\n{route_block}")

with open(router_path, 'w') as f:
    f.write(content)

print("Updated app_router.dart")
