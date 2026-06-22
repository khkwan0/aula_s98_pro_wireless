import 'app_localizations.dart';

import 'user_message.dart';

extension LightingModeNames on AppLocalizations {
  String lightingModeName(int index) {
    return switch (index) {
      0 => lightingModeOff,
      1 => lightingModeStatic,
      2 => lightingModeSingleOn,
      3 => lightingModeSingleOff,
      4 => lightingModeGlittering,
      5 => lightingModeFalling,
      6 => lightingModeColourful,
      7 => lightingModeBreath,
      8 => lightingModeSpectrum,
      9 => lightingModeOutward,
      10 => lightingModeScrolling,
      11 => lightingModeRolling,
      12 => lightingModeRotating,
      13 => lightingModeExplode,
      14 => lightingModeLaunch,
      15 => lightingModeRipples,
      16 => lightingModeFlowing,
      17 => lightingModePulsating,
      18 => lightingModeTilt,
      19 => lightingModeShuttle,
      _ => '$index',
    };
  }
}

extension MessageLocalization on AppLocalizations {
  String localizeMessage(UserMessage message) {
    final args = message.args;
    return switch (message.key) {
      'errorDeviceNotFound' => errorDeviceNotFound(args['device']! as String),
      'errorLcdInterfaceNotFound' =>
        errorLcdInterfaceNotFound(args['device']! as String),
      'errorFileNotFound' => errorFileNotFound(args['path']! as String),
      'errorSupportedFormats' => errorSupportedFormats,
      'errorLcdBufferTooSmall' => errorLcdBufferTooSmall,
      'errorLcdBufferEmpty' => errorLcdBufferEmpty,
      'errorLcdBufferSizeMultiple' => errorLcdBufferSizeMultiple(
          args['size']! as int,
          args['pageSize']! as int,
        ),
      'errorLcdBufferZeroFrames' => errorLcdBufferZeroFrames,
      'errorLcdBufferTooManyFrames' => errorLcdBufferTooManyFrames(
          args['frameCount']! as int,
          args['maxFrames']! as int,
        ),
      'errorLcdBufferTruncated' => errorLcdBufferTruncated(
          args['headerFrames']! as int,
          args['computedFrames']! as int,
        ),
      'errorLcdBufferTooManyPages' => errorLcdBufferTooManyPages(
          args['pageCount']! as int,
          args['maxPages']! as int,
          args['maxFrames']! as int,
        ),
      'errorGifNoFrames' => errorGifNoFrames,
      'errorGifDecodeFrame' => errorGifDecodeFrame(args['frame']! as int),
      'warningGifDimensions' => warningGifDimensions(
          args['width']! as int,
          args['height']! as int,
          args['expectedWidth']! as int,
          args['expectedHeight']! as int,
        ),
      'warningGifDimensionsCrop' => warningGifDimensionsCrop(
          args['width']! as int,
          args['height']! as int,
          args['expectedWidth']! as int,
          args['expectedHeight']! as int,
        ),
      'warningGifTooManyFrames' => warningGifTooManyFrames(
          args['frameCount']! as int,
          args['maxFrames']! as int,
        ),
      'warningGifCappedAt255' =>
        warningGifCappedAt255(args['frameCount']! as int),
      'errorMacroEmpty' => errorMacroEmpty,
      'errorMacroTooManyMacros' =>
        errorMacroTooManyMacros(args['count']! as int),
      'errorMacroTooLarge' => errorMacroTooLarge(
          args['macros']! as int,
          args['events']! as int,
        ),
      'errorMacroUnsupportedKey' => errorMacroUnsupportedKey,
      'errorMacroUnsupportedTriggerKey' => errorMacroUnsupportedTriggerKey,
      'errorMacroTriggerModifierNotAllowed' =>
        errorMacroTriggerModifierNotAllowed,
      'errorMacroTriggerSingleKeyOnly' => errorMacroTriggerSingleKeyOnly,
      'errorMacroTriggerInvalid' => switch (args['reason'] as String?) {
        'modifierNotAllowed' => errorMacroTriggerModifierNotAllowed,
        'singleKeyOnly' => errorMacroTriggerSingleKeyOnly,
        _ => errorMacroTriggerInvalid,
      },
      'errorMacroDuplicateTrigger' =>
        errorMacroDuplicateTrigger(args['key']! as String),
      _ => message.key,
    };
  }

  String localizeError(Object error) {
    if (error is UserMessage) {
      return localizeMessage(error);
    }
    return error.toString();
  }

  String formatWarning(UserMessage warning) {
    return warningPrefix(localizeMessage(warning));
  }
}
