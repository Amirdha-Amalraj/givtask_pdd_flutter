import os
import re

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

for screen in screens:
    path = os.path.join('lib', screen)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    
    filename = os.path.basename(screen)
    basename = filename.replace('.dart', '')
    class_name = to_camel_case(basename)
    
    content = f"""import 'package:flutter/material.dart';

class {class_name} extends StatelessWidget {{
  const {class_name}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(title: const Text('{class_name}')),
      body: const Center(child: Text('{class_name} Placeholder')),
    );
  }}
}}
"""
    with open(path, 'w') as f:
        f.write(content)
        
print("Successfully generated files.")
