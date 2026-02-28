import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { stopped, playing, paused }

class TtsService {
  final FlutterTts _tts = FlutterTts();
  TtsState state = TtsState.stopped;

  void Function(TtsState)? onStateChanged;

  TtsService() {
    _tts.setLanguage('en-IN');
    _tts.setSpeechRate(0.42);
    _tts.setPitch(1.0);
    _tts.setVolume(1.0);

    _tts.setStartHandler(() {
      state = TtsState.playing;
      onStateChanged?.call(state);
    });

    _tts.setCompletionHandler(() {
      state = TtsState.stopped;
      onStateChanged?.call(state);
    });

    _tts.setCancelHandler(() {
      state = TtsState.stopped;
      onStateChanged?.call(state);
    });

    _tts.setErrorHandler((_) {
      state = TtsState.stopped;
      onStateChanged?.call(state);
    });
  }

  /// Cleans legal text so it sounds natural when spoken.
  String _prepareText(String text) {
    return text
        // Newlines → natural pause
        .replaceAll('\n\n', '. ')
        .replaceAll('\n', ', ')
        // Common legal abbreviations → expanded form
        .replaceAll(
          RegExp(r'\bSec\.?\s*(\d+)', caseSensitive: false),
          'Section \$1',
        )
        .replaceAll(
          RegExp(r'\bCl\.?\s*(\d+)', caseSensitive: false),
          'Clause \$1',
        )
        .replaceAll(RegExp(r'\bSub-[Ss]ec\.?'), 'Sub-section')
        .replaceAll('u/s', 'under section')
        .replaceAll('r/w', 'read with')
        .replaceAll('w.e.f', 'with effect from')
        .replaceAll('i.e.', 'that is,')
        .replaceAll('e.g.', 'for example,')
        .replaceAll('etc.', 'et cetera')
        .replaceAll('IPC', 'Indian Penal Code')
        .replaceAll('CrPC', 'Code of Criminal Procedure')
        .replaceAll('BNS', 'Bharatiya Nyaya Sanhita')
        .replaceAll('BNSS', 'Bharatiya Nagarik Suraksha Sanhita')
        .replaceAll('BSA', 'Bharatiya Sakshya Adhiniyam')
        // Remove numbered list markers (1., (a), (i)) that sound choppy
        .replaceAll(RegExp(r'\(([a-z]{1,3}|[ivxlcdm]+)\)'), '')
        .replaceAll(RegExp(r'^\s*\d+\.\s', multiLine: true), '')
        // Remove brackets and their content that are references
        .replaceAll(RegExp(r'\[.*?\]'), '')
        // Special characters
        .replaceAll('—', ', ')
        .replaceAll('–', ', ')
        .replaceAll(';', ',')
        .replaceAll(':', ',')
        // Clean up multiple spaces/commas
        .replaceAll(RegExp(r',\s*,'), ',')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
  }

  Future<void> speak(String text) async {
    if (state == TtsState.playing) {
      await stop();
      return;
    }
    final cleaned = _prepareText(text);
    await _tts.speak(cleaned);
  }

  Future<void> stop() async {
    await _tts.stop();
    state = TtsState.stopped;
    onStateChanged?.call(state);
  }

  void dispose() {
    _tts.stop();
  }
}
