import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'memoized_test.dart';
import 'mock.dart';

void main() {
  testWidgets('useState basic', (tester) async {
    late ValueNotifier<int> state;
    late HookElement element;

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        element = context as HookElement;
        state = useState(42);
        return Container();
      },
    ));

    expect(state.value, 42);
    expect(element.dirty, false);

    await tester.pump();

    expect(state.value, 42);
    expect(element.dirty, false);

    state.value++;
    expect(element.dirty, true);
    await tester.pump();

    expect(state.value, 43);
    expect(element.dirty, false);

    // dispose
    await tester.pumpWidget(const SizedBox());

    expect(() => state.addListener(() {}), throwsFlutterError);
  });

  testWidgets('useState value not change when initial updates', (tester) async {
    late ValueNotifier<int> state;
    late HookElement element;

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        element = context as HookElement;
        state = useState(42);
        return MaterialApp(home: Text('${state.value}'));
      },
    ));

    expect(state.value, 42);
    expect(element.dirty, false);
    expect(find.text('42'), findsOneWidget);

    await tester.pump();

    expect(state.value, 42);
    expect(element.dirty, false);
    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        element = context as HookElement;
        state = useState(43);
        return MaterialApp(home: Text('${state.value}'));
      },
    ));

    expect(state.value, 42);
    expect(element.dirty, false);
    expect(find.text('42'), findsOneWidget);

    await tester.pump();

    expect(state.value, 42);
    expect(element.dirty, false);
    expect(find.text('42'), findsOneWidget);

    // dispose
    await tester.pumpWidget(const SizedBox());

    expect(() => state.addListener(() {}), throwsFlutterError);
  });

  testWidgets('useState(weak true) updates', (tester) async {
    late ValueNotifier<int> state;
    late HookElement element;

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        element = context as HookElement;
        state = useState(42, weak: true);
        return MaterialApp(home: Text('${state.value}'));
      },
    ));

    await tester.pump();

    expect(state.value, 42);
    expect(element.dirty, false);
    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        element = context as HookElement;
        state = useState(43, weak: true);
        return MaterialApp(home: Text('${state.value}'));
      },
    ));
    
    await tester.pump();

    expect(state.value, 43);
    expect(element.dirty, false);
    expect(find.text('43'), findsOneWidget);

    // dispose
    await tester.pumpWidget(const SizedBox());

    expect(() => state.addListener(() {}), throwsFlutterError);
  });

  testWidgets('no initial data', (tester) async {
    late ValueNotifier<int?> state;
    late HookElement element;

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        element = context as HookElement;
        state = useState<int?>(null);
        return Container();
      },
    ));

    expect(state.value, null);
    expect(element.dirty, false);

    await tester.pump();

    expect(state.value, null);
    expect(element.dirty, false);

    state.value = 43;
    expect(element.dirty, true);
    await tester.pump();

    expect(state.value, 43);
    expect(element.dirty, false);

    // dispose
    await tester.pumpWidget(const SizedBox());

    expect(() => state.addListener(() {}), throwsFlutterError);
  });

  testWidgets('debugFillProperties should print state hook ', (tester) async {
    late ValueNotifier<int> state;
    late HookElement element;
    final hookWidget = HookBuilder(
      builder: (context) {
        element = context as HookElement;
        state = useState(0);
        return const SizedBox();
      },
    );
    await tester.pumpWidget(hookWidget);

    expect(
      element.toStringDeep(),
      equalsIgnoringHashCodes(
        'HookBuilder(useState<int>: 0)\n'
        '└SizedBox(renderObject: RenderConstrainedBox#00000)\n',
      ),
    );

    state.value++;

    await tester.pump();

    expect(
      element.toStringDeep(),
      equalsIgnoringHashCodes(
        'HookBuilder(useState<int>: 1)\n'
        '└SizedBox(renderObject: RenderConstrainedBox#00000)\n',
      ),
    );
  });
}
