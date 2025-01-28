part of 'hooks.dart';

/// Record-returning state hook
(T value, _CallableValueNotifier<T> setValue) $useState<T>(T initialData) {
  final state = useState(initialData);
  return (state.value, _CallableValueNotifier(state));
}

/// Record-returning ref hook
(T value, _SetRefValueCallback<T> setValue) $useRef<T>(T initialData) {
  final ref = useRef(initialData);
  return (ref.value, _SetRefValueCallback(ref));
}

class _SetRefValueCallback<T> {
  const _SetRefValueCallback(this._ref);

  final ObjectRef<T> _ref;

  // ignore: avoid_setters_without_getters
  set value(T value) => _ref.value = value;

  // ignore: use_setters_to_change_properties
  void call(T value) {
    _ref.value = value;
  }
}

class _CallableValueNotifier<T> implements ValueNotifier<T> {
  const _CallableValueNotifier(this._notifier);

  final ValueNotifier<T> _notifier;

  // ignore: use_setters_to_change_properties
  void call(T value) => this.value = value;

  @override
  T get value => _notifier.value;

  @override
  set value(T value) => _notifier.value = value;

  @override
  void addListener(VoidCallback listener) {
    _notifier.addListener(listener);
  }

  @override
  void dispose() {
    _notifier.dispose();
  }

  @override
  bool get hasListeners => _notifier.hasListeners;

  @override
  void notifyListeners() {
    _notifier.notifyListeners();
  }

  @override
  void removeListener(VoidCallback listener ) {
    _notifier.removeListener(listener);
  }
}