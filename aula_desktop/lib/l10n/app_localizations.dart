import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChineseSimplified.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get languageChineseSimplified;

  /// No description provided for @languageChineseTraditional.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get languageChineseTraditional;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navClock.
  ///
  /// In en, this message translates to:
  /// **'Clock'**
  String get navClock;

  /// No description provided for @navRgb.
  ///
  /// In en, this message translates to:
  /// **'RGB'**
  String get navRgb;

  /// No description provided for @navMacro.
  ///
  /// In en, this message translates to:
  /// **'Macros'**
  String get navMacro;

  /// No description provided for @navLcd.
  ///
  /// In en, this message translates to:
  /// **'LCD'**
  String get navLcd;

  /// No description provided for @deviceInfoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Device info'**
  String get deviceInfoTooltip;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @missing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get missing;

  /// No description provided for @usbIdentification.
  ///
  /// In en, this message translates to:
  /// **'USB identification'**
  String get usbIdentification;

  /// No description provided for @controlHidInterface.
  ///
  /// In en, this message translates to:
  /// **'Control HID interface'**
  String get controlHidInterface;

  /// No description provided for @lcdHidInterface.
  ///
  /// In en, this message translates to:
  /// **'LCD HID interface'**
  String get lcdHidInterface;

  /// No description provided for @protocol.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get protocol;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @vendorId.
  ///
  /// In en, this message translates to:
  /// **'Vendor ID'**
  String get vendorId;

  /// No description provided for @productId.
  ///
  /// In en, this message translates to:
  /// **'Product ID'**
  String get productId;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @path.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get path;

  /// No description provided for @usagePage.
  ///
  /// In en, this message translates to:
  /// **'Usage page'**
  String get usagePage;

  /// No description provided for @usage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get usage;

  /// No description provided for @interface.
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get interface;

  /// No description provided for @hidReportSize.
  ///
  /// In en, this message translates to:
  /// **'HID report size'**
  String get hidReportSize;

  /// No description provided for @commandDelay.
  ///
  /// In en, this message translates to:
  /// **'Command delay'**
  String get commandDelay;

  /// No description provided for @lcdResolution.
  ///
  /// In en, this message translates to:
  /// **'LCD resolution'**
  String get lcdResolution;

  /// No description provided for @pixelFormat.
  ///
  /// In en, this message translates to:
  /// **'Pixel format'**
  String get pixelFormat;

  /// No description provided for @frameSize.
  ///
  /// In en, this message translates to:
  /// **'Frame size'**
  String get frameSize;

  /// No description provided for @maxFramesLabel.
  ///
  /// In en, this message translates to:
  /// **'Max frames'**
  String get maxFramesLabel;

  /// No description provided for @flashPageSize.
  ///
  /// In en, this message translates to:
  /// **'Flash page size'**
  String get flashPageSize;

  /// No description provided for @lcdAckTimeout.
  ///
  /// In en, this message translates to:
  /// **'LCD ACK timeout'**
  String get lcdAckTimeout;

  /// No description provided for @allHidInterfaces.
  ///
  /// In en, this message translates to:
  /// **'All HID interfaces ({count})'**
  String allHidInterfaces(int count);

  /// No description provided for @interfaceSummary.
  ///
  /// In en, this message translates to:
  /// **'IF{number}: {usagePage} usage {usage}'**
  String interfaceSummary(int number, String usagePage, int usage);

  /// No description provided for @bytesUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} bytes'**
  String bytesUnit(int count);

  /// No description provided for @millisecondsUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} ms'**
  String millisecondsUnit(int count);

  /// No description provided for @pixelFormatValue.
  ///
  /// In en, this message translates to:
  /// **'RGB565 ({bytesPerPixel} bytes/pixel)'**
  String pixelFormatValue(int bytesPerPixel);

  /// No description provided for @resolutionValue.
  ///
  /// In en, this message translates to:
  /// **'{width}×{height}'**
  String resolutionValue(int width, int height);

  /// No description provided for @keyboardCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard'**
  String get keyboardCardTitle;

  /// No description provided for @usbWiredRequired.
  ///
  /// In en, this message translates to:
  /// **'USB wired required'**
  String get usbWiredRequired;

  /// No description provided for @lcdInterfaceCardTitle.
  ///
  /// In en, this message translates to:
  /// **'LCD interface'**
  String get lcdInterfaceCardTitle;

  /// No description provided for @lcdInterfaceCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Required for GIF upload'**
  String get lcdInterfaceCardSubtitle;

  /// No description provided for @frameLimitCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Frame limit'**
  String get frameLimitCardTitle;

  /// No description provided for @frameLimitValue.
  ///
  /// In en, this message translates to:
  /// **'{count} frames'**
  String frameLimitValue(int count);

  /// No description provided for @frameLimitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'240×135 RGB565'**
  String get frameLimitSubtitle;

  /// No description provided for @requirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirementsTitle;

  /// No description provided for @requirementUsb.
  ///
  /// In en, this message translates to:
  /// **'• Connect the keyboard over USB (not Bluetooth only).'**
  String get requirementUsb;

  /// No description provided for @requirementCloseUtility.
  ///
  /// In en, this message translates to:
  /// **'• Close AULA utility software before using this app.'**
  String get requirementCloseUtility;

  /// No description provided for @requirementGifTrim.
  ///
  /// In en, this message translates to:
  /// **'• GIFs over {maxFrames} frames are trimmed automatically.'**
  String requirementGifTrim(int maxFrames);

  /// No description provided for @clockTitle.
  ///
  /// In en, this message translates to:
  /// **'LCD Clock'**
  String get clockTitle;

  /// No description provided for @clockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync the keyboard screen clock over USB.'**
  String get clockSubtitle;

  /// No description provided for @useCustomDateTime.
  ///
  /// In en, this message translates to:
  /// **'Use custom date/time'**
  String get useCustomDateTime;

  /// No description provided for @useCustomDateTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Off = sync to system time now'**
  String get useCustomDateTimeSubtitle;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @syncCustomTime.
  ///
  /// In en, this message translates to:
  /// **'Sync custom time'**
  String get syncCustomTime;

  /// No description provided for @syncSystemTime.
  ///
  /// In en, this message translates to:
  /// **'Sync system time'**
  String get syncSystemTime;

  /// No description provided for @syncedTo.
  ///
  /// In en, this message translates to:
  /// **'Synced to {datetime}'**
  String syncedTo(String datetime);

  /// No description provided for @rgbTitle.
  ///
  /// In en, this message translates to:
  /// **'RGB Lighting'**
  String get rgbTitle;

  /// No description provided for @rgbSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set backlight mode, color, brightness, and speed.'**
  String get rgbSubtitle;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @lightingModeEntry.
  ///
  /// In en, this message translates to:
  /// **'{index} — {name}'**
  String lightingModeEntry(String index, String name);

  /// No description provided for @rainbowColorful.
  ///
  /// In en, this message translates to:
  /// **'Rainbow / colorful'**
  String get rainbowColorful;

  /// No description provided for @colorRgbValue.
  ///
  /// In en, this message translates to:
  /// **'RGB ({r}, {g}, {b})'**
  String colorRgbValue(int r, int g, int b);

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorHsvValue.
  ///
  /// In en, this message translates to:
  /// **'HSV ({h}, {s}, {v})'**
  String colorHsvValue(int h, int s, int v);

  /// No description provided for @brightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness: {value}'**
  String brightness(int value);

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed: {value}'**
  String speed(int value);

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction: {value}'**
  String direction(int value);

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @turnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get turnOff;

  /// No description provided for @appliedMode.
  ///
  /// In en, this message translates to:
  /// **'Applied {mode}'**
  String appliedMode(String mode);

  /// No description provided for @backlightTurnedOff.
  ///
  /// In en, this message translates to:
  /// **'Backlight turned off'**
  String get backlightTurnedOff;

  /// No description provided for @macroTitle.
  ///
  /// In en, this message translates to:
  /// **'Macros'**
  String get macroTitle;

  /// No description provided for @macroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record keyboard sequences and upload them to the keyboard over USB. Assign a key to a macro using the official AULA utility or a future key-remap feature.'**
  String get macroSubtitle;

  /// No description provided for @macroListTitle.
  ///
  /// In en, this message translates to:
  /// **'Macro slots'**
  String get macroListTitle;

  /// No description provided for @macroAdd.
  ///
  /// In en, this message translates to:
  /// **'Add macro'**
  String get macroAdd;

  /// No description provided for @macroName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get macroName;

  /// No description provided for @macroDelayMode.
  ///
  /// In en, this message translates to:
  /// **'Delay between events'**
  String get macroDelayMode;

  /// No description provided for @macroDelayRecorded.
  ///
  /// In en, this message translates to:
  /// **'Use recorded delays'**
  String get macroDelayRecorded;

  /// No description provided for @macroDelayNone.
  ///
  /// In en, this message translates to:
  /// **'No delay'**
  String get macroDelayNone;

  /// No description provided for @macroDelayCustom.
  ///
  /// In en, this message translates to:
  /// **'Fixed delay'**
  String get macroDelayCustom;

  /// No description provided for @macroDelayMs.
  ///
  /// In en, this message translates to:
  /// **'Delay (ms)'**
  String get macroDelayMs;

  /// No description provided for @macroRecordingHint.
  ///
  /// In en, this message translates to:
  /// **'Recording… press keys on your keyboard. Press Esc to stop.'**
  String get macroRecordingHint;

  /// No description provided for @macroNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events yet. Click Record and press keys.'**
  String get macroNoEvents;

  /// No description provided for @macroEventCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No events} =1{1 event} other{{count} events}}'**
  String macroEventCount(int count);

  /// No description provided for @macroActionDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get macroActionDown;

  /// No description provided for @macroActionUp.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get macroActionUp;

  /// No description provided for @macroActionDelay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get macroActionDelay;

  /// No description provided for @macroGapDelay.
  ///
  /// In en, this message translates to:
  /// **'Gap before: {ms} ms'**
  String macroGapDelay(int ms);

  /// No description provided for @macroRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get macroRecord;

  /// No description provided for @macroStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get macroStop;

  /// No description provided for @macroClear.
  ///
  /// In en, this message translates to:
  /// **'Clear events'**
  String get macroClear;

  /// No description provided for @macroDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete macro'**
  String get macroDelete;

  /// No description provided for @macroUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload to keyboard'**
  String get macroUpload;

  /// No description provided for @macroUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {macroCount, plural, =1{1 macro} other{{macroCount} macros}} with {eventCount, plural, =1{1 event} other{{eventCount} events}}'**
  String macroUploaded(int macroCount, int eventCount);

  /// No description provided for @errorMacroEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add at least one macro with recorded events before uploading.'**
  String get errorMacroEmpty;

  /// No description provided for @errorMacroTooManyMacros.
  ///
  /// In en, this message translates to:
  /// **'Too many macros ({count}). The keyboard supports up to 100.'**
  String errorMacroTooManyMacros(int count);

  /// No description provided for @errorMacroTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Macro data is too large ({macros} macros, {events} events). Reduce the number of macros or events.'**
  String errorMacroTooLarge(int macros, int events);

  /// No description provided for @errorMacroUnsupportedKey.
  ///
  /// In en, this message translates to:
  /// **'That key is not supported for macros.'**
  String get errorMacroUnsupportedKey;

  /// No description provided for @lightingModeOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get lightingModeOff;

  /// No description provided for @lightingModeStatic.
  ///
  /// In en, this message translates to:
  /// **'Static'**
  String get lightingModeStatic;

  /// No description provided for @lightingModeSingleOn.
  ///
  /// In en, this message translates to:
  /// **'SingleOn'**
  String get lightingModeSingleOn;

  /// No description provided for @lightingModeSingleOff.
  ///
  /// In en, this message translates to:
  /// **'SingleOff'**
  String get lightingModeSingleOff;

  /// No description provided for @lightingModeGlittering.
  ///
  /// In en, this message translates to:
  /// **'Glittering'**
  String get lightingModeGlittering;

  /// No description provided for @lightingModeFalling.
  ///
  /// In en, this message translates to:
  /// **'Falling'**
  String get lightingModeFalling;

  /// No description provided for @lightingModeColourful.
  ///
  /// In en, this message translates to:
  /// **'Colourful'**
  String get lightingModeColourful;

  /// No description provided for @lightingModeBreath.
  ///
  /// In en, this message translates to:
  /// **'Breath'**
  String get lightingModeBreath;

  /// No description provided for @lightingModeSpectrum.
  ///
  /// In en, this message translates to:
  /// **'Spectrum'**
  String get lightingModeSpectrum;

  /// No description provided for @lightingModeOutward.
  ///
  /// In en, this message translates to:
  /// **'Outward'**
  String get lightingModeOutward;

  /// No description provided for @lightingModeScrolling.
  ///
  /// In en, this message translates to:
  /// **'Scrolling'**
  String get lightingModeScrolling;

  /// No description provided for @lightingModeRolling.
  ///
  /// In en, this message translates to:
  /// **'Rolling'**
  String get lightingModeRolling;

  /// No description provided for @lightingModeRotating.
  ///
  /// In en, this message translates to:
  /// **'Rotating'**
  String get lightingModeRotating;

  /// No description provided for @lightingModeExplode.
  ///
  /// In en, this message translates to:
  /// **'Explode'**
  String get lightingModeExplode;

  /// No description provided for @lightingModeLaunch.
  ///
  /// In en, this message translates to:
  /// **'Launch'**
  String get lightingModeLaunch;

  /// No description provided for @lightingModeRipples.
  ///
  /// In en, this message translates to:
  /// **'Ripples'**
  String get lightingModeRipples;

  /// No description provided for @lightingModeFlowing.
  ///
  /// In en, this message translates to:
  /// **'Flowing'**
  String get lightingModeFlowing;

  /// No description provided for @lightingModePulsating.
  ///
  /// In en, this message translates to:
  /// **'Pulsating'**
  String get lightingModePulsating;

  /// No description provided for @lightingModeTilt.
  ///
  /// In en, this message translates to:
  /// **'Tilt'**
  String get lightingModeTilt;

  /// No description provided for @lightingModeShuttle.
  ///
  /// In en, this message translates to:
  /// **'Shuttle'**
  String get lightingModeShuttle;

  /// No description provided for @lcdTitle.
  ///
  /// In en, this message translates to:
  /// **'LCD Animation'**
  String get lcdTitle;

  /// No description provided for @lcdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a 240×135 GIF (up to {maxFrames} frames). Converts to RGB565 in Dart.'**
  String lcdSubtitle(int maxFrames);

  /// No description provided for @lcdTrimWarning.
  ///
  /// In en, this message translates to:
  /// **'GIFs with more than {maxFrames} frames are trimmed to the first {maxFrames} automatically. Enable force upload to send every frame (may overwrite menu graphics in SPI flash).'**
  String lcdTrimWarning(int maxFrames);

  /// No description provided for @forceUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Force upload (use all frames)'**
  String get forceUploadTitle;

  /// No description provided for @forceUploadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dangerous — skips frame trimming'**
  String get forceUploadSubtitle;

  /// No description provided for @chooseGifOrBin.
  ///
  /// In en, this message translates to:
  /// **'Choose GIF or .bin'**
  String get chooseGifOrBin;

  /// No description provided for @convertToBin.
  ///
  /// In en, this message translates to:
  /// **'Convert to .bin'**
  String get convertToBin;

  /// No description provided for @uploadToKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Upload to keyboard'**
  String get uploadToKeyboard;

  /// No description provided for @selectedFile.
  ///
  /// In en, this message translates to:
  /// **'Selected: {name}'**
  String selectedFile(String name);

  /// No description provided for @uploadDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload LCD animation?'**
  String get uploadDialogTitle;

  /// No description provided for @uploadDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Uploading images can permanently corrupt the keyboard menu graphics if too many frames are written to SPI flash. This is not recoverable by factory reset.\n\nGIFs over {maxFrames} frames are trimmed automatically unless force upload is enabled.'**
  String uploadDialogBody(int maxFrames);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @saveLcdBinary.
  ///
  /// In en, this message translates to:
  /// **'Save LCD binary'**
  String get saveLcdBinary;

  /// No description provided for @uploadingPercent.
  ///
  /// In en, this message translates to:
  /// **'Uploading {percent}%'**
  String uploadingPercent(String percent);

  /// No description provided for @savedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to {path}'**
  String savedTo(String path);

  /// No description provided for @uploadedFrames.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {frameCount} frames ({pageCount} pages)'**
  String uploadedFrames(int frameCount, int pageCount);

  /// No description provided for @inspectFramesExact.
  ///
  /// In en, this message translates to:
  /// **'{frameCount} frames • {width}×{height} • {pageCount} pages'**
  String inspectFramesExact(
      int frameCount, int width, int height, int pageCount);

  /// No description provided for @inspectFramesTrimmed.
  ///
  /// In en, this message translates to:
  /// **'{frameCount} frames → using {outputFrameCount} • {width}×{height} • {pageCount} pages'**
  String inspectFramesTrimmed(int frameCount, int outputFrameCount, int width,
      int height, int pageCount);

  /// No description provided for @warningPrefix.
  ///
  /// In en, this message translates to:
  /// **'⚠ {message}'**
  String warningPrefix(String message);

  /// No description provided for @errorFilePicker.
  ///
  /// In en, this message translates to:
  /// **'Could not open file picker: {error}'**
  String errorFilePicker(String error);

  /// No description provided for @errorDeviceNotFound.
  ///
  /// In en, this message translates to:
  /// **'{device} not found. Connect via USB-C cable.'**
  String errorDeviceNotFound(String device);

  /// No description provided for @errorLcdInterfaceNotFound.
  ///
  /// In en, this message translates to:
  /// **'{device} LCD interface not found. Connect via USB-C cable.'**
  String errorLcdInterfaceNotFound(String device);

  /// No description provided for @errorFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found: {path}'**
  String errorFileNotFound(String path);

  /// No description provided for @errorSupportedFormats.
  ///
  /// In en, this message translates to:
  /// **'Supported formats: .gif or .bin'**
  String get errorSupportedFormats;

  /// No description provided for @errorLcdBufferTooSmall.
  ///
  /// In en, this message translates to:
  /// **'LCD buffer is too small to contain a header.'**
  String get errorLcdBufferTooSmall;

  /// No description provided for @errorLcdBufferEmpty.
  ///
  /// In en, this message translates to:
  /// **'LCD buffer is empty.'**
  String get errorLcdBufferEmpty;

  /// No description provided for @errorLcdBufferSizeMultiple.
  ///
  /// In en, this message translates to:
  /// **'LCD buffer size {size} is not a multiple of {pageSize}.'**
  String errorLcdBufferSizeMultiple(int size, int pageSize);

  /// No description provided for @errorLcdBufferZeroFrames.
  ///
  /// In en, this message translates to:
  /// **'LCD buffer header reports 0 frames.'**
  String get errorLcdBufferZeroFrames;

  /// No description provided for @errorLcdBufferTooManyFrames.
  ///
  /// In en, this message translates to:
  /// **'Buffer contains {frameCount} frames, which exceeds the safe limit of {maxFrames}. Enable force to override (may corrupt keyboard menu graphics).'**
  String errorLcdBufferTooManyFrames(int frameCount, int maxFrames);

  /// No description provided for @errorLcdBufferTruncated.
  ///
  /// In en, this message translates to:
  /// **'Buffer is truncated: header says {headerFrames} frames but only {computedFrames} fit.'**
  String errorLcdBufferTruncated(int headerFrames, int computedFrames);

  /// No description provided for @errorLcdBufferTooManyPages.
  ///
  /// In en, this message translates to:
  /// **'Buffer is {pageCount} pages, exceeding the safe limit of {maxPages} pages (~{maxFrames} frames). Enable force to override.'**
  String errorLcdBufferTooManyPages(int pageCount, int maxPages, int maxFrames);

  /// No description provided for @errorGifNoFrames.
  ///
  /// In en, this message translates to:
  /// **'GIF contains no frames.'**
  String get errorGifNoFrames;

  /// No description provided for @errorGifDecodeFrame.
  ///
  /// In en, this message translates to:
  /// **'Failed to decode GIF frame {frame}.'**
  String errorGifDecodeFrame(int frame);

  /// No description provided for @warningGifDimensions.
  ///
  /// In en, this message translates to:
  /// **'GIF is {width}x{height}; keyboard expects {expectedWidth}x{expectedHeight}.'**
  String warningGifDimensions(
      int width, int height, int expectedWidth, int expectedHeight);

  /// No description provided for @warningGifDimensionsCrop.
  ///
  /// In en, this message translates to:
  /// **'GIF is {width}x{height}; keyboard expects {expectedWidth}x{expectedHeight}. Frames will be cropped/padded.'**
  String warningGifDimensionsCrop(
      int width, int height, int expectedWidth, int expectedHeight);

  /// No description provided for @warningGifTooManyFrames.
  ///
  /// In en, this message translates to:
  /// **'GIF has {frameCount} frames; only the first {maxFrames} will be used.'**
  String warningGifTooManyFrames(int frameCount, int maxFrames);

  /// No description provided for @warningGifCappedAt255.
  ///
  /// In en, this message translates to:
  /// **'GIF has {frameCount} frames; capped at 255 (header limit).'**
  String warningGifCappedAt255(int frameCount);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
