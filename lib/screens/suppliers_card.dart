import 'package:flutter/material.dart';

import '../theme/pages_profiles.dart';
import 'home_screen.dart';
import 'person_card.dart';

class SuppliersCard extends StatelessWidget {
  static const String route = "${HomeScreen.route}/supplier_card";


  const SuppliersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PersonCard(
      tableName: "suppliers",
      color: const Color(0xFFFFA640),
      title: PagesProfiles.clients.enName,
      icon: Icons.person_add_rounded,
    );
  }
}
