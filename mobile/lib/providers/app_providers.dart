import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App-wide theme mode provider.
/// Watched by MaterialApp in main.dart so changing this value
/// immediately changes the whole app's theme.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
