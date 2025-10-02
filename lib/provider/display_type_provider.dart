import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Define the display type enumeration
enum DisplayType { list, grid }

// Create a StateNotifier to manage the display type state
class DisplayTypeNotifier extends StateNotifier<DisplayType> {
  DisplayTypeNotifier() : super(DisplayType.list); // Default to list

  void toggleDisplayType() {
    state = state == DisplayType.list ? DisplayType.grid : DisplayType.list;
  }
}

// Create a provider for the DisplayTypeNotifier
final displayTypeProvider =
    StateNotifierProvider<DisplayTypeNotifier, DisplayType>(
      (ref) => DisplayTypeNotifier(),
    );
