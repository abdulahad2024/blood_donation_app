import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_donation_app/app/utils/constants/app_colors.dart';
import '../controllers/contact_controller.dart';

class ContactView extends GetView<ContactController> {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('যোগাযোগ করুন'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(
                  Icons.support_agent_rounded,
                  size: 60,
                  color: AppColors.primary
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "আমরা আপনাকে সাহায্য করতে প্রস্তুত",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "যেকোনো প্রশ্ন বা জরুরি প্রয়োজনে আমাদের সাথে যোগাযোগ করুন",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 30),

            _buildContactCard(
              context,
              title: "সরাসরি কল করুন",
              subtitle: "+8801885599144",
              icon: Icons.phone_forwarded_rounded,
              color: Colors.green,
              onTap: () => controller.makePhoneCall("+8801885599144"),
            ),

            _buildContactCard(
              context,
              title: "ফেসবুক পেজ",
              subtitle: "fahimarfa247",
              icon: Icons.facebook_rounded,
              color: Colors.blue,
              onTap: () => controller.launchWebsite("https://www.facebook.com/fahimarfa247"),
            ),

            const SizedBox(height: 40),

            Text(
              "ভার্সন: ১.০.০",
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: isDark ? Colors.white30 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isDark ? 0 : 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      color: theme.cardColor,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        trailing: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: isDark ? Colors.white24 : Colors.black26
        ),
      ),
    );
  }
}