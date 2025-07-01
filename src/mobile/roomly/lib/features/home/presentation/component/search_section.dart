import 'package:flutter/material.dart';
import 'package:roomly/features/GlobalWidgets/app_session.dart';
import 'package:roomly/features/auth/data/models/user_model.dart';

import '../widget/app_bar.dart';
import '../widget/search_bar.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/360-workspace-kita-e2-open-office (1).jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Color.fromARGB(127, 0, 0, 0), BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CustomAppBar(),
            const SizedBox(height: 20),
            _SalutationSection(),
            const SizedBox(height: 20),
            const CustomSearchBar(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SalutationSection extends StatelessWidget {
  const _SalutationSection();

  @override
  Widget build(BuildContext context) {
    final user = AppSession().currentUser;
    final firstName = user?.firstName;
    final greeting = firstName != null && firstName.isNotEmpty
        ? "Hello $firstName!"
        : "Hello there!";

    return _buildGreetingText(greeting);
  }

  Widget _buildGreetingText(String greeting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        const Text(
          "Tell us where you want to go",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }

}

  Widget _buildGreetingText(String greeting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        const Text(
          "Tell us where you want to go",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }


