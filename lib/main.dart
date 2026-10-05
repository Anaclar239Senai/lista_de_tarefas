import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool modoEscuro = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minhas Tarefas',

      theme: ThemeData(
        useMaterial3: true,
        brightness:
            modoEscuro ? Brightness.dark : Brightness.light,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8E6CCF),
          brightness:
              modoEscuro ? Brightness.dark : Brightness.light,
        ),

        scaffoldBackgroundColor:
            modoEscuro
                ? const Color(0xFF17141C)
                : const Color(0xFFF7F4FB),

        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor:
              modoEscuro
                  ? const Color(0xFF241D2E)
                  : const Color(0xFF8E6CCF),
          foregroundColor: Colors.white,
        ),

        cardTheme: CardThemeData(
          elevation: 1,
          color:
              modoEscuro
                  ? const Color(0xFF26212D)
                  : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 7,
          ),
        ),

        floatingActionButtonTheme:
            FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF8E6CCF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),

      home: TarefaScreen(
        modoEscuro: modoEscuro,
        onTemaAlterado: () {
          setState(() {
            modoEscuro = !modoEscuro;
          });
        },
      ),
    );
  }
}

// POO - Classe Tarefa
class Tarefa {
  final String id;
  String titulo;
  bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = false,
  });
}

class TarefaScreen extends StatefulWidget {
  final bool modoEscuro;
  final VoidCallback onTemaAlterado;

  const TarefaScreen({
    super.key,
    required this.modoEscuro,
    required this.onTemaAlterado,
  });

  @override
  State<TarefaScreen> createState() => _TarefaScreen();
}

class _TarefaScreen extends State<TarefaScreen> {
  final List<Tarefa> _tarefas = [
    Tarefa(
      id: '1',
      titulo: 'Comprar pão, leite e ovo',
    ),
    Tarefa(
      id: '2',
      titulo: 'Responder e-mails do trabalho',
      concluida: true,
    ),
    Tarefa(
      id: '3',
      titulo: 'Academia às 18h',
    ),
  ];

  final TextEditingController _controller =
      TextEditingController();

  int get tarefasConcluidas =>
      _tarefas.where((t) => t.concluida).length;

  int get tarefasPendentes =>
      _tarefas.where((t) => !t.concluida).length;

  void _abrirBottomSheet() {
    _controller.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color:
                widget.modoEscuro
                    ? const Color(0xFF26212D)
                    : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 14,
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFFE9E0FA),
                    child: Icon(
                      Icons.add_task,
                      color: Color(0xFF8E6CCF),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Nova tarefa',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _controller,
                autofocus: true,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText:
                      'O que você precisa fazer?',
                  prefixIcon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF8E6CCF),
                  ),
                  filled: true,
                  fillColor:
                      widget.modoEscuro
                          ? const Color(0xFF322B3B)
                          : const Color(0xFFF5F2FA),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(
                      color: Color(0xFF8E6CCF),
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (_) =>
                    _adicionarTarefa(),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _adicionarTarefa,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF8E6CCF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Adicionar tarefa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _adicionarTarefa() {
    final texto = _controller.text.trim();

    if (texto.isEmpty) {
      return;
    }

    setState(() {
      _tarefas.add(
        Tarefa(
          id: DateTime.now()
              .millisecondsSinceEpoch
              .toString(),
          titulo: texto,
        ),
      );
    });

    _controller.clear();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarefa adicionada com sucesso!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _alternarStatus(String id) {
    setState(() {
      final tarefa =
          _tarefas.firstWhere((t) => t.id == id);

      tarefa.concluida = !tarefa.concluida;
    });
  }

  void _deletarTarefa(String id) {
    final index =
        _tarefas.indexWhere((t) => t.id == id);

    if (index == -1) {
      return;
    }

    final tarefaRemovida = _tarefas[index];

    setState(() {
      _tarefas.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"${tarefaRemovida.titulo}" foi excluída.',
        ),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            setState(() {
              _tarefas.insert(
                index,
                tarefaRemovida,
              );
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _tarefas.length;
    final concluidas = tarefasConcluidas;
    final pendentes = tarefasPendentes;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Minhas Tarefas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Organize seu dia',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Alterar tema',
            onPressed: widget.onTemaAlterado,
            icon: Icon(
              widget.modoEscuro
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
              16,
              18,
              16,
              8,
            ),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8E6CCF),
                  Color(0xFFAA8DE0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Olá! 👋',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        pendentes == 0
                            ? 'Tudo concluído!'
                            : '$pendentes tarefas pendentes',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$concluidas de $total concluídas',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: 68,
                  height: 68,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value:
                            total == 0
                                ? 0
                                : concluidas / total,
                        strokeWidth: 7,
                        backgroundColor:
                            Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation<
                              Color
                            >(
                              Colors.white,
                            ),
                      ),
                      Text(
                        total == 0
                            ? '0%'
                            : '${((concluidas / total) * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              4,
            ),
            child: Row(
              children: [
                Text(
                  'Suas tarefas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        widget.modoEscuro
                            ? Colors.white
                            : const Color(0xFF302B38),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        widget.modoEscuro
                            ? const Color(0xFF3A3045)
                            : const Color(0xFFEDE5FA),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$total tarefas',
                    style: const TextStyle(
                      color: Color(0xFF8E6CCF),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child:
                _tarefas.isEmpty
                    ? _buildListaVazia()
                    : ListView.builder(
                      padding:
                          const EdgeInsets.only(
                        top: 8,
                        bottom: 100,
                      ),
                      itemCount: _tarefas.length,
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        final tarefa =
                            _tarefas[index];

                        return Dismissible(
                          key: ValueKey(
                            tarefa.id,
                          ),
                          direction:
                              DismissDirection
                                  .endToStart,
                          background: Container(
                            margin:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 16,
                              vertical: 7,
                            ),
                            padding:
                                const EdgeInsets
                                    .only(
                              right: 24,
                            ),
                            alignment:
                                Alignment.centerRight,
                            decoration:
                                BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onDismissed: (_) =>
                              _deletarTarefa(
                            tarefa.id,
                          ),
                          child: Card(
                            child: InkWell(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),
                              onTap: () =>
                                  _alternarStatus(
                                tarefa.id,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  leading:
                                      Checkbox(
                                    value:
                                        tarefa
                                            .concluida,
                                    activeColor:
                                        const Color(
                                          0xFF8E6CCF,
                                        ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        6,
                                      ),
                                    ),
                                    onChanged:
                                        (_) =>
                                            _alternarStatus(
                                          tarefa.id,
                                        ),
                                  ),

                                  title: Text(
                                    tarefa.titulo,
                                    style:
                                        TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                      decoration:
                                          tarefa
                                                  .concluida
                                              ? TextDecoration
                                                  .lineThrough
                                              : TextDecoration
                                                  .none,
                                      color:
                                          tarefa
                                                  .concluida
                                              ? Colors
                                                  .grey
                                              : widget
                                                      .modoEscuro
                                                  ? Colors
                                                      .white
                                                  : const Color(
                                                      0xFF302B38,
                                                    ),
                                    ),
                                  ),

                                  subtitle:
                                      Padding(
                                    padding:
                                        const EdgeInsets
                                            .only(
                                      top: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          tarefa
                                                  .concluida
                                              ? Icons
                                                  .check_circle
                                              : Icons
                                                  .schedule,
                                          size: 14,
                                          color:
                                              tarefa
                                                      .concluida
                                                  ? const Color(
                                                      0xFF8E6CCF,
                                                    )
                                                  : Colors
                                                      .grey,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          tarefa
                                                  .concluida
                                              ? 'Concluída'
                                              : 'Pendente',
                                          style:
                                              TextStyle(
                                            fontSize:
                                                12,
                                            color:
                                                tarefa
                                                        .concluida
                                                    ? const Color(
                                                        0xFF8E6CCF,
                                                      )
                                                    : Colors
                                                        .grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  trailing:
                                      Icon(
                                    tarefa
                                            .concluida
                                        ? Icons
                                            .check_circle_outline
                                        : Icons
                                            .arrow_forward_ios,
                                    size:
                                        tarefa
                                                .concluida
                                            ? 22
                                            : 15,
                                    color:
                                        tarefa
                                                .concluida
                                            ? const Color(
                                                0xFF8E6CCF,
                                              )
                                            : Colors
                                                .grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _abrirBottomSheet,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Nova tarefa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildListaVazia() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE5FA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt,
                size: 50,
                color: Color(0xFF8E6CCF),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tudo tranquilo por aqui!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adicione uma nova tarefa para começar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}