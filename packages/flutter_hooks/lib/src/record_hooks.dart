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

extension type _CallableValueNotifier<T>(ValueNotifier<T> notifier)
    implements ValueNotifier<T> {
  // ignore: use_setters_to_change_properties
  void call(T value) => this.value = value;
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
