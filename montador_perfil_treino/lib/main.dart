import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

const Color rosa = Color(0xFFE91E63);
const Color rosaEscuro = Color(0xFFC2185B);
const Color rosaClaro = Color(0xFFFCE4EC);
const Color corBorda = Color(0xFFE8CDD6);
const Color corTexto = Color(0xFF2D1B22);
const Color corTextoSecundario = Color(0xFF79515F);

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder bordaCampo = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: corBorda),
    );

    return MaterialApp(
      title: 'Montador de Perfil de Treino',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink).copyWith(
          primary: rosa,
          onPrimary: Colors.white,
          primaryContainer: rosaClaro,
          onPrimaryContainer: rosaEscuro,
          secondaryContainer: rosaClaro,
          onSecondaryContainer: rosaEscuro,
          surface: Colors.white,
          onSurface: corTexto,
          outline: corBorda,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF9FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: rosaEscuro,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: bordaCampo,
          enabledBorder: bordaCampo,
          focusedBorder: bordaCampo.copyWith(
            borderSide: const BorderSide(color: rosa, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: rosa,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: rosa,
            selectedForegroundColor: Colors.white,
            side: const BorderSide(color: corBorda),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: rosaClaro,
          checkmarkColor: rosaEscuro,
          deleteIconColor: rosaEscuro,
          side: const BorderSide(color: corBorda),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: rosa,
          inactiveTrackColor: rosaClaro,
          thumbColor: rosaEscuro,
          valueIndicatorColor: rosaEscuro,
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? rosa
                : corTextoSecundario,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? rosa
                : Colors.transparent,
          ),
          checkColor: const WidgetStatePropertyAll(Colors.white),
          side: const BorderSide(color: corTextoSecundario, width: 1.5),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.white
                : corTextoSecundario,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? rosa : rosaClaro,
          ),
        ),
      ),
      home: const MontadorPerfilTela(),
    );
  }
}

class MontadorPerfilTela extends StatefulWidget {
  const MontadorPerfilTela({super.key});

  @override
  State<MontadorPerfilTela> createState() => _MontadorPerfilTelaState();
}

class _MontadorPerfilTelaState extends State<MontadorPerfilTela> {
  static const List<String> _objetivos = [
    'Emagrecimento',
    'Hipertrofia',
    'Condicionamento',
  ];
  static const List<String> _niveis = [
    'Iniciante',
    'Intermediário',
    'Avançado',
  ];
  static const List<String> _restricoes = [
    'Vegetariano',
    'Vegano',
    'Sem lactose',
    'Sem glúten',
    'Low Carb',
  ];
  static const List<int> _frequencias = [2, 3, 4, 5, 6];

  String? _objetivoSelecionado;
  String? _nivelSelecionado;
  final Set<String> _restricoesSelecionadas = {};
  final List<String> _alergias = [];
  final TextEditingController _alergiaController = TextEditingController();
  double _tempoDiario = 60;
  int? _frequenciaSelecionada;
  bool _notificacoesAgua = false;
  bool _termosAceitos = false;

  @override
  void dispose() {
    _alergiaController.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), behavior: SnackBarBehavior.floating),
    );
  }

  void _adicionarAlergia() {
    final String texto = _alergiaController.text.trim();

    if (texto.isEmpty) {
      _mostrarMensagem('Digite uma alergia antes de adicionar.');
      return;
    }

    final bool duplicada = _alergias.any(
      (a) => a.toLowerCase() == texto.toLowerCase(),
    );

    if (duplicada) {
      _mostrarMensagem('Essa alergia já foi adicionada.');
      return;
    }

    setState(() {
      _alergias.add(texto);
    });
    _alergiaController.clear();
    print('[DEBUG - Alergia] Adicionada: $texto');
  }

  void _gerarPlano() {
    final List<String> erros = [];

    if (_objetivoSelecionado == null) {
      erros.add('Selecione um objetivo para o treino.');
    }
    if (_nivelSelecionado == null) {
      erros.add('Selecione seu nível de experiência.');
    }
    if (_frequenciaSelecionada == null) {
      erros.add('Selecione a frequência semanal.');
    }
    if (!_termosAceitos) {
      erros.add('Você precisa aceitar os termos e condições.');
    }

    if (erros.isNotEmpty) {
      _mostrarMensagem(erros.join('\n'));
      print('[DEBUG - Validação] Erros: $erros');
      return;
    }

    print('[DEBUG] Plano gerado com sucesso.');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _construirResumo(),
    );
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        texto.toUpperCase(),
        style: const TextStyle(
          color: rosaEscuro,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _cartao({String? titulo, required Widget filho}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: corBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titulo != null) _titulo(titulo),
          filho,
        ],
      ),
    );
  }

  Widget _linhaResumo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: rosa,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(valor, style: const TextStyle(fontSize: 16, color: corTexto)),
        ],
      ),
    );
  }

  Widget _construirResumo() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: corBorda,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Seu perfil de treino',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: rosaEscuro,
              ),
            ),
            const SizedBox(height: 16),
            _linhaResumo('Objetivo', _objetivoSelecionado ?? '-'),
            _linhaResumo('Nível', _nivelSelecionado ?? '-'),
            _linhaResumo(
              'Restrições alimentares',
              _restricoesSelecionadas.isEmpty
                  ? 'Nenhuma'
                  : _restricoesSelecionadas.join(', '),
            ),
            _linhaResumo(
              'Alergias',
              _alergias.isEmpty ? 'Nenhuma' : _alergias.join(', '),
            ),
            _linhaResumo('Tempo diário', '${_tempoDiario.round()} minutos'),
            _linhaResumo(
              'Frequência',
              _frequenciaSelecionada == null
                  ? '-'
                  : '$_frequenciaSelecionada dias por semana',
            ),
            _linhaResumo(
              'Notificações de água',
              _notificacoesAgua ? 'Ativadas' : 'Desativadas',
            ),
            _linhaResumo('Termos', _termosAceitos ? 'Aceitos' : 'Não aceitos'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Montador de Perfil de Treino'),
        leading: const Icon(Icons.fitness_center),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _cartao(
                titulo: 'Objetivo do treino',
                filho: SegmentedButton<String>(
                  emptySelectionAllowed: true,
                  showSelectedIcon: false,
                  segments: _objetivos.map((objetivo) {
                    return ButtonSegment<String>(
                      value: objetivo,
                      label: Text(
                        objetivo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  selected: _objetivoSelecionado == null
                      ? <String>{}
                      : {_objetivoSelecionado!},
                  onSelectionChanged: (Set<String> novo) {
                    setState(() {
                      _objetivoSelecionado = novo.isEmpty ? null : novo.first;
                    });
                    print('[DEBUG - Objetivo] $_objetivoSelecionado');
                  },
                ),
              ),

              _cartao(
                titulo: 'Nível de experiência',
                filho: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _niveis.map((nivel) {
                    return ChoiceChip(
                    label: Text(nivel),
                    selected: _nivelSelecionado == nivel,
                    showCheckmark: true,
                    selectedColor: rosa,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _nivelSelecionado == nivel ? Colors.white : corTexto,
                      fontWeight: _nivelSelecionado == nivel
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onSelected: (bool marcado) {
                      setState(() {
                        _nivelSelecionado = nivel;
                      });
                      print('[DEBUG - Nível] $nivel');
                    },
                  );
                  }).toList(),
                ),
              ),

              _cartao(
                titulo: 'Restrições alimentares',
                filho: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _restricoes.map((restricao) {
                    return FilterChip(
                      label: Text(restricao),
                      selected: _restricoesSelecionadas.contains(restricao),
                      onSelected: (bool marcado) {
                        setState(() {
                          if (marcado) {
                            _restricoesSelecionadas.add(restricao);
                          } else {
                            _restricoesSelecionadas.remove(restricao);
                          }
                        });
                        print(
                          '[DEBUG - Restrição] "$restricao" alterada para: $marcado',
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

              _cartao(
                titulo: 'Alergias',
                filho: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _alergiaController,
                            textCapitalization: TextCapitalization.sentences,
                            onSubmitted: (_) => _adicionarAlergia(),
                            decoration: const InputDecoration(
                              hintText: 'Digite uma alergia...',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _adicionarAlergia,
                          child: const Text('Adicionar'),
                        ),
                      ],
                    ),
                    if (_alergias.isNotEmpty) const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _alergias.map((alergia) {
                        return InputChip(
                          label: Text(alergia),
                          onDeleted: () {
                            setState(() {
                              _alergias.remove(alergia);
                            });
                            print('[DEBUG - Alergia] Removida: $alergia');
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              _cartao(
                titulo: 'Tempo diário de treino',
                filho: Column(
                  children: [
                    Slider(
                      value: _tempoDiario,
                      min: 15,
                      max: 120,
                      divisions: 21,
                      label: '${_tempoDiario.round()} min',
                      onChanged: (double valor) {
                        setState(() {
                          _tempoDiario = valor;
                        });
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('15'), Text('120')],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_tempoDiario.round()} minutos',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: rosaEscuro,
                      ),
                    ),
                  ],
                ),
              ),

              _cartao(
                titulo: 'Frequência semanal',
                filho: Column(
                  children: _frequencias.map((dias) {
                    return RadioListTile<int>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text('$dias dias por semana'),
                      value: dias,
                      groupValue: _frequenciaSelecionada,
                      onChanged: (int? valor) {
                        setState(() {
                          _frequenciaSelecionada = valor;
                        });
                        print('[DEBUG - Frequência] $valor dias');
                      },
                    );
                  }).toList(),
                ),
              ),

              _cartao(
                filho: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.water_drop, color: rosa),
                  title: const Text('Receber notificações para beber água'),
                  subtitle:
                      Text(_notificacoesAgua ? 'Ativadas' : 'Desativadas'),
                  value: _notificacoesAgua,
                  onChanged: (bool valor) {
                    setState(() {
                      _notificacoesAgua = valor;
                    });
                    print('[DEBUG - Notificações] $valor');
                  },
                ),
              ),

              _cartao(
                filho: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'Aceito os termos e condições para geração do plano de treino.',
                  ),
                  value: _termosAceitos,
                  onChanged: (bool? marcado) {
                    setState(() {
                      _termosAceitos = marcado ?? false;
                    });
                    print('[DEBUG - Termos] $marcado');
                  },
                ),
              ),

              ElevatedButton(
                onPressed: _gerarPlano,
                style: ElevatedButton.styleFrom(
                  backgroundColor:const Color(0xffc2185b),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  elevation: 4,
                ),
                child: const Text(
                  'GERAR PLANO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

