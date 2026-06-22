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
}
