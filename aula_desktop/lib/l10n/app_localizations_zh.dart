// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChineseSimplified => '简体中文';

  @override
  String get languageChineseTraditional => '繁體中文';

  @override
  String get navHome => '首页';

  @override
  String get navClock => '时钟';

  @override
  String get navRgb => 'RGB';

  @override
  String get navRemap => '改键';

  @override
  String get navMacro => 'Macros';

  @override
  String get navLcd => 'LCD';

  @override
  String get deviceInfoTooltip => '设备信息';

  @override
  String get close => '关闭';

  @override
  String get connected => '已连接';

  @override
  String get notConnected => '未连接';

  @override
  String get notFound => '未找到';

  @override
  String get ready => '就绪';

  @override
  String get missing => '缺失';

  @override
  String get usbIdentification => 'USB 识别';

  @override
  String get controlHidInterface => '控制 HID 接口';

  @override
  String get lcdHidInterface => 'LCD HID 接口';

  @override
  String get protocol => '协议';

  @override
  String get model => '型号';

  @override
  String get vendorId => '厂商 ID';

  @override
  String get productId => '产品 ID';

  @override
  String get status => '状态';

  @override
  String get path => '路径';

  @override
  String get usagePage => '用途页';

  @override
  String get usage => '用途';

  @override
  String get interface => '接口';

  @override
  String get hidReportSize => 'HID 报告大小';

  @override
  String get commandDelay => '命令延迟';

  @override
  String get lcdResolution => 'LCD 分辨率';

  @override
  String get pixelFormat => '像素格式';

  @override
  String get frameSize => '帧大小';

  @override
  String get maxFramesLabel => '最大帧数';

  @override
  String get flashPageSize => '闪存页大小';

  @override
  String get lcdAckTimeout => 'LCD 确认超时';

  @override
  String allHidInterfaces(int count) {
    return '所有 HID 接口（$count）';
  }

  @override
  String interfaceSummary(int number, String usagePage, int usage) {
    return '接口$number：$usagePage 用途 $usage';
  }

  @override
  String bytesUnit(int count) {
    return '$count 字节';
  }

  @override
  String millisecondsUnit(int count) {
    return '$count 毫秒';
  }

  @override
  String pixelFormatValue(int bytesPerPixel) {
    return 'RGB565（每像素 $bytesPerPixel 字节）';
  }

  @override
  String resolutionValue(int width, int height) {
    return '$width×$height';
  }

  @override
  String get keyboardCardTitle => '键盘';

  @override
  String get usbWiredRequired => '需要 USB 有线连接';

  @override
  String get lcdInterfaceCardTitle => 'LCD 接口';

  @override
  String get lcdInterfaceCardSubtitle => 'GIF 上传所需';

  @override
  String get frameLimitCardTitle => '帧数限制';

  @override
  String frameLimitValue(int count) {
    return '$count 帧';
  }

  @override
  String get frameLimitSubtitle => '240×135 RGB565';

  @override
  String get requirementsTitle => '使用要求';

  @override
  String get requirementUsb => '• 通过 USB 连接键盘（不要仅使用蓝牙）。';

  @override
  String get requirementCloseUtility => '• 使用本应用前请关闭 AULA 官方工具软件。';

  @override
  String requirementGifTrim(int maxFrames) {
    return '• 超过 $maxFrames 帧的 GIF 会自动裁剪。';
  }

  @override
  String get factoryResetTitle => '恢复出厂设置';

  @override
  String get factoryResetSubtitle => '将灯光、按键映射和宏恢复为默认设置。';

  @override
  String get factoryResetButton => '恢复出厂设置';

  @override
  String get factoryResetDialogTitle => '恢复键盘出厂设置？';

  @override
  String get factoryResetDialogBody =>
      '这将清除所有自定义按键映射、宏绑定和已录制的宏，并恢复默认灯光配置。\n\n不会影响 LCD 动画和屏幕菜单图形。若要重置这些，请重新上传原始 GIF，或在键盘上按住 Fn + Esc 5 秒。';

  @override
  String factoryResetSuccess(String mode) {
    return '恢复出厂设置完成。已清除按键映射和宏。灯光已恢复为 $mode。';
  }

  @override
  String get clockTitle => 'LCD 时钟';

  @override
  String get clockSubtitle => '通过 USB 同步键盘屏幕时钟。';

  @override
  String get useCustomDateTime => '使用自定义日期/时间';

  @override
  String get useCustomDateTimeSubtitle => '关闭 = 立即同步系统时间';

  @override
  String get date => '日期';

  @override
  String get time => '时间';

  @override
  String get syncCustomTime => '同步自定义时间';

  @override
  String get syncSystemTime => '同步系统时间';

  @override
  String syncedTo(String datetime) {
    return '已同步至 $datetime';
  }

  @override
  String get rgbTitle => 'RGB 灯光';

  @override
  String get rgbSubtitle => '设置背光模式、颜色、亮度和速度。';

  @override
  String get mode => '模式';

  @override
  String lightingModeEntry(String index, String name) {
    return '$index — $name';
  }

  @override
  String get rainbowColorful => '彩虹 / 多彩';

  @override
  String colorRgbValue(int r, int g, int b) {
    return 'RGB（$r，$g，$b）';
  }

  @override
  String get colorRed => '红';

  @override
  String get colorGreen => '绿';

  @override
  String get colorBlue => '蓝';

  @override
  String colorHsvValue(int h, int s, int v) {
    return 'HSV ($h, $s, $v)';
  }

  @override
  String brightness(int value) {
    return '亮度：$value';
  }

  @override
  String speed(int value) {
    return '速度：$value';
  }

  @override
  String direction(int value) {
    return '方向：$value';
  }

  @override
  String get apply => '应用';

  @override
  String get turnOff => '关闭';

  @override
  String appliedMode(String mode) {
    return '已应用 $mode';
  }

  @override
  String get backlightTurnedOff => '背光已关闭';

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
  String get lightingModeOff => '关闭';

  @override
  String get lightingModeStatic => '常亮';

  @override
  String get lightingModeSingleOn => '单键亮';

  @override
  String get lightingModeSingleOff => '单键灭';

  @override
  String get lightingModeGlittering => '闪烁';

  @override
  String get lightingModeFalling => '下落';

  @override
  String get lightingModeColourful => '多彩';

  @override
  String get lightingModeBreath => '呼吸';

  @override
  String get lightingModeSpectrum => '光谱';

  @override
  String get lightingModeOutward => '向外';

  @override
  String get lightingModeScrolling => '滚动';

  @override
  String get lightingModeRolling => '旋转滚动';

  @override
  String get lightingModeRotating => '旋转';

  @override
  String get lightingModeExplode => '爆炸';

  @override
  String get lightingModeLaunch => '发射';

  @override
  String get lightingModeRipples => '涟漪';

  @override
  String get lightingModeFlowing => '流动';

  @override
  String get lightingModePulsating => '脉动';

  @override
  String get lightingModeTilt => '倾斜';

  @override
  String get lightingModeShuttle => '穿梭';

  @override
  String get lcdTitle => 'LCD 动画';

  @override
  String lcdSubtitle(int maxFrames) {
    return '上传 240×135 GIF（最多 $maxFrames 帧）。在 Dart 中转换为 RGB565。';
  }

  @override
  String lcdTrimWarning(int maxFrames) {
    return '超过 $maxFrames 帧的 GIF 会自动裁剪为前 $maxFrames 帧。启用强制上传可发送所有帧（可能覆盖 SPI 闪存中的菜单图形）。';
  }

  @override
  String get forceUploadTitle => '强制上传（使用所有帧）';

  @override
  String get forceUploadSubtitle => '危险 — 跳过帧裁剪';

  @override
  String get chooseGifOrBin => '选择 GIF 或 .bin';

  @override
  String get convertToBin => '转换为 .bin';

  @override
  String get uploadToKeyboard => '上传到键盘';

  @override
  String selectedFile(String name) {
    return '已选择：$name';
  }

  @override
  String get uploadDialogTitle => '上传 LCD 动画？';

  @override
  String uploadDialogBody(int maxFrames) {
    return '如果写入 SPI 闪存的帧数过多，上传图片可能会永久损坏键盘菜单图形，且无法通过恢复出厂设置修复。\n\n除非启用强制上传，否则超过 $maxFrames 帧的 GIF 会自动裁剪。';
  }

  @override
  String get cancel => '取消';

  @override
  String get upload => '上传';

  @override
  String get saveLcdBinary => '保存 LCD 二进制文件';

  @override
  String uploadingPercent(String percent) {
    return '上传中 $percent%';
  }

  @override
  String savedTo(String path) {
    return '已保存至 $path';
  }

  @override
  String uploadedFrames(int frameCount, int pageCount) {
    return '已上传 $frameCount 帧（$pageCount 页）';
  }

  @override
  String inspectFramesExact(
      int frameCount, int width, int height, int pageCount) {
    return '$frameCount 帧 • $width×$height • $pageCount 页';
  }

  @override
  String inspectFramesTrimmed(int frameCount, int outputFrameCount, int width,
      int height, int pageCount) {
    return '$frameCount 帧 → 使用 $outputFrameCount 帧 • $width×$height • $pageCount 页';
  }

  @override
  String warningPrefix(String message) {
    return '⚠ $message';
  }

  @override
  String errorFilePicker(String error) {
    return '无法打开文件选择器：$error';
  }

  @override
  String errorDeviceNotFound(String device) {
    return '未找到 $device。请通过 USB-C 线缆连接。';
  }

  @override
  String errorLcdInterfaceNotFound(String device) {
    return '未找到 $device 的 LCD 接口。请通过 USB-C 线缆连接。';
  }

  @override
  String errorFileNotFound(String path) {
    return '文件未找到：$path';
  }

  @override
  String get errorSupportedFormats => '支持的格式：.gif 或 .bin';

  @override
  String get errorLcdBufferTooSmall => 'LCD 缓冲区太小，无法包含文件头。';

  @override
  String get errorLcdBufferEmpty => 'LCD 缓冲区为空。';

  @override
  String errorLcdBufferSizeMultiple(int size, int pageSize) {
    return 'LCD 缓冲区大小 $size 不是 $pageSize 的倍数。';
  }

  @override
  String get errorLcdBufferZeroFrames => 'LCD 缓冲区文件头报告 0 帧。';

  @override
  String errorLcdBufferTooManyFrames(int frameCount, int maxFrames) {
    return '缓冲区包含 $frameCount 帧，超过安全限制 $maxFrames 帧。启用强制模式可覆盖（可能损坏键盘菜单图形）。';
  }

  @override
  String errorLcdBufferTruncated(int headerFrames, int computedFrames) {
    return '缓冲区被截断：文件头显示 $headerFrames 帧，但只能容纳 $computedFrames 帧。';
  }

  @override
  String errorLcdBufferTooManyPages(
      int pageCount, int maxPages, int maxFrames) {
    return '缓冲区为 $pageCount 页，超过安全限制 $maxPages 页（约 $maxFrames 帧）。启用强制模式可覆盖。';
  }

  @override
  String get errorGifNoFrames => 'GIF 不包含任何帧。';

  @override
  String errorGifDecodeFrame(int frame) {
    return '无法解码 GIF 第 $frame 帧。';
  }

  @override
  String warningGifDimensions(
      int width, int height, int expectedWidth, int expectedHeight) {
    return 'GIF 为 ${width}x$height；键盘需要 ${expectedWidth}x$expectedHeight。';
  }

  @override
  String warningGifDimensionsCrop(
      int width, int height, int expectedWidth, int expectedHeight) {
    return 'GIF 为 ${width}x$height；键盘需要 ${expectedWidth}x$expectedHeight。帧将被裁剪/填充。';
  }

  @override
  String warningGifTooManyFrames(int frameCount, int maxFrames) {
    return 'GIF 有 $frameCount 帧；仅使用前 $maxFrames 帧。';
  }

  @override
  String warningGifCappedAt255(int frameCount) {
    return 'GIF 有 $frameCount 帧；已限制为 255 帧（文件头上限）。';
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

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChineseSimplified => '简体中文';

  @override
  String get languageChineseTraditional => '繁體中文';

  @override
  String get navHome => '首页';

  @override
  String get navClock => '时钟';

  @override
  String get navRgb => 'RGB';

  @override
  String get navRemap => '改键';

  @override
  String get navMacro => '宏';

  @override
  String get navLcd => 'LCD';

  @override
  String get deviceInfoTooltip => '设备信息';

  @override
  String get close => '关闭';

  @override
  String get connected => '已连接';

  @override
  String get notConnected => '未连接';

  @override
  String get notFound => '未找到';

  @override
  String get ready => '就绪';

  @override
  String get missing => '缺失';

  @override
  String get usbIdentification => 'USB 识别';

  @override
  String get controlHidInterface => '控制 HID 接口';

  @override
  String get lcdHidInterface => 'LCD HID 接口';

  @override
  String get protocol => '协议';

  @override
  String get model => '型号';

  @override
  String get vendorId => '厂商 ID';

  @override
  String get productId => '产品 ID';

  @override
  String get status => '状态';

  @override
  String get path => '路径';

  @override
  String get usagePage => '用途页';

  @override
  String get usage => '用途';

  @override
  String get interface => '接口';

  @override
  String get hidReportSize => 'HID 报告大小';

  @override
  String get commandDelay => '命令延迟';

  @override
  String get lcdResolution => 'LCD 分辨率';

  @override
  String get pixelFormat => '像素格式';

  @override
  String get frameSize => '帧大小';

  @override
  String get maxFramesLabel => '最大帧数';

  @override
  String get flashPageSize => '闪存页大小';

  @override
  String get lcdAckTimeout => 'LCD 确认超时';

  @override
  String allHidInterfaces(int count) {
    return '所有 HID 接口（$count）';
  }

  @override
  String interfaceSummary(int number, String usagePage, int usage) {
    return '接口$number：$usagePage 用途 $usage';
  }

  @override
  String bytesUnit(int count) {
    return '$count 字节';
  }

  @override
  String millisecondsUnit(int count) {
    return '$count 毫秒';
  }

  @override
  String pixelFormatValue(int bytesPerPixel) {
    return 'RGB565（每像素 $bytesPerPixel 字节）';
  }

  @override
  String resolutionValue(int width, int height) {
    return '$width×$height';
  }

  @override
  String get keyboardCardTitle => '键盘';

  @override
  String get usbWiredRequired => '需要 USB 有线连接';

  @override
  String get lcdInterfaceCardTitle => 'LCD 接口';

  @override
  String get lcdInterfaceCardSubtitle => 'GIF 上传所需';

  @override
  String get frameLimitCardTitle => '帧数限制';

  @override
  String frameLimitValue(int count) {
    return '$count 帧';
  }

  @override
  String get frameLimitSubtitle => '240×135 RGB565';

  @override
  String get requirementsTitle => '使用要求';

  @override
  String get requirementUsb => '• 通过 USB 连接键盘（不要仅使用蓝牙）。';

  @override
  String get requirementCloseUtility => '• 使用本应用前请关闭 AULA 官方工具软件。';

  @override
  String requirementGifTrim(int maxFrames) {
    return '• 超过 $maxFrames 帧的 GIF 会自动裁剪。';
  }

  @override
  String get factoryResetTitle => '恢复出厂设置';

  @override
  String get factoryResetSubtitle => '将灯光、按键映射和宏恢复为默认设置。';

  @override
  String get factoryResetButton => '恢复出厂设置';

  @override
  String get factoryResetDialogTitle => '恢复键盘出厂设置？';

  @override
  String get factoryResetDialogBody =>
      '这将清除所有自定义按键映射、宏绑定和已录制的宏，并恢复默认灯光配置。\n\n不会影响 LCD 动画和屏幕菜单图形。若要重置这些，请重新上传原始 GIF，或在键盘上按住 Fn + Esc 5 秒。';

  @override
  String factoryResetSuccess(String mode) {
    return '恢复出厂设置完成。已清除按键映射和宏。灯光已恢复为 $mode。';
  }

  @override
  String get clockTitle => 'LCD 时钟';

  @override
  String get clockSubtitle => '通过 USB 同步键盘屏幕时钟。';

  @override
  String get useCustomDateTime => '使用自定义日期/时间';

  @override
  String get useCustomDateTimeSubtitle => '关闭 = 立即同步系统时间';

  @override
  String get date => '日期';

  @override
  String get time => '时间';

  @override
  String get syncCustomTime => '同步自定义时间';

  @override
  String get syncSystemTime => '同步系统时间';

  @override
  String syncedTo(String datetime) {
    return '已同步至 $datetime';
  }

  @override
  String get rgbTitle => 'RGB 灯光';

  @override
  String get rgbSubtitle => '设置背光模式、颜色、亮度和速度。';

  @override
  String get mode => '模式';

  @override
  String lightingModeEntry(String index, String name) {
    return '$index — $name';
  }

  @override
  String get rainbowColorful => '彩虹 / 多彩';

  @override
  String colorRgbValue(int r, int g, int b) {
    return 'RGB（$r，$g，$b）';
  }

  @override
  String get colorRed => '红';

  @override
  String get colorGreen => '绿';

  @override
  String get colorBlue => '蓝';

  @override
  String colorHsvValue(int h, int s, int v) {
    return 'HSV（$h，$s，$v）';
  }

  @override
  String brightness(int value) {
    return '亮度：$value';
  }

  @override
  String speed(int value) {
    return '速度：$value';
  }

  @override
  String direction(int value) {
    return '方向：$value';
  }

  @override
  String get apply => '应用';

  @override
  String get turnOff => '关闭';

  @override
  String appliedMode(String mode) {
    return '已应用 $mode';
  }

  @override
  String get backlightTurnedOff => '背光已关闭';

  @override
  String get macroTitle => '宏';

  @override
  String get macroSubtitle => '录制键盘序列，指定触发键，并通过 USB 上传。按下触发键即可运行宏。';

  @override
  String get macroListTitle => '宏槽位';

  @override
  String get macroAdd => '添加宏';

  @override
  String get macroName => '名称';

  @override
  String get macroDelayMode => '事件间隔';

  @override
  String get macroPlaybackMode => '播放模式';

  @override
  String get macroPlaybackModeHint => '按下触发键时宏如何运行。';

  @override
  String get macroPlaybackOnce => '播放一次或重复 N 次';

  @override
  String get macroPlaybackToggle => '开关切换';

  @override
  String get macroMaxRepeats => '最大重复次数';

  @override
  String get macroMaxRepeatsHint => '每次按下触发键时宏运行的次数（1–99）。仅在播放一次模式下使用。';

  @override
  String get macroDelayRecorded => '使用录制延迟';

  @override
  String get macroDelayNone => '无延迟';

  @override
  String get macroDelayCustom => '固定延迟';

  @override
  String get macroDelayMs => '延迟（毫秒）';

  @override
  String get macroRecordingHint => '正在录制…请按下键盘按键。按 Esc 停止。';

  @override
  String get macroNoEvents => '尚无事件。点击“录制”并按键。';

  @override
  String macroEventCount(int count) {
    return '$count 个事件';
  }

  @override
  String macroListEntryWithTrigger(int count, String key) {
    return '$count 个事件 • 触发键：$key';
  }

  @override
  String get macroTriggerTitle => '触发键';

  @override
  String get macroTriggerNone => '未指定触发键。';

  @override
  String macroTriggerAssigned(String key) {
    return '在键盘上按下 $key 可运行此宏。';
  }

  @override
  String get macroTriggerSingleKeyNote =>
      '每个宏只能使用一个触发键。修饰键快捷键（如 Ctrl+C）应录在宏序列里，而不是作为触发键。';

  @override
  String warningMacroTriggerOverlap(String keys) {
    return '警告：$keys 也包含在此宏序列中。请使用不在序列内的触发键（例如功能键）。';
  }

  @override
  String macroTriggerPending(String keys, int count) {
    return '已选：$keys（$count/3）。按 Enter 或点击确认。';
  }

  @override
  String get macroConfirmTrigger => '确认';

  @override
  String get macroAssignTrigger => '指定触发键';

  @override
  String get macroClearTrigger => '清除触发键';

  @override
  String get macroAssigningTriggerHint => '按下一个键作为宏触发键。Esc 取消。';

  @override
  String get macroActionDown => '按下';

  @override
  String get macroActionUp => '释放';

  @override
  String get macroActionDelay => '延迟';

  @override
  String macroGapDelay(int ms) {
    return '间隔：$ms 毫秒';
  }

  @override
  String get macroRecord => '录制';

  @override
  String get macroStop => '停止';

  @override
  String get macroClear => '清除事件';

  @override
  String get macroClearHint => '清除应用和键盘上录制的按键事件。';

  @override
  String get macroEventsCleared => '已清除键盘上的宏事件。';

  @override
  String get macroDelete => '删除宏';

  @override
  String get macroUpload => '上传到键盘';

  @override
  String macroUploaded(int macroCount, int eventCount) {
    return '已上传 $macroCount 个宏，共 $eventCount 个事件';
  }

  @override
  String macroUploadedWithBinding(
      int macroCount, int eventCount, int bindingCount) {
    return '已上传 $macroCount 个宏，共 $eventCount 个事件，并绑定了 $bindingCount 个触发键。';
  }

  @override
  String macroUploadedAssignTrigger(int macroCount, int eventCount) {
    return '已上传 $macroCount 个宏，共 $eventCount 个事件。请指定触发键以运行宏。';
  }

  @override
  String get errorMacroEmpty => '上传前请至少添加一个包含录制事件的宏。';

  @override
  String errorMacroTooManyMacros(int count) {
    return '宏数量过多（$count）。键盘最多支持 100 个。';
  }

  @override
  String errorMacroTooLarge(int macros, int events) {
    return '宏数据过大（$macros 个宏，$events 个事件）。请减少宏或事件数量。';
  }

  @override
  String get errorMacroUnsupportedKey => '该按键不支持用于宏。';

  @override
  String get errorMacroUnsupportedTriggerKey => '该按键不能用作宏触发键。';

  @override
  String get errorMacroTriggerModifierNotAllowed =>
      '修饰键不能作为宏触发键。请选择一个普通按键，例如 F8。';

  @override
  String get errorMacroTriggerSingleKeyOnly => '每个宏只能有一个触发键。';

  @override
  String get errorMacroTriggerInvalid => '无效的触发键。';

  @override
  String errorMacroDuplicateTrigger(String key) {
    return '多个宏使用了触发键 $key。每个键只能运行一个宏。';
  }

  @override
  String get lightingModeOff => '关闭';

  @override
  String get lightingModeStatic => '常亮';

  @override
  String get lightingModeSingleOn => '单键亮';

  @override
  String get lightingModeSingleOff => '单键灭';

  @override
  String get lightingModeGlittering => '闪烁';

  @override
  String get lightingModeFalling => '下落';

  @override
  String get lightingModeColourful => '多彩';

  @override
  String get lightingModeBreath => '呼吸';

  @override
  String get lightingModeSpectrum => '光谱';

  @override
  String get lightingModeOutward => '向外';

  @override
  String get lightingModeScrolling => '滚动';

  @override
  String get lightingModeRolling => '旋转滚动';

  @override
  String get lightingModeRotating => '旋转';

  @override
  String get lightingModeExplode => '爆炸';

  @override
  String get lightingModeLaunch => '发射';

  @override
  String get lightingModeRipples => '涟漪';

  @override
  String get lightingModeFlowing => '流动';

  @override
  String get lightingModePulsating => '脉动';

  @override
  String get lightingModeTilt => '倾斜';

  @override
  String get lightingModeShuttle => '穿梭';

  @override
  String get lcdTitle => 'LCD 动画';

  @override
  String lcdSubtitle(int maxFrames) {
    return '上传 240×135 GIF（最多 $maxFrames 帧）。在 Dart 中转换为 RGB565。';
  }

  @override
  String lcdTrimWarning(int maxFrames) {
    return '超过 $maxFrames 帧的 GIF 会自动裁剪为前 $maxFrames 帧。启用强制上传可发送所有帧（可能覆盖 SPI 闪存中的菜单图形）。';
  }

  @override
  String get forceUploadTitle => '强制上传（使用所有帧）';

  @override
  String get forceUploadSubtitle => '危险 — 跳过帧裁剪';

  @override
  String get chooseGifOrBin => '选择 GIF 或 .bin';

  @override
  String get convertToBin => '转换为 .bin';

  @override
  String get uploadToKeyboard => '上传到键盘';

  @override
  String selectedFile(String name) {
    return '已选择：$name';
  }

  @override
  String get uploadDialogTitle => '上传 LCD 动画？';

  @override
  String uploadDialogBody(int maxFrames) {
    return '如果写入 SPI 闪存的帧数过多，上传图片可能会永久损坏键盘菜单图形，且无法通过恢复出厂设置修复。\n\n除非启用强制上传，否则超过 $maxFrames 帧的 GIF 会自动裁剪。';
  }

  @override
  String get cancel => '取消';

  @override
  String get upload => '上传';

  @override
  String get saveLcdBinary => '保存 LCD 二进制文件';

  @override
  String uploadingPercent(String percent) {
    return '上传中 $percent%';
  }

  @override
  String savedTo(String path) {
    return '已保存至 $path';
  }

  @override
  String uploadedFrames(int frameCount, int pageCount) {
    return '已上传 $frameCount 帧（$pageCount 页）';
  }

  @override
  String inspectFramesExact(
      int frameCount, int width, int height, int pageCount) {
    return '$frameCount 帧 • $width×$height • $pageCount 页';
  }

  @override
  String inspectFramesTrimmed(int frameCount, int outputFrameCount, int width,
      int height, int pageCount) {
    return '$frameCount 帧 → 使用 $outputFrameCount 帧 • $width×$height • $pageCount 页';
  }

  @override
  String warningPrefix(String message) {
    return '⚠ $message';
  }

  @override
  String errorFilePicker(String error) {
    return '无法打开文件选择器：$error';
  }

  @override
  String errorDeviceNotFound(String device) {
    return '未找到 $device。请通过 USB-C 线缆连接。';
  }

  @override
  String errorLcdInterfaceNotFound(String device) {
    return '未找到 $device 的 LCD 接口。请通过 USB-C 线缆连接。';
  }

  @override
  String errorFileNotFound(String path) {
    return '文件未找到：$path';
  }

  @override
  String get errorSupportedFormats => '支持的格式：.gif 或 .bin';

  @override
  String get errorLcdBufferTooSmall => 'LCD 缓冲区太小，无法包含文件头。';

  @override
  String get errorLcdBufferEmpty => 'LCD 缓冲区为空。';

  @override
  String errorLcdBufferSizeMultiple(int size, int pageSize) {
    return 'LCD 缓冲区大小 $size 不是 $pageSize 的倍数。';
  }

  @override
  String get errorLcdBufferZeroFrames => 'LCD 缓冲区文件头报告 0 帧。';

  @override
  String errorLcdBufferTooManyFrames(int frameCount, int maxFrames) {
    return '缓冲区包含 $frameCount 帧，超过安全限制 $maxFrames 帧。启用强制模式可覆盖（可能损坏键盘菜单图形）。';
  }

  @override
  String errorLcdBufferTruncated(int headerFrames, int computedFrames) {
    return '缓冲区被截断：文件头显示 $headerFrames 帧，但只能容纳 $computedFrames 帧。';
  }

  @override
  String errorLcdBufferTooManyPages(
      int pageCount, int maxPages, int maxFrames) {
    return '缓冲区为 $pageCount 页，超过安全限制 $maxPages 页（约 $maxFrames 帧）。启用强制模式可覆盖。';
  }

  @override
  String get errorGifNoFrames => 'GIF 不包含任何帧。';

  @override
  String errorGifDecodeFrame(int frame) {
    return '无法解码 GIF 第 $frame 帧。';
  }

  @override
  String warningGifDimensions(
      int width, int height, int expectedWidth, int expectedHeight) {
    return 'GIF 为 ${width}x$height；键盘需要 ${expectedWidth}x$expectedHeight。';
  }

  @override
  String warningGifDimensionsCrop(
      int width, int height, int expectedWidth, int expectedHeight) {
    return 'GIF 为 ${width}x$height；键盘需要 ${expectedWidth}x$expectedHeight。帧将被裁剪/填充。';
  }

  @override
  String warningGifTooManyFrames(int frameCount, int maxFrames) {
    return 'GIF 有 $frameCount 帧；仅使用前 $maxFrames 帧。';
  }

  @override
  String warningGifCappedAt255(int frameCount) {
    return 'GIF 有 $frameCount 帧；已限制为 255 帧（文件头上限）。';
  }

  @override
  String get remapTitle => '按键改键';

  @override
  String get remapSubtitle => '将按键映射为媒体控制或其他按键。通过 USB 上传，并保存在本机。';

  @override
  String get remapNormalLayer => '普通层';

  @override
  String get remapFnLayer => 'FN 层';

  @override
  String get remapBindingsTitle => '映射列表';

  @override
  String get remapAddBinding => '添加映射';

  @override
  String get remapEditBinding => '编辑映射';

  @override
  String get remapRemoveBinding => '删除';

  @override
  String get remapNewBinding => '新映射';

  @override
  String get remapNoBindings => '此层尚无改键。';

  @override
  String get remapEditorEmptyTitle => '选择或添加映射';

  @override
  String get remapEditorEmptyBody => '从列表选择或添加映射，然后选择媒体控制或目标按键。';

  @override
  String get remapSourceKey => '源按键';

  @override
  String get remapChooseSourceKey => '选择源按键';

  @override
  String get remapChooseSourceKeyHint => 'F1–F12、字母键等';

  @override
  String get remapChooseTargetKey => '选择目标按键';

  @override
  String get remapChooseTargetKeyHint => '按下源键时发送的按键';

  @override
  String get remapFunctionKeyHint => 'F1–F12 改键请使用普通层。仅在需要按住 Fn 时才使用 FN 层。';

  @override
  String get remapPressSourceKey => '或按下按键…';

  @override
  String get remapCapturingSourceHint => '在键盘上按下要改键的按键。按 Esc 取消。';

  @override
  String get remapTargetType => '映射为';

  @override
  String get remapTargetMedia => '媒体';

  @override
  String get remapTargetKey => '其他按键';

  @override
  String get remapMediaControls => '媒体控制';

  @override
  String get remapPressTargetKey => '按下目标按键…';

  @override
  String get remapCapturingTargetHint => '按下此源键应触发的目标按键。按 Esc 取消。';

  @override
  String remapPreview(String source, String target) {
    return '$source → $target';
  }

  @override
  String get remapApply => '上传到键盘';

  @override
  String get remapChangesApplied => '改键更改已上传到键盘。';

  @override
  String get remapNoChangesToApply => '没有可上传的改键更改。';

  @override
  String get remapPendingDelete => '待删除 — 上传后从键盘移除';

  @override
  String get remapUndoDelete => '撤销删除';

  @override
  String remapApplied(int count) {
    return '已向键盘应用 $count 个改键。';
  }

  @override
  String get remapClearLayer => '清空此层';

  @override
  String get remapClearLayerTitle => '清空此层的改键？';

  @override
  String get remapClearNormalLayerBody => '将标记普通层上的所有改键为待删除。点击「上传到键盘」以同步到键盘。';

  @override
  String get remapClearFnLayerBody => '将标记 FN 层上的所有改键为待删除。点击「上传到键盘」以从键盘清除。';

  @override
  String get remapClearLayerConfirm => '清空';

  @override
  String get remapLayerCleared => '已清空键盘上的 FN 层改键。';

  @override
  String get remapMediaPlayPause => '播放 / 暂停';

  @override
  String get remapMediaStop => '停止';

  @override
  String get remapMediaPrevious => '上一曲';

  @override
  String get remapMediaNext => '下一曲';

  @override
  String get remapMediaVolumeUp => '音量加';

  @override
  String get remapMediaVolumeDown => '音量减';

  @override
  String get remapMediaMute => '静音';

  @override
  String get errorRemapUnsupportedKey => '该按键不支持改键。';

  @override
  String get errorRemapNoBindings => '请先添加至少一个改键再上传。';

  @override
  String errorRemapConflictMacro(String key) {
    return '按键 $key 已用作宏触发键。请清除宏触发键或选择其他源按键。';
  }

  @override
  String errorRemapDuplicateSource(String key) {
    return '多个改键使用了源按键 $key。';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get language => '語言';

  @override
  String get languageSystem => '跟隨系統';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChineseSimplified => '简体中文';

  @override
  String get languageChineseTraditional => '繁體中文';

  @override
  String get navHome => '首頁';

  @override
  String get navClock => '時鐘';

  @override
  String get navRgb => 'RGB';

  @override
  String get navRemap => '改鍵';

  @override
  String get navMacro => '巨集';

  @override
  String get navLcd => 'LCD';

  @override
  String get deviceInfoTooltip => '裝置資訊';

  @override
  String get close => '關閉';

  @override
  String get connected => '已連接';

  @override
  String get notConnected => '未連接';

  @override
  String get notFound => '未找到';

  @override
  String get ready => '就緒';

  @override
  String get missing => '缺失';

  @override
  String get usbIdentification => 'USB 識別';

  @override
  String get controlHidInterface => '控制 HID 介面';

  @override
  String get lcdHidInterface => 'LCD HID 介面';

  @override
  String get protocol => '協定';

  @override
  String get model => '型號';

  @override
  String get vendorId => '廠商 ID';

  @override
  String get productId => '產品 ID';

  @override
  String get status => '狀態';

  @override
  String get path => '路徑';

  @override
  String get usagePage => '用途頁';

  @override
  String get usage => '用途';

  @override
  String get interface => '介面';

  @override
  String get hidReportSize => 'HID 報告大小';

  @override
  String get commandDelay => '命令延遲';

  @override
  String get lcdResolution => 'LCD 解析度';

  @override
  String get pixelFormat => '像素格式';

  @override
  String get frameSize => '幀大小';

  @override
  String get maxFramesLabel => '最大幀數';

  @override
  String get flashPageSize => '快閃記憶體頁大小';

  @override
  String get lcdAckTimeout => 'LCD 確認逾時';

  @override
  String allHidInterfaces(int count) {
    return '所有 HID 介面（$count）';
  }

  @override
  String interfaceSummary(int number, String usagePage, int usage) {
    return '介面$number：$usagePage 用途 $usage';
  }

  @override
  String bytesUnit(int count) {
    return '$count 位元組';
  }

  @override
  String millisecondsUnit(int count) {
    return '$count 毫秒';
  }

  @override
  String pixelFormatValue(int bytesPerPixel) {
    return 'RGB565（每像素 $bytesPerPixel 位元組）';
  }

  @override
  String resolutionValue(int width, int height) {
    return '$width×$height';
  }

  @override
  String get keyboardCardTitle => '鍵盤';

  @override
  String get usbWiredRequired => '需要 USB 有線連接';

  @override
  String get lcdInterfaceCardTitle => 'LCD 介面';

  @override
  String get lcdInterfaceCardSubtitle => 'GIF 上傳所需';

  @override
  String get frameLimitCardTitle => '幀數限制';

  @override
  String frameLimitValue(int count) {
    return '$count 幀';
  }

  @override
  String get frameLimitSubtitle => '240×135 RGB565';

  @override
  String get requirementsTitle => '使用要求';

  @override
  String get requirementUsb => '• 透過 USB 連接鍵盤（不要僅使用藍牙）。';

  @override
  String get requirementCloseUtility => '• 使用本應用程式前請關閉 AULA 官方工具軟體。';

  @override
  String requirementGifTrim(int maxFrames) {
    return '• 超過 $maxFrames 幀的 GIF 會自動裁剪。';
  }

  @override
  String get factoryResetTitle => '恢復出廠設定';

  @override
  String get factoryResetSubtitle => '將燈光、按鍵對應和巨集恢復為預設值。';

  @override
  String get factoryResetButton => '恢復出廠設定';

  @override
  String get factoryResetDialogTitle => '恢復鍵盤出廠設定？';

  @override
  String get factoryResetDialogBody =>
      '這將清除所有自訂按鍵對應、巨集綁定和已錄製的巨集，並恢復預設燈光設定。\n\n不會影響 LCD 動畫和螢幕選單圖形。若要重置這些，請重新上傳原始 GIF，或在鍵盤上按住 Fn + Esc 5 秒。';

  @override
  String factoryResetSuccess(String mode) {
    return '恢復出廠設定完成。已清除按鍵對應和巨集。燈光已恢復為 $mode。';
  }

  @override
  String get clockTitle => 'LCD 時鐘';

  @override
  String get clockSubtitle => '透過 USB 同步鍵盤螢幕時鐘。';

  @override
  String get useCustomDateTime => '使用自訂日期/時間';

  @override
  String get useCustomDateTimeSubtitle => '關閉 = 立即同步系統時間';

  @override
  String get date => '日期';

  @override
  String get time => '時間';

  @override
  String get syncCustomTime => '同步自訂時間';

  @override
  String get syncSystemTime => '同步系統時間';

  @override
  String syncedTo(String datetime) {
    return '已同步至 $datetime';
  }

  @override
  String get rgbTitle => 'RGB 燈光';

  @override
  String get rgbSubtitle => '設定背光模式、顏色、亮度和速度。';

  @override
  String get mode => '模式';

  @override
  String lightingModeEntry(String index, String name) {
    return '$index — $name';
  }

  @override
  String get rainbowColorful => '彩虹 / 多彩';

  @override
  String colorRgbValue(int r, int g, int b) {
    return 'RGB（$r，$g，$b）';
  }

  @override
  String get colorRed => '紅';

  @override
  String get colorGreen => '綠';

  @override
  String get colorBlue => '藍';

  @override
  String colorHsvValue(int h, int s, int v) {
    return 'HSV（$h，$s，$v）';
  }

  @override
  String brightness(int value) {
    return '亮度：$value';
  }

  @override
  String speed(int value) {
    return '速度：$value';
  }

  @override
  String direction(int value) {
    return '方向：$value';
  }

  @override
  String get apply => '套用';

  @override
  String get turnOff => '關閉';

  @override
  String appliedMode(String mode) {
    return '已套用 $mode';
  }

  @override
  String get backlightTurnedOff => '背光已關閉';

  @override
  String get macroTitle => '巨集';

  @override
  String get macroSubtitle => '錄製鍵盤序列，指定觸發鍵，並透過 USB 上傳。按下觸發鍵即可執行巨集。';

  @override
  String get macroListTitle => '巨集槽位';

  @override
  String get macroAdd => '新增巨集';

  @override
  String get macroName => '名稱';

  @override
  String get macroDelayMode => '事件間隔';

  @override
  String get macroPlaybackMode => '播放模式';

  @override
  String get macroPlaybackModeHint => '按下觸發鍵時巨集如何執行。';

  @override
  String get macroPlaybackOnce => '播放一次或重複 N 次';

  @override
  String get macroPlaybackToggle => '開關切換';

  @override
  String get macroMaxRepeats => '最大重複次數';

  @override
  String get macroMaxRepeatsHint => '每次按下觸發鍵時巨集執行的次數（1–99）。僅在播放一次模式下使用。';

  @override
  String get macroDelayRecorded => '使用錄製延遲';

  @override
  String get macroDelayNone => '無延遲';

  @override
  String get macroDelayCustom => '固定延遲';

  @override
  String get macroDelayMs => '延遲（毫秒）';

  @override
  String get macroRecordingHint => '正在錄製…請按下鍵盤按鍵。按 Esc 停止。';

  @override
  String get macroNoEvents => '尚無事件。點擊「錄製」並按鍵。';

  @override
  String macroEventCount(int count) {
    return '$count 個事件';
  }

  @override
  String macroListEntryWithTrigger(int count, String key) {
    return '$count 個事件 • 觸發鍵：$key';
  }

  @override
  String get macroTriggerTitle => '觸發鍵';

  @override
  String get macroTriggerNone => '未指定觸發鍵。';

  @override
  String macroTriggerAssigned(String key) {
    return '在鍵盤上按下 $key 可執行此巨集。';
  }

  @override
  String get macroTriggerSingleKeyNote =>
      '每個巨集只能使用一個觸發鍵。修飾鍵快捷鍵（如 Ctrl+C）應錄在巨集序列裡，而不是作為觸發鍵。';

  @override
  String warningMacroTriggerOverlap(String keys) {
    return '警告：$keys 也包含在此巨集序列中。請使用不在序列內的觸發鍵（例如功能鍵）。';
  }

  @override
  String macroTriggerPending(String keys, int count) {
    return '已選：$keys（$count/3）。按 Enter 或點擊確認。';
  }

  @override
  String get macroConfirmTrigger => '確認';

  @override
  String get macroAssignTrigger => '指定觸發鍵';

  @override
  String get macroClearTrigger => '清除觸發鍵';

  @override
  String get macroAssigningTriggerHint => '按下一個鍵作為巨集觸發鍵。Esc 取消。';

  @override
  String get macroActionDown => '按下';

  @override
  String get macroActionUp => '放開';

  @override
  String get macroActionDelay => '延遲';

  @override
  String macroGapDelay(int ms) {
    return '間隔：$ms 毫秒';
  }

  @override
  String get macroRecord => '錄製';

  @override
  String get macroStop => '停止';

  @override
  String get macroClear => '清除事件';

  @override
  String get macroClearHint => '清除應用程式和鍵盤上錄製的按鍵事件。';

  @override
  String get macroEventsCleared => '已清除鍵盤上的巨集事件。';

  @override
  String get macroDelete => '刪除巨集';

  @override
  String get macroUpload => '上傳到鍵盤';

  @override
  String macroUploaded(int macroCount, int eventCount) {
    return '已上傳 $macroCount 個巨集，共 $eventCount 個事件';
  }

  @override
  String macroUploadedWithBinding(
      int macroCount, int eventCount, int bindingCount) {
    return '已上傳 $macroCount 個巨集，共 $eventCount 個事件，並綁定了 $bindingCount 個觸發鍵。';
  }

  @override
  String macroUploadedAssignTrigger(int macroCount, int eventCount) {
    return '已上傳 $macroCount 個巨集，共 $eventCount 個事件。請指定觸發鍵以執行巨集。';
  }

  @override
  String get errorMacroEmpty => '上傳前請至少新增一個包含錄製事件的巨集。';

  @override
  String errorMacroTooManyMacros(int count) {
    return '巨集數量過多（$count）。鍵盤最多支援 100 個。';
  }

  @override
  String errorMacroTooLarge(int macros, int events) {
    return '巨集資料過大（$macros 個巨集，$events 個事件）。請減少巨集或事件數量。';
  }

  @override
  String get errorMacroUnsupportedKey => '該按鍵不支援用於巨集。';

  @override
  String get errorMacroUnsupportedTriggerKey => '該按鍵不能用作巨集觸發鍵。';

  @override
  String get errorMacroTriggerModifierNotAllowed =>
      '修飾鍵不能作為巨集觸發鍵。請選擇一個普通按鍵，例如 F8。';

  @override
  String get errorMacroTriggerSingleKeyOnly => '每個巨集只能有一個觸發鍵。';

  @override
  String get errorMacroTriggerInvalid => '無效的觸發鍵。';

  @override
  String errorMacroDuplicateTrigger(String key) {
    return '多個巨集使用了觸發鍵 $key。每個鍵只能執行一個巨集。';
  }

  @override
  String get lightingModeOff => '關閉';

  @override
  String get lightingModeStatic => '常亮';

  @override
  String get lightingModeSingleOn => '單鍵亮';

  @override
  String get lightingModeSingleOff => '單鍵滅';

  @override
  String get lightingModeGlittering => '閃爍';

  @override
  String get lightingModeFalling => '下落';

  @override
  String get lightingModeColourful => '多彩';

  @override
  String get lightingModeBreath => '呼吸';

  @override
  String get lightingModeSpectrum => '光譜';

  @override
  String get lightingModeOutward => '向外';

  @override
  String get lightingModeScrolling => '捲動';

  @override
  String get lightingModeRolling => '旋轉捲動';

  @override
  String get lightingModeRotating => '旋轉';

  @override
  String get lightingModeExplode => '爆炸';

  @override
  String get lightingModeLaunch => '發射';

  @override
  String get lightingModeRipples => '漣漪';

  @override
  String get lightingModeFlowing => '流動';

  @override
  String get lightingModePulsating => '脈動';

  @override
  String get lightingModeTilt => '傾斜';

  @override
  String get lightingModeShuttle => '穿梭';

  @override
  String get lcdTitle => 'LCD 動畫';

  @override
  String lcdSubtitle(int maxFrames) {
    return '上傳 240×135 GIF（最多 $maxFrames 幀）。在 Dart 中轉換為 RGB565。';
  }

  @override
  String lcdTrimWarning(int maxFrames) {
    return '超過 $maxFrames 幀的 GIF 會自動裁剪為前 $maxFrames 幀。啟用強制上傳可傳送所有幀（可能覆寫 SPI 快閃記憶體中的選單圖形）。';
  }

  @override
  String get forceUploadTitle => '強制上傳（使用所有幀）';

  @override
  String get forceUploadSubtitle => '危險 — 跳過幀裁剪';

  @override
  String get chooseGifOrBin => '選擇 GIF 或 .bin';

  @override
  String get convertToBin => '轉換為 .bin';

  @override
  String get uploadToKeyboard => '上傳到鍵盤';

  @override
  String selectedFile(String name) {
    return '已選擇：$name';
  }

  @override
  String get uploadDialogTitle => '上傳 LCD 動畫？';

  @override
  String uploadDialogBody(int maxFrames) {
    return '如果寫入 SPI 快閃記憶體的幀數過多，上傳圖片可能會永久損壞鍵盤選單圖形，且無法透過恢復原廠設定修復。\n\n除非啟用強制上傳，否則超過 $maxFrames 幀的 GIF 會自動裁剪。';
  }

  @override
  String get cancel => '取消';

  @override
  String get upload => '上傳';

  @override
  String get saveLcdBinary => '儲存 LCD 二進位檔案';

  @override
  String uploadingPercent(String percent) {
    return '上傳中 $percent%';
  }

  @override
  String savedTo(String path) {
    return '已儲存至 $path';
  }

  @override
  String uploadedFrames(int frameCount, int pageCount) {
    return '已上傳 $frameCount 幀（$pageCount 頁）';
  }

  @override
  String inspectFramesExact(
      int frameCount, int width, int height, int pageCount) {
    return '$frameCount 幀 • $width×$height • $pageCount 頁';
  }

  @override
  String inspectFramesTrimmed(int frameCount, int outputFrameCount, int width,
      int height, int pageCount) {
    return '$frameCount 幀 → 使用 $outputFrameCount 幀 • $width×$height • $pageCount 頁';
  }

  @override
  String warningPrefix(String message) {
    return '⚠ $message';
  }

  @override
  String errorFilePicker(String error) {
    return '無法開啟檔案選擇器：$error';
  }

  @override
  String errorDeviceNotFound(String device) {
    return '未找到 $device。請透過 USB-C 連接線連接。';
  }

  @override
  String errorLcdInterfaceNotFound(String device) {
    return '未找到 $device 的 LCD 介面。請透過 USB-C 連接線連接。';
  }

  @override
  String errorFileNotFound(String path) {
    return '檔案未找到：$path';
  }

  @override
  String get errorSupportedFormats => '支援的格式：.gif 或 .bin';

  @override
  String get errorLcdBufferTooSmall => 'LCD 緩衝區太小，無法包含檔案標頭。';

  @override
  String get errorLcdBufferEmpty => 'LCD 緩衝區為空。';

  @override
  String errorLcdBufferSizeMultiple(int size, int pageSize) {
    return 'LCD 緩衝區大小 $size 不是 $pageSize 的倍數。';
  }

  @override
  String get errorLcdBufferZeroFrames => 'LCD 緩衝區檔案標頭報告 0 幀。';

  @override
  String errorLcdBufferTooManyFrames(int frameCount, int maxFrames) {
    return '緩衝區包含 $frameCount 幀，超過安全限制 $maxFrames 幀。啟用強制模式可覆寫（可能損壞鍵盤選單圖形）。';
  }

  @override
  String errorLcdBufferTruncated(int headerFrames, int computedFrames) {
    return '緩衝區被截斷：檔案標頭顯示 $headerFrames 幀，但只能容納 $computedFrames 幀。';
  }

  @override
  String errorLcdBufferTooManyPages(
      int pageCount, int maxPages, int maxFrames) {
    return '緩衝區為 $pageCount 頁，超過安全限制 $maxPages 頁（約 $maxFrames 幀）。啟用強制模式可覆寫。';
  }

  @override
  String get errorGifNoFrames => 'GIF 不包含任何幀。';

  @override
  String errorGifDecodeFrame(int frame) {
    return '無法解碼 GIF 第 $frame 幀。';
  }

  @override
  String warningGifDimensions(
      int width, int height, int expectedWidth, int expectedHeight) {
    return 'GIF 為 ${width}x$height；鍵盤需要 ${expectedWidth}x$expectedHeight。';
  }

  @override
  String warningGifDimensionsCrop(
      int width, int height, int expectedWidth, int expectedHeight) {
    return 'GIF 為 ${width}x$height；鍵盤需要 ${expectedWidth}x$expectedHeight。幀將被裁剪/填充。';
  }

  @override
  String warningGifTooManyFrames(int frameCount, int maxFrames) {
    return 'GIF 有 $frameCount 幀；僅使用前 $maxFrames 幀。';
  }

  @override
  String warningGifCappedAt255(int frameCount) {
    return 'GIF 有 $frameCount 幀；已限制為 255 幀（檔案標頭上限）。';
  }

  @override
  String get remapTitle => '按鍵改鍵';

  @override
  String get remapSubtitle => '將按鍵對應為媒體控制或其他按鍵。透過 USB 上傳，並儲存在本機。';

  @override
  String get remapNormalLayer => '一般層';

  @override
  String get remapFnLayer => 'FN 層';

  @override
  String get remapBindingsTitle => '對應列表';

  @override
  String get remapAddBinding => '新增對應';

  @override
  String get remapEditBinding => '編輯對應';

  @override
  String get remapRemoveBinding => '刪除';

  @override
  String get remapNewBinding => '新對應';

  @override
  String get remapNoBindings => '此層尚無改鍵。';

  @override
  String get remapEditorEmptyTitle => '選擇或新增對應';

  @override
  String get remapEditorEmptyBody => '從列表選擇或新增對應，然後選擇媒體控制或目標按鍵。';

  @override
  String get remapSourceKey => '來源按鍵';

  @override
  String get remapChooseSourceKey => '選擇來源按鍵';

  @override
  String get remapChooseSourceKeyHint => 'F1–F12、字母鍵等';

  @override
  String get remapChooseTargetKey => '選擇目標按鍵';

  @override
  String get remapChooseTargetKeyHint => '按下來源鍵時送出的按鍵';

  @override
  String get remapFunctionKeyHint => 'F1–F12 改鍵請使用一般層。僅在需要按住 Fn 時才使用 FN 層。';

  @override
  String get remapPressSourceKey => '或按下按鍵…';

  @override
  String get remapCapturingSourceHint => '在鍵盤上按下要改鍵的按鍵。按 Esc 取消。';

  @override
  String get remapTargetType => '對應為';

  @override
  String get remapTargetMedia => '媒體';

  @override
  String get remapTargetKey => '其他按鍵';

  @override
  String get remapMediaControls => '媒體控制';

  @override
  String get remapPressTargetKey => '按下目標按鍵…';

  @override
  String get remapCapturingTargetHint => '按下此來源鍵應觸發的目標按鍵。按 Esc 取消。';

  @override
  String remapPreview(String source, String target) {
    return '$source → $target';
  }

  @override
  String get remapApply => '上傳到鍵盤';

  @override
  String get remapChangesApplied => '改鍵變更已上傳到鍵盤。';

  @override
  String get remapNoChangesToApply => '沒有可上傳的改鍵變更。';

  @override
  String get remapPendingDelete => '待刪除 — 上傳後從鍵盤移除';

  @override
  String get remapUndoDelete => '復原刪除';

  @override
  String remapApplied(int count) {
    return '已向鍵盤套用 $count 個改鍵。';
  }

  @override
  String get remapClearLayer => '清空此層';

  @override
  String get remapClearLayerTitle => '清空此層的改鍵？';

  @override
  String get remapClearNormalLayerBody => '將標記一般層上的所有改鍵為待刪除。點擊「上傳到鍵盤」以同步到鍵盤。';

  @override
  String get remapClearFnLayerBody => '將標記 FN 層上的所有改鍵為待刪除。點擊「上傳到鍵盤」以從鍵盤清除。';

  @override
  String get remapClearLayerConfirm => '清空';

  @override
  String get remapLayerCleared => '已清空鍵盤上的 FN 層改鍵。';

  @override
  String get remapMediaPlayPause => '播放 / 暫停';

  @override
  String get remapMediaStop => '停止';

  @override
  String get remapMediaPrevious => '上一曲';

  @override
  String get remapMediaNext => '下一曲';

  @override
  String get remapMediaVolumeUp => '音量加';

  @override
  String get remapMediaVolumeDown => '音量減';

  @override
  String get remapMediaMute => '靜音';

  @override
  String get errorRemapUnsupportedKey => '該按鍵不支援改鍵。';

  @override
  String get errorRemapNoBindings => '請先新增至少一個改鍵再上傳。';

  @override
  String errorRemapConflictMacro(String key) {
    return '按鍵 $key 已用作巨集觸發鍵。請清除巨集觸發鍵或選擇其他來源按鍵。';
  }

  @override
  String errorRemapDuplicateSource(String key) {
    return '多個改鍵使用了來源按鍵 $key。';
  }
}
