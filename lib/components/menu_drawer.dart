import 'package:app_firebase/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  final User user;
  const MenuDrawer({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                  'https://pixabay.com/pt/vectors/homem-de-negocios-macho-o-neg%C3%B3cio-310819/'),
              child: Icon(
                Icons.manage_accounts_rounded,
                size: 48,
              ),
            ),
            accountName:
                Text((user.displayName != null) ? user.displayName! : ''),
            accountEmail: Text(user.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () => AuthService().logout(),
          ),
        ],
      ),
    );
  }
}
