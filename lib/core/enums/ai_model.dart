// lib/core/enums/ai_model.dart
enum AiModel {
  gemini,
  chatGPT,
  deepSeek;

  String get displayName {
    switch (this) {
      case AiModel.gemini:
        return 'Gemini';
      case AiModel.chatGPT:
        return 'ChatGPT';
      case AiModel.deepSeek:
        return 'DeepSeek';
    }
  }
}
