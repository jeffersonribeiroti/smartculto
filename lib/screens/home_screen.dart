import 'package:flutter/material.dart';
import '../models/culto.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import 'add_culto_screen.dart';
import 'culto_details_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userRole; // 'admin' ou 'recepcionista'
  final String userName;

  const HomeScreen({
    super.key,
    this.userRole = 'recepcionista',
    this.userName = '',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Culto> _cultos = [];
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final cultos = await StorageService.loadCultos();
    final user = await StorageService.loadCurrentUser();
    setState(() {
      _cultos = cultos;
      _currentUser = user;
    });
  }

  Future<void> _adicionarCulto() async {
    final Culto? novoCulto = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCultoScreen()),
    );

    if (novoCulto != null) {
      _cultos.add(novoCulto);
      await StorageService.saveCultos(_cultos);
      setState(() {});
    }
  }

  void _abrirCulto(Culto culto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CultoDetailsScreen(
          culto: culto,
          userRole: widget.userRole,
          todosCultos: _cultos,
        ),
      ),
    ).then((_) {
      // Recarrega ao voltar para garantir visitantes atualizados
      _carregarDados();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.userRole == 'admin';

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF0D47A1),
            child: Text(
              widget.userName.isNotEmpty
                  ? widget.userName[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: const Text('SmartCulto'),
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? _buildHomeBody(isAdmin)
          : _buildProfileBody(),
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
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  Widget _buildHomeBody(bool isAdmin) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Saudação
          Text(
            'Olá, ${widget.userName.isNotEmpty ? widget.userName.split(' ').first : 'Usuário'}!',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          Text(
            isAdmin ? 'Perfil: Administrador' : 'Perfil: Recepcionista',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),

          const SizedBox(height: 20),

          // Botão Adicionar Culto — apenas Recepcionista (RF 9)
          if (!isAdmin) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _adicionarCulto,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Novo Culto'),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Título da seção de cultos
          Row(
            children: [
              const Text(
                'Cultos Adicionados',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_cultos.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Lista de cultos
          Expanded(
            child: _cultos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.church_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Nenhum culto cadastrado.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        if (!isAdmin) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Toque em "Adicionar Novo Culto" para começar.',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _cultos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final culto = _cultos[index];
                      final totalVisitantes = culto.visitantes.length;

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFE3F2FD),
                            child: Icon(
                              Icons.church,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          title: Text(
                            culto.tipo,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${culto.data} às ${culto.hora}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$totalVisitantes',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D47A1),
                                ),
                              ),
                              const Text(
                                'visitantes',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                          onTap: () => _abrirCulto(culto),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBody() {
    if (_currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ProfileScreen(user: _currentUser!);
  }
}
