import 'package:flutter/material.dart';
import '../models/culto.dart';
import '../services/storage_service.dart';
import 'add_culto_screen.dart';
import 'culto_details_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Culto> cultos = [];

  @override
  void initState() {
    super.initState();
    _carregarCultos();
  }

  Future<void> _carregarCultos() async {
    cultos = await StorageService.loadCultos();
    setState(() {});
  }

  Future<void> _adicionarCulto() async {
    final Culto? novoCulto = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCultoScreen(),
      ),
    );

    if (novoCulto != null) {
      cultos.add(novoCulto);
      await StorageService.saveCultos(cultos);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),
        title: const Text('SmartCulto'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildHomeBody() : const ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0D47A1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Bem-vindo ao SmartCulto',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _adicionarCulto,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Culto'),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: cultos.isEmpty
                ? const Center(
                    child: Text('Nenhum culto cadastrado.'),
                  )
                : ListView.builder(
                    itemCount: cultos.length,
                    itemBuilder: (context, index) {
                      final culto = cultos[index];

                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.church,
                            color: Color(0xFF0D47A1),
                          ),
                          title: Text(culto.nome),
                          subtitle:
                              Text('${culto.data} às ${culto.hora}'),
                          trailing:
                              const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CultoDetailsScreen(culto: culto),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}