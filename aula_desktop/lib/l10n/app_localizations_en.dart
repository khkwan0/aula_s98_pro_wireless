// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChineseSimplified => '简体中文';

  @override
  String get languageChineseTraditional => '繁體中文';

  @override
  String get navHome => 'Home';

  @override
  String get navClock => 'Clock';

  @override
  String get navRgb => 'RGB';

  @override
  String get navRemap => 'Remap';

  @override
  String get navMacro => 'Macros';

  @override
  String get navLcd => 'LCD';

  @override
  String get deviceInfoTooltip => 'Device info';

  @override
  String get aboutTooltip => 'About';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutVersion => 'Version';

  @override
  String aboutVersionValue(String version, String build) {
    return '$version ($build)';
  }

  @override
  String get aboutAuthor => 'Author';

  @override
  String get aboutIssues => 'Report issues';

  @override
  String get aboutOpenIssues => 'Open issues';

  @override
  String get close => 'Close';

  @override
  String get connected => 'Connected';

  @override
  String get notConnected => 'Not connected';

  @override
  String get notFound => 'Not found';

  @override
  String get ready => 'Ready';

  @override
  String get missing => 'Missing';

  @override
  String get usbIdentification => 'USB identification';

  @override
  String get controlHidInterface => 'Control HID interface';

  @override
  String get lcdHidInterface => 'LCD HID interface';

  @override
  String get protocol => 'Protocol';

  @override
  String get model => 'Model';

  @override
  String get vendorId => 'Vendor ID';

  @override
  String get productId => 'Product ID';

  @override
  String get status => 'Status';

  @override
  String get path => 'Path';

  @override
  String get usagePage => 'Usage page';

  @override
  String get usage => 'Usage';

  @override
  String get interface => 'Interface';

  @override
  String get hidReportSize => 'HID report size';

  @override
  String get commandDelay => 'Command delay';

  @override
  String get lcdResolution => 'LCD resolution';

  @override
  String get pixelFormat => 'Pixel format';

  @override
  String get frameSize => 'Frame size';

  @override
  String get maxFramesLabel => 'Max frames';

  @override
  String get flashPageSize => 'Flash page size';

  @override
  String get lcdAckTimeout => 'LCD ACK timeout';

  @override
  String allHidInterfaces(int count) {
    return 'All HID interfaces ($count)';
  }

  @override
  String interfaceSummary(int number, String usagePage, int usage) {
    return 'IF$number: $usagePage usage $usage';
  }

  @override
  String bytesUnit(int count) {
    return '$count bytes';
  }

  @override
  String millisecondsUnit(int count) {
    return '$count ms';
  }

  @override
  String pixelFormatValue(int bytesPerPixel) {
    return 'RGB565 ($bytesPerPixel bytes/pixel)';
  }

  @override
  String resolutionValue(int width, int height) {
    return '$width×$height';
  }

  @override
  String get keyboardCardTitle => 'Keyboard';

  @override
  String get usbWiredRequired => 'USB wired required';

  @override
  String get lcdInterfaceCardTitle => 'LCD interface';

  @override
  String get lcdInterfaceCardSubtitle => 'Required for GIF upload';

  @override
  String get frameLimitCardTitle => 'Frame limit';

  @override
  String frameLimitValue(int count) {
    return '$count frames';
  }

  @override
  String get frameLimitSubtitle => '240×135 RGB565';

  @override
  String get requirementsTitle => 'Requirements';

  @override
  String get requirementUsb =>
      '• Connect the keyboard over USB (not Bluetooth only).';

  @override
  String get requirementCloseUtility =>
      '• Close AULA utility software before using this app.';

  @override
  String requirementGifTrim(int maxFrames) {
    return '• GIFs over $maxFrames frames are trimmed automatically.';
  }

  @override
  String get factoryResetTitle => 'Factory reset';

  @override
  String get factoryResetSubtitle =>
      'Restore lighting, key remaps, and macros to defaults.';

  @override
  String get factoryResetButton => 'Factory reset';

  @override
  String get factoryResetDialogTitle => 'Factory reset keyboard?';

  @override
  String get factoryResetDialogBody =>
      'This will clear all custom key remaps, macro bindings, and recorded macros, then restore the default lighting profile.\n\nLCD animations and on-screen menu graphics are not affected. To reset those, re-upload the original GIF or hold Fn + Esc for 5 seconds on the keyboard.';

  @override
  String factoryResetSuccess(String mode) {
    return 'Factory reset complete. Key remaps and macros cleared. Lighting restored to $mode.';
  }

  @override
  String get clockTitle => 'LCD Clock';

  @override
  String get clockSubtitle => 'Sync the keyboard screen clock over USB.';

  @override
  String get useCustomDateTime => 'Use custom date/time';

  @override
  String get useCustomDateTimeSubtitle => 'Off = sync to system time now';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get syncCustomTime => 'Sync custom time';

  @override
  String get syncSystemTime => 'Sync system time';

  @override
  String syncedTo(String datetime) {
    return 'Synced to $datetime';
  }

  @override
  String get rgbTitle => 'RGB Lighting';

  @override
  String get rgbSubtitle => 'Set backlight mode, color, brightness, and speed.';

  @override
  String get mode => 'Mode';

  @override
  String lightingModeEntry(String index, String name) {
    return '$index — $name';
  }

  @override
  String get rainbowColorful => 'Rainbow / colorful';

  @override
  String colorRgbValue(int r, int g, int b) {
    return 'RGB ($r, $g, $b)';
  }

  @override
  String get colorRed => 'Red';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorBlue => 'Blue';

  @override
  String colorHsvValue(int h, int s, int v) {
    return 'HSV ($h, $s, $v)';
  }

  @override
  String brightness(int value) {
    return 'Brightness: $value';
  }

  @override
  String speed(int value) {
    return 'Speed: $value';
  }

  @override
  String direction(int value) {
    return 'Direction: $value';
  }

  @override
  String get apply => 'Apply';

  @override
  String get turnOff => 'Turn off';

  @override
  String appliedMode(String mode) {
    return 'Applied $mode';
  }

  @override
  String get backlightTurnedOff => 'Backlight turned off';

  @override
  String get macroTitle => 'Macros';

  @override
  String get macroSubtitle =>
      'Record keyboard sequences, assign one trigger key per macro, and upload over USB. Like the official AULA software, each macro is triggered by a single key.';

  @override
  String get macroListTitle => 'Macro slots';

  @override
  String get macroAdd => 'Add macro';

  @override
  String get macroName => 'Name';

  @override
  String get macroDelayMode => 'Delay between events';

  @override
  String get macroPlaybackMode => 'Playback mode';

  @override
  String get macroPlaybackModeHint =>
      'How the macro runs when you press its trigger key.';

  @override
  String get macroPlaybackOnce => 'Play once or repeat N times';

  @override
  String get macroPlaybackToggle => 'Toggle on/off';

  @override
  String get macroMaxRepeats => 'Maximum repeats';

  @override
  String get macroMaxRepeatsHint =>
      'How many times the macro runs each time you press its trigger key (1–99). Only used in play-once mode.';

  @override
  String get macroDelayRecorded => 'Use recorded delays';

  @override
  String get macroDelayNone => 'No delay';

  @override
  String get macroDelayCustom => 'Fixed delay';

  @override
  String get macroDelayMs => 'Delay (ms)';

  @override
  String get macroRecordingHint =>
      'Recording… press keys on your keyboard. Press Esc to stop.';

  @override
  String get macroNoEvents => 'No events yet. Click Record and press keys.';

  @override
  String macroEventCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '1 event',
      zero: 'No events',
    );
    return '$_temp0';
  }

  @override
  String macroListEntryWithTrigger(int count, String key) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '1 event',
      zero: 'No events',
    );
    return '$_temp0 • Trigger: $key';
  }

  @override
  String get macroTriggerTitle => 'Trigger key';

  @override
  String get macroTriggerNone => 'No trigger key assigned.';

  @override
  String macroTriggerAssigned(String key) {
    return 'Press $key on the keyboard to run this macro.';
  }

  @override
  String get macroTriggerSingleKeyNote =>
      'Each macro can use one trigger key only. Modifier shortcuts (e.g. Ctrl+C) belong inside the recorded sequence, not in the trigger.';

  @override
  String warningMacroTriggerOverlap(String keys) {
    return 'Warning: $keys is also typed by this macro. Use a trigger key that is not part of the sequence (e.g. a function key).';
  }

  @override
  String macroTriggerPending(String keys, int count) {
    return 'Selected: $keys ($count/3). Press Enter or Confirm.';
  }

  @override
  String get macroConfirmTrigger => 'Confirm';

  @override
  String get macroAssignTrigger => 'Assign trigger key';

  @override
  String get macroClearTrigger => 'Clear trigger';

  @override
  String get macroAssigningTriggerHint =>
      'Press one key to assign as the macro trigger. Esc to cancel.';

  @override
  String get macroActionDown => 'Down';

  @override
  String get macroActionUp => 'Up';

  @override
  String get macroActionDelay => 'Delay';

  @override
  String macroGapDelay(int ms) {
    return 'Gap before: $ms ms';
  }

  @override
  String get macroRecord => 'Record';

  @override
  String get macroStop => 'Stop';

  @override
  String get macroClear => 'Clear events';

  @override
  String get macroClearHint =>
      'Clears recorded events in the app and on the keyboard.';

  @override
  String get macroEventsCleared => 'Cleared macro events on the keyboard.';

  @override
  String get macroDelete => 'Delete macro';

  @override
  String get macroUpload => 'Upload to keyboard';

  @override
  String get macroUploadPending => 'Upload pending changes to the keyboard';

  @override
  String get macroUploadPendingTitle => 'Keyboard not updated yet';

  @override
  String get macroUploadPendingBody =>
      'Your macro changes are saved in this app but have not been sent to the keyboard. Upload now to make them work.';

  @override
  String get macroNoChangesToUpload => 'No macro changes to upload.';

  @override
  String macroUploaded(int macroCount, int eventCount) {
    String _temp0 = intl.Intl.pluralLogic(
      macroCount,
      locale: localeName,
      other: '$macroCount macros',
      one: '1 macro',
    );
    String _temp1 = intl.Intl.pluralLogic(
      eventCount,
      locale: localeName,
      other: '$eventCount events',
      one: '1 event',
    );
    return 'Uploaded $_temp0 with $_temp1';
  }

  @override
  String macroUploadedWithBinding(
      int macroCount, int eventCount, int bindingCount) {
    String _temp0 = intl.Intl.pluralLogic(
      macroCount,
      locale: localeName,
      other: '$macroCount macros',
      one: '1 macro',
    );
    String _temp1 = intl.Intl.pluralLogic(
      eventCount,
      locale: localeName,
      other: '$eventCount events',
      one: '1 event',
    );
    String _temp2 = intl.Intl.pluralLogic(
      bindingCount,
      locale: localeName,
      other: '$bindingCount trigger keys',
      one: '1 trigger key',
    );
    return 'Uploaded $_temp0 with $_temp1 and bound $_temp2.';
  }

  @override
  String macroUploadedAssignTrigger(int macroCount, int eventCount) {
    String _temp0 = intl.Intl.pluralLogic(
      macroCount,
      locale: localeName,
      other: '$macroCount macros',
      one: '1 macro',
    );
    String _temp1 = intl.Intl.pluralLogic(
      eventCount,
      locale: localeName,
      other: '$eventCount events',
      one: '1 event',
    );
    return 'Uploaded $_temp0 with $_temp1. Assign a trigger key to run it.';
  }

  @override
  String get errorMacroEmpty =>
      'Add at least one macro with recorded events before uploading.';

  @override
  String errorMacroTooManyMacros(int count) {
    return 'Too many macros ($count). The keyboard supports up to 100.';
  }

  @override
  String errorMacroTooLarge(int macros, int events) {
    return 'Macro data is too large ($macros macros, $events events). Reduce the number of macros or events.';
  }

  @override
  String get errorMacroUnsupportedKey =>
      'That key is not supported for macros.';

  @override
  String get errorMacroUnsupportedTriggerKey =>
      'That key cannot be used as a macro trigger.';

  @override
  String get errorMacroTriggerModifierNotAllowed =>
      'Modifier keys cannot be macro triggers. Pick a regular key such as F8.';

  @override
  String get errorMacroTriggerSingleKeyOnly =>
      'Each macro can only have one trigger key.';

  @override
  String get errorMacroTriggerInvalid => 'Invalid trigger key.';

  @override
  String errorMacroDuplicateTrigger(String key) {
    return 'Multiple macros use the trigger $key. Each key can only run one macro.';
  }

  @override
  String get lightingModeOff => 'Off';

  @override
  String get lightingModeStatic => 'Static';

  @override
  String get lightingModeSingleOn => 'SingleOn';

  @override
  String get lightingModeSingleOff => 'SingleOff';

  @override
  String get lightingModeGlittering => 'Glittering';

  @override
  String get lightingModeFalling => 'Falling';

  @override
  String get lightingModeColourful => 'Colourful';

  @override
  String get lightingModeBreath => 'Breath';

  @override
  String get lightingModeSpectrum => 'Spectrum';

  @override
  String get lightingModeOutward => 'Outward';

  @override
  String get lightingModeScrolling => 'Scrolling';

  @override
  String get lightingModeRolling => 'Rolling';

  @override
  String get lightingModeRotating => 'Rotating';

  @override
  String get lightingModeExplode => 'Explode';

  @override
  String get lightingModeLaunch => 'Launch';

  @override
  String get lightingModeRipples => 'Ripples';

  @override
  String get lightingModeFlowing => 'Flowing';

  @override
  String get lightingModePulsating => 'Pulsating';

  @override
  String get lightingModeTilt => 'Tilt';

  @override
  String get lightingModeShuttle => 'Shuttle';

  @override
  String get lcdTitle => 'LCD Animation';

  @override
  String lcdSubtitle(int maxFrames) {
    return 'Upload a 240×135 GIF (up to $maxFrames frames). Converts to RGB565 in Dart.';
  }

  @override
  String lcdTrimWarning(int maxFrames) {
    return 'GIFs with more than $maxFrames frames are trimmed to the first $maxFrames automatically. Enable force upload to send every frame (may overwrite menu graphics in SPI flash).';
  }

  @override
  String get forceUploadTitle => 'Force upload (use all frames)';

  @override
  String get forceUploadSubtitle => 'Dangerous — skips frame trimming';

  @override
  String get chooseGifOrBin => 'Choose GIF or .bin';

  @override
  String get convertToBin => 'Convert to .bin';

  @override
  String get uploadToKeyboard => 'Upload to keyboard';

  @override
  String selectedFile(String name) {
    return 'Selected: $name';
  }

  @override
  String get uploadDialogTitle => 'Upload LCD animation?';

  @override
  String uploadDialogBody(int maxFrames) {
    return 'Uploading images can permanently corrupt the keyboard menu graphics if too many frames are written to SPI flash. This is not recoverable by factory reset.\n\nGIFs over $maxFrames frames are trimmed automatically unless force upload is enabled.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get pendingUploadCancelled =>
      'Changes discarded. The keyboard was not updated.';

  @override
  String get upload => 'Upload';

  @override
  String get saveLcdBinary => 'Save LCD binary';

  @override
  String uploadingPercent(String percent) {
    return 'Uploading $percent%';
  }

  @override
  String savedTo(String path) {
    return 'Saved to $path';
  }

  @override
  String uploadedFrames(int frameCount, int pageCount) {
    return 'Uploaded $frameCount frames ($pageCount pages)';
  }

  @override
  String inspectFramesExact(
      int frameCount, int width, int height, int pageCount) {
    return '$frameCount frames • $width×$height • $pageCount pages';
  }

  @override
  String inspectFramesTrimmed(int frameCount, int outputFrameCount, int width,
      int height, int pageCount) {
    return '$frameCount frames → using $outputFrameCount • $width×$height • $pageCount pages';
  }

  @override
  String warningPrefix(String message) {
    return '⚠ $message';
  }

  @override
  String errorFilePicker(String error) {
    return 'Could not open file picker: $error';
  }

  @override
  String errorDeviceNotFound(String device) {
    return '$device not found. Connect via USB-C cable.';
  }

  @override
  String errorLcdInterfaceNotFound(String device) {
    return '$device LCD interface not found. Connect via USB-C cable.';
  }

  @override
  String errorFileNotFound(String path) {
    return 'File not found: $path';
  }

  @override
  String get errorSupportedFormats => 'Supported formats: .gif or .bin';

  @override
  String get errorLcdBufferTooSmall =>
      'LCD buffer is too small to contain a header.';

  @override
  String get errorLcdBufferEmpty => 'LCD buffer is empty.';

  @override
  String errorLcdBufferSizeMultiple(int size, int pageSize) {
    return 'LCD buffer size $size is not a multiple of $pageSize.';
  }

  @override
  String get errorLcdBufferZeroFrames => 'LCD buffer header reports 0 frames.';

  @override
  String errorLcdBufferTooManyFrames(int frameCount, int maxFrames) {
    return 'Buffer contains $frameCount frames, which exceeds the safe limit of $maxFrames. Enable force to override (may corrupt keyboard menu graphics).';
  }

  @override
  String errorLcdBufferTruncated(int headerFrames, int computedFrames) {
    return 'Buffer is truncated: header says $headerFrames frames but only $computedFrames fit.';
  }

  @override
  String errorLcdBufferTooManyPages(
      int pageCount, int maxPages, int maxFrames) {
    return 'Buffer is $pageCount pages, exceeding the safe limit of $maxPages pages (~$maxFrames frames). Enable force to override.';
  }

  @override
  String get errorGifNoFrames => 'GIF contains no frames.';

  @override
  String errorGifDecodeFrame(int frame) {
    return 'Failed to decode GIF frame $frame.';
  }

  @override
  String warningGifDimensions(
      int width, int height, int expectedWidth, int expectedHeight) {
    return 'GIF is ${width}x$height; keyboard expects ${expectedWidth}x$expectedHeight.';
  }

  @override
  String warningGifDimensionsCrop(
      int width, int height, int expectedWidth, int expectedHeight) {
    return 'GIF is ${width}x$height; keyboard expects ${expectedWidth}x$expectedHeight. Frames will be cropped/padded.';
  }

  @override
  String warningGifTooManyFrames(int frameCount, int maxFrames) {
    return 'GIF has $frameCount frames; only the first $maxFrames will be used.';
  }

  @override
  String warningGifCappedAt255(int frameCount) {
    return 'GIF has $frameCount frames; capped at 255 (header limit).';
  }

  @override
  String get remapTitle => 'Key Remap';

  @override
  String get remapSubtitle =>
      'Remap keys to media controls or other keys. Changes upload over USB and are saved on this computer.';

  @override
  String get remapNormalLayer => 'Normal';

  @override
  String get remapFnLayer => 'FN layer';

  @override
  String get remapBindingsTitle => 'Bindings';

  @override
  String get remapAddBinding => 'Add binding';

  @override
  String get remapEditBinding => 'Edit binding';

  @override
  String get remapRemoveBinding => 'Remove';

  @override
  String get remapNewBinding => 'New binding';

  @override
  String get remapNoBindings => 'No remaps on this layer yet.';

  @override
  String get remapEditorEmptyTitle => 'Select or add a binding';

  @override
  String get remapEditorEmptyBody =>
      'Choose a binding from the list or add one, then pick a media control or target key.';

  @override
  String get remapSourceKey => 'Source key';

  @override
  String get remapChooseSourceKey => 'Choose source key';

  @override
  String get remapChooseSourceKeyHint => 'F1–F12, letters, etc.';

  @override
  String get remapChooseTargetKey => 'Choose target key';

  @override
  String get remapChooseTargetKeyHint => 'Key to send when pressed';

  @override
  String get remapFunctionKeyHint =>
      'F1–F12 remaps use the Normal layer. Use FN layer only when the key must be held with Fn.';

  @override
  String get remapPressSourceKey => 'Or press a key…';

  @override
  String get remapCapturingSourceHint =>
      'Press a key on the keyboard to use as the source. Esc to cancel.';

  @override
  String get remapTargetType => 'Remap to';

  @override
  String get remapTargetMedia => 'Media';

  @override
  String get remapTargetKey => 'Another key';

  @override
  String get remapMediaControls => 'Media controls';

  @override
  String get remapPressTargetKey => 'Press target key…';

  @override
  String get remapCapturingTargetHint =>
      'Press the key this source should act as. Esc to cancel.';

  @override
  String remapPreview(String source, String target) {
    return '$source → $target';
  }

  @override
  String get remapApply => 'Apply to keyboard';

  @override
  String get remapUploadPending => 'Upload pending changes to the keyboard';

  @override
  String get remapUploadPendingTitle => 'Keyboard not updated yet';

  @override
  String get remapUploadPendingBody =>
      'Your remap changes are saved in this app but have not been sent to the keyboard. Apply now to make them work.';

  @override
  String get remapChangesApplied => 'Remap changes applied to the keyboard.';

  @override
  String get remapNoChangesToApply => 'No remap changes to apply.';

  @override
  String get remapPendingDelete =>
      'Pending delete — apply to remove from keyboard';

  @override
  String get remapUndoDelete => 'Undo delete';

  @override
  String remapApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count key remaps',
      one: '1 key remap',
    );
    return 'Applied $_temp0 to the keyboard.';
  }

  @override
  String get remapClearLayer => 'Clear layer';

  @override
  String get remapClearLayerTitle => 'Clear remaps on this layer?';

  @override
  String get remapClearNormalLayerBody =>
      'Marks all normal-layer remaps for deletion. Click Apply to upload the change to the keyboard.';

  @override
  String get remapClearFnLayerBody =>
      'Marks all FN-layer remaps for deletion. Click Apply to clear them on the keyboard.';

  @override
  String get remapClearLayerConfirm => 'Clear';

  @override
  String get remapLayerCleared => 'FN-layer remaps cleared on the keyboard.';

  @override
  String get remapMediaPlayPause => 'Play / Pause';

  @override
  String get remapMediaStop => 'Stop';

  @override
  String get remapMediaPrevious => 'Previous track';

  @override
  String get remapMediaNext => 'Next track';

  @override
  String get remapMediaVolumeUp => 'Volume up';

  @override
  String get remapMediaVolumeDown => 'Volume down';

  @override
  String get remapMediaMute => 'Mute';

  @override
  String get errorRemapUnsupportedKey =>
      'That key is not supported for remapping.';

  @override
  String get errorRemapNoBindings => 'Add at least one remap before applying.';

  @override
  String errorRemapConflictMacro(String key) {
    return 'Key $key is already used as a macro trigger. Clear the macro trigger or pick a different source key.';
  }

  @override
  String errorRemapDuplicateSource(String key) {
    return 'Multiple remaps use source key $key.';
  }
}
