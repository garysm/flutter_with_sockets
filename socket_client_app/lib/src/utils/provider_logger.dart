import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderLogger extends ProviderObserver {
  // Prints to console whenever there is a new provider.
  @override
  void didAddProvider(ProviderBase<dynamic, dynamic> provider, Object? newValue) {
    print('''
New Provider:
{
  "new provider": "${provider.name ?? provider.runtimeType}",
  "value": "$newValue"
}''');
  }

  // Prints to console whenever any providers change their state.
  @override
  void didUpdateProvider(ProviderBase<dynamic, dynamic> provider, Object? newValue) {
    print('''
Updated Provider Value:
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }

  // Prints to console whenever any providers are disposed.
  @override
  void didDisposeProvider(ProviderBase<dynamic, dynamic> provider) {
    print('''
Disposed Provider:
{
  "disposed provider": "${provider.name ?? provider.runtimeType}"
}''');
  }
}
