import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  Future<void> _logout(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair da conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await StorageService.clearCurrentUser();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = user.role == 'admin';
    final roleLabel = isAdmin ? 'Administrador' : 'Recepcionista';
    final roleColor = isAdmin ? Colors.purple : const Color(0xFF0D47A1);
    final roleIcon = isAdmin ? Icons.admin_panel_settings : Icons.badge;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF0D47A1),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Nome
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),

          const SizedBox(height: 8),

          // Badge de perfil
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: roleColor.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: roleColor.withAlpha(80)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(roleIcon, size: 16, color: roleColor),
                const SizedBox(width: 6),
                Text(
                  roleLabel,
                  style: TextStyle(
                    color: roleColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Informações do usuário
          _buildInfoTile(
            icon: Icons.email,
            label: 'E-mail',
            value: user.email,
          ),
          const SizedBox(height: 12),
          _buildInfoTile(
            icon: Icons.church,
            label: 'Igreja',
            value: user.church,
          ),

          const SizedBox(height: 40),

          // Botão Sair
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Sair da Conta',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0D47A1), size: 22),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
