import 'package:flutter_test/flutter_test.dart';
import 'package:montador_perfil_treino/main.dart';

void main() {
  testWidgets('Tela inicial mostra o titulo', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuApp());
    expect(find.text('Montador de Perfil de Treino'), findsOneWidget);
  });
}