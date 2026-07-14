import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/helpers/contact_helper.dart';
import '../controllers/help_question_controller.dart';

class HelpQuestionView extends GetView<HelpQuestionController> {
  const HelpQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryRed = const Color(0xFFE53935);
    final lightRed = const Color(0xFFFFEBEE);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'সহায়তা কেন্দ্র',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildFancyBanner(primaryRed, context),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("আপনার জিজ্ঞাসা", Icons.auto_awesome, context),
                  const SizedBox(height: 15),
                  _buildFriendlyFAQ(
                    context: context,
                    question: "রক্তদান কেন করবেন?",
                    answer:
                        "আপনার এক ব্যাগ রক্ত বাঁচাতে পারে তিনটি প্রাণ। এটি একটি মহৎ কাজ যা সমাজ ও মানবতার উপকারে আসে।",
                    icon: Icons.favorite_rounded,
                    color: primaryRed,
                  ),
                  _buildFriendlyFAQ(
                    context: context,
                    question: "বয়স ও ওজনের নিয়ম কী?",
                    answer:
                        "১৮-৬০ বছর বয়স এবং অন্তত ৫০ কেজি ওজন থাকা প্রয়োজন। শারীরিক সুস্থতা সবচেয়ে জরুরি।",
                    icon: Icons.monitor_weight_rounded,
                    color: Colors.orange,
                  ),
                  _buildFriendlyFAQ(
                    context: context,
                    question: "কতদিন পর পর রক্ত দেওয়া যায়?",
                    answer:
                        "সাধারণত প্রতি ৩ মাস বা ৯০ দিন পরপর আপনি নিরাপদে রক্তদান করতে পারবেন।",
                    icon: Icons.event_available_rounded,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 30),

                  // Support action card
                  _buildActionCard(theme, primaryRed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFancyBanner(Color color, BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(
              Icons.volunteer_activism_rounded,
              size: 45,
              color: color,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'কেমন আছেন? আপনাকে কীভাবে সাহায্য করতে পারি?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildFriendlyFAQ({
    required String question,
    required String answer,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.1), width: 1.5),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          title: Text(question, style: Theme.of(context).textTheme.titleMedium),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 70, right: 20, bottom: 20),
              child: Text(answer),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(ThemeData theme, Color primaryRed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryRed, const Color(0xFFFF5252)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'সরাসরি কথা বলতে চান?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'আমাদের টিম আপনার কলের অপেক্ষায় আছে।',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            onPressed: () {
              ContactHelper.makeCall("+8801885599144");
            },
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.call, color: primaryRed),
                const SizedBox(width: 10),
                Text(
                  'কল করুন',
                  style: TextStyle(
                    color: primaryRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
