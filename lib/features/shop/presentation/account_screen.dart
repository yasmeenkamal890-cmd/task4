import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../home/presentation/home_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) => MainShell(
        currentRoute: AppRoutes.account,
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final user = state.user;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('My Account', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                CircleAvatar(radius: 42, backgroundColor: const Color(0xFFEAF7FF),
                  backgroundImage: user != null && user.image.isNotEmpty ? NetworkImage(user.image) : null,
                  child: user == null ? const Icon(Icons.person, size: 42) : null),
                const SizedBox(height: 12),
                Text(user == null ? 'Guest' : '${user.firstName} ${user.lastName}',
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(user?.email ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                Card(child: ListTile(leading: const Icon(Icons.favorite_border), title: const Text('Favorites'),
                  trailing: const Icon(Icons.chevron_right), onTap: () => context.go(AppRoutes.favorites))),
                Card(child: ListTile(leading: const Icon(Icons.shopping_bag_outlined), title: const Text('My Cart'),
                  trailing: const Icon(Icons.chevron_right), onTap: () => context.go(AppRoutes.cart))),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                    context.goNamed('login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign out'),
                ),
              ],
            );
          },
        ),
      );
}
