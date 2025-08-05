import 'package:flutter/material.dart';

import '../theme/home_pages_profiles.dart';
import 'home_screen.dart';
import 'person_card.dart';

class ClientsCard extends StatelessWidget {
  static const String route = "${HomeScreen.route}/client_card";
  const ClientsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PersonCard(
      tableName: "clients",
      color: Theme.of(context).primaryColor,
      title: HomePagesProfiles.clients.arName,
      icon: Icons.supervisor_account,
    );
  }
}
