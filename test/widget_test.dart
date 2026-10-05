import 'package:flutter_test/flutter_test.dart';
import 'package:atividad4_lista/main.dart';

void main() {
  testWidgets(
    'Lista de tarefas inicia corretamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());

      expect(
        find.text('Lista de Afazeres'),
        findsOneWidget,
      );

      expect(
        find.text('Comprar pão, leite e ovo'),
        findsOneWidget,
      );

      expect(
        find.text('Responder e-mails do trabalho'),
        findsOneWidget,
      );

      expect(
        find.text('Acadêmia às 18h'),
        findsOneWidget,
      );

      expect(
        find.text('2 pendentes'),
        findsOneWidget,
      );
    },
  );
}