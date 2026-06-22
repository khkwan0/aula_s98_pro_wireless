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

  /// No description provided for @navRemap.
  ///
  /// In en, this message translates to:
  /// **'Remap'**
  String get navRemap;

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

  /// No description provided for @aboutTooltip.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTooltip;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// No description provided for @aboutVersionValue.
  ///
  /// In en, this message translates to:
  /// **'{version} ({build})'**
  String aboutVersionValue(String version, String build);

  /// No description provided for @aboutAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get aboutAuthor;

  /// No description provided for @aboutIssues.
  ///
  /// In en, this message translates to:
  /// **'Report issues'**
  String get aboutIssues;

  /// No description provided for @aboutOpenIssues.
  ///
  /// In en, this message translates to:
  /// **'Open issues'**
  String get aboutOpenIssues;

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

  /// No description provided for @factoryResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Factory reset'**
  String get factoryResetTitle;

  /// No description provided for @factoryResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore lighting, key remaps, and macros to defaults.'**
  String get factoryResetSubtitle;

  /// No description provided for @factoryResetButton.
  ///
  /// In en, this message translates to:
  /// **'Factory reset'**
  String get factoryResetButton;

  /// No description provided for @factoryResetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Factory reset keyboard?'**
  String get factoryResetDialogTitle;

  /// No description provided for @factoryResetDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This will clear all custom key remaps, macro bindings, and recorded macros, then restore the default lighting profile.\n\nLCD animations and on-screen menu graphics are not affected. To reset those, re-upload the original GIF or hold Fn + Esc for 5 seconds on the keyboard.'**
  String get factoryResetDialogBody;

  /// No description provided for @factoryResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Factory reset complete. Key remaps and macros cleared. Lighting restored to {mode}.'**
  String factoryResetSuccess(String mode);

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
  /// **'Record keyboard sequences, assign one trigger key per macro, and upload over USB. Like the official AULA software, each macro is triggered by a single key.'**
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

  /// No description provided for @macroPlaybackMode.
  ///
  /// In en, this message translates to:
  /// **'Playback mode'**
  String get macroPlaybackMode;

  /// No description provided for @macroPlaybackModeHint.
  ///
  /// In en, this message translates to:
  /// **'How the macro runs when you press its trigger key.'**
  String get macroPlaybackModeHint;

  /// No description provided for @macroPlaybackOnce.
  ///
  /// In en, this message translates to:
  /// **'Play once or repeat N times'**
  String get macroPlaybackOnce;

  /// No description provided for @macroPlaybackToggle.
  ///
  /// In en, this message translates to:
  /// **'Toggle on/off'**
  String get macroPlaybackToggle;

  /// No description provided for @macroMaxRepeats.
  ///
  /// In en, this message translates to:
  /// **'Maximum repeats'**
  String get macroMaxRepeats;

  /// No description provided for @macroMaxRepeatsHint.
  ///
  /// In en, this message translates to:
  /// **'How many times the macro runs each time you press its trigger key (1–99). Only used in play-once mode.'**
  String get macroMaxRepeatsHint;

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

  /// No description provided for @macroListEntryWithTrigger.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No events} =1{1 event} other{{count} events}} • Trigger: {key}'**
  String macroListEntryWithTrigger(int count, String key);

  /// No description provided for @macroTriggerTitle.
  ///
  /// In en, this message translates to:
  /// **'Trigger key'**
  String get macroTriggerTitle;

  /// No description provided for @macroTriggerNone.
  ///
  /// In en, this message translates to:
  /// **'No trigger key assigned.'**
  String get macroTriggerNone;

  /// No description provided for @macroTriggerAssigned.
  ///
  /// In en, this message translates to:
  /// **'Press {key} on the keyboard to run this macro.'**
  String macroTriggerAssigned(String key);

  /// No description provided for @macroTriggerSingleKeyNote.
  ///
  /// In en, this message translates to:
  /// **'Each macro can use one trigger key only. Modifier shortcuts (e.g. Ctrl+C) belong inside the recorded sequence, not in the trigger.'**
  String get macroTriggerSingleKeyNote;

  /// No description provided for @warningMacroTriggerOverlap.
  ///
  /// In en, this message translates to:
  /// **'Warning: {keys} is also typed by this macro. Use a trigger key that is not part of the sequence (e.g. a function key).'**
  String warningMacroTriggerOverlap(String keys);

  /// No description provided for @macroTriggerPending.
  ///
  /// In en, this message translates to:
  /// **'Selected: {keys} ({count}/3). Press Enter or Confirm.'**
  String macroTriggerPending(String keys, int count);

  /// No description provided for @macroConfirmTrigger.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get macroConfirmTrigger;

  /// No description provided for @macroAssignTrigger.
  ///
  /// In en, this message translates to:
  /// **'Assign trigger key'**
  String get macroAssignTrigger;

  /// No description provided for @macroClearTrigger.
  ///
  /// In en, this message translates to:
  /// **'Clear trigger'**
  String get macroClearTrigger;

  /// No description provided for @macroAssigningTriggerHint.
  ///
  /// In en, this message translates to:
  /// **'Press one key to assign as the macro trigger. Esc to cancel.'**
  String get macroAssigningTriggerHint;

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

  /// No description provided for @macroClearHint.
  ///
  /// In en, this message translates to:
  /// **'Clears recorded events in the app and on the keyboard.'**
  String get macroClearHint;

  /// No description provided for @macroEventsCleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared macro events on the keyboard.'**
  String get macroEventsCleared;

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

  /// No description provided for @macroUploadPending.
  ///
  /// In en, this message translates to:
  /// **'Upload pending changes to the keyboard'**
  String get macroUploadPending;

  /// No description provided for @macroUploadPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard not updated yet'**
  String get macroUploadPendingTitle;

  /// No description provided for @macroUploadPendingBody.
  ///
  /// In en, this message translates to:
  /// **'Your macro changes are saved in this app but have not been sent to the keyboard. Upload now to make them work.'**
  String get macroUploadPendingBody;

  /// No description provided for @macroNoChangesToUpload.
  ///
  /// In en, this message translates to:
  /// **'No macro changes to upload.'**
  String get macroNoChangesToUpload;

  /// No description provided for @macroUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {macroCount, plural, =1{1 macro} other{{macroCount} macros}} with {eventCount, plural, =1{1 event} other{{eventCount} events}}'**
  String macroUploaded(int macroCount, int eventCount);

  /// No description provided for @macroUploadedWithBinding.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {macroCount, plural, =1{1 macro} other{{macroCount} macros}} with {eventCount, plural, =1{1 event} other{{eventCount} events}} and bound {bindingCount, plural, =1{1 trigger key} other{{bindingCount} trigger keys}}.'**
  String macroUploadedWithBinding(
      int macroCount, int eventCount, int bindingCount);

  /// No description provided for @macroUploadedAssignTrigger.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {macroCount, plural, =1{1 macro} other{{macroCount} macros}} with {eventCount, plural, =1{1 event} other{{eventCount} events}}. Assign a trigger key to run it.'**
  String macroUploadedAssignTrigger(int macroCount, int eventCount);

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

  /// No description provided for @errorMacroUnsupportedTriggerKey.
  ///
  /// In en, this message translates to:
  /// **'That key cannot be used as a macro trigger.'**
  String get errorMacroUnsupportedTriggerKey;

  /// No description provided for @errorMacroTriggerModifierNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Modifier keys cannot be macro triggers. Pick a regular key such as F8.'**
  String get errorMacroTriggerModifierNotAllowed;

  /// No description provided for @errorMacroTriggerSingleKeyOnly.
  ///
  /// In en, this message translates to:
  /// **'Each macro can only have one trigger key.'**
  String get errorMacroTriggerSingleKeyOnly;

  /// No description provided for @errorMacroTriggerInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid trigger key.'**
  String get errorMacroTriggerInvalid;

  /// No description provided for @errorMacroDuplicateTrigger.
  ///
  /// In en, this message translates to:
  /// **'Multiple macros use the trigger {key}. Each key can only run one macro.'**
  String errorMacroDuplicateTrigger(String key);

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

  /// No description provided for @pendingUploadCancelled.
  ///
  /// In en, this message translates to:
  /// **'Changes discarded. The keyboard was not updated.'**
  String get pendingUploadCancelled;

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

  /// No description provided for @remapTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Remap'**
  String get remapTitle;

  /// No description provided for @remapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remap keys to media controls or other keys. Changes upload over USB and are saved on this computer.'**
  String get remapSubtitle;

  /// No description provided for @remapNormalLayer.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get remapNormalLayer;

  /// No description provided for @remapFnLayer.
  ///
  /// In en, this message translates to:
  /// **'FN layer'**
  String get remapFnLayer;

  /// No description provided for @remapBindingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bindings'**
  String get remapBindingsTitle;

  /// No description provided for @remapAddBinding.
  ///
  /// In en, this message translates to:
  /// **'Add binding'**
  String get remapAddBinding;

  /// No description provided for @remapEditBinding.
  ///
  /// In en, this message translates to:
  /// **'Edit binding'**
  String get remapEditBinding;

  /// No description provided for @remapRemoveBinding.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remapRemoveBinding;

  /// No description provided for @remapNewBinding.
  ///
  /// In en, this message translates to:
  /// **'New binding'**
  String get remapNewBinding;

  /// No description provided for @remapNoBindings.
  ///
  /// In en, this message translates to:
  /// **'No remaps on this layer yet.'**
  String get remapNoBindings;

  /// No description provided for @remapEditorEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Select or add a binding'**
  String get remapEditorEmptyTitle;

  /// No description provided for @remapEditorEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a binding from the list or add one, then pick a media control or target key.'**
  String get remapEditorEmptyBody;

  /// No description provided for @remapSourceKey.
  ///
  /// In en, this message translates to:
  /// **'Source key'**
  String get remapSourceKey;

  /// No description provided for @remapChooseSourceKey.
  ///
  /// In en, this message translates to:
  /// **'Choose source key'**
  String get remapChooseSourceKey;

  /// No description provided for @remapChooseSourceKeyHint.
  ///
  /// In en, this message translates to:
  /// **'F1–F12, letters, etc.'**
  String get remapChooseSourceKeyHint;

  /// No description provided for @remapChooseTargetKey.
  ///
  /// In en, this message translates to:
  /// **'Choose target key'**
  String get remapChooseTargetKey;

  /// No description provided for @remapChooseTargetKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Key to send when pressed'**
  String get remapChooseTargetKeyHint;

  /// No description provided for @remapFunctionKeyHint.
  ///
  /// In en, this message translates to:
  /// **'F1–F12 remaps use the Normal layer. Use FN layer only when the key must be held with Fn.'**
  String get remapFunctionKeyHint;

  /// No description provided for @remapPressSourceKey.
  ///
  /// In en, this message translates to:
  /// **'Or press a key…'**
  String get remapPressSourceKey;

  /// No description provided for @remapCapturingSourceHint.
  ///
  /// In en, this message translates to:
  /// **'Press a key on the keyboard to use as the source. Esc to cancel.'**
  String get remapCapturingSourceHint;

  /// No description provided for @remapTargetType.
  ///
  /// In en, this message translates to:
  /// **'Remap to'**
  String get remapTargetType;

  /// No description provided for @remapTargetMedia.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get remapTargetMedia;

  /// No description provided for @remapTargetKey.
  ///
  /// In en, this message translates to:
  /// **'Another key'**
  String get remapTargetKey;

  /// No description provided for @remapMediaControls.
  ///
  /// In en, this message translates to:
  /// **'Media controls'**
  String get remapMediaControls;

  /// No description provided for @remapPressTargetKey.
  ///
  /// In en, this message translates to:
  /// **'Press target key…'**
  String get remapPressTargetKey;

  /// No description provided for @remapCapturingTargetHint.
  ///
  /// In en, this message translates to:
  /// **'Press the key this source should act as. Esc to cancel.'**
  String get remapCapturingTargetHint;

  /// No description provided for @remapPreview.
  ///
  /// In en, this message translates to:
  /// **'{source} → {target}'**
  String remapPreview(String source, String target);

  /// No description provided for @remapApply.
  ///
  /// In en, this message translates to:
  /// **'Apply to keyboard'**
  String get remapApply;

  /// No description provided for @remapUploadPending.
  ///
  /// In en, this message translates to:
  /// **'Upload pending changes to the keyboard'**
  String get remapUploadPending;

  /// No description provided for @remapUploadPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard not updated yet'**
  String get remapUploadPendingTitle;

  /// No description provided for @remapUploadPendingBody.
  ///
  /// In en, this message translates to:
  /// **'Your remap changes are saved in this app but have not been sent to the keyboard. Apply now to make them work.'**
  String get remapUploadPendingBody;

  /// No description provided for @remapChangesApplied.
  ///
  /// In en, this message translates to:
  /// **'Remap changes applied to the keyboard.'**
  String get remapChangesApplied;

  /// No description provided for @remapNoChangesToApply.
  ///
  /// In en, this message translates to:
  /// **'No remap changes to apply.'**
  String get remapNoChangesToApply;

  /// No description provided for @remapPendingDelete.
  ///
  /// In en, this message translates to:
  /// **'Pending delete — apply to remove from keyboard'**
  String get remapPendingDelete;

  /// No description provided for @remapUndoDelete.
  ///
  /// In en, this message translates to:
  /// **'Undo delete'**
  String get remapUndoDelete;

  /// No description provided for @remapApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied {count, plural, =1{1 key remap} other{{count} key remaps}} to the keyboard.'**
  String remapApplied(int count);

  /// No description provided for @remapClearLayer.
  ///
  /// In en, this message translates to:
  /// **'Clear layer'**
  String get remapClearLayer;

  /// No description provided for @remapClearLayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear remaps on this layer?'**
  String get remapClearLayerTitle;

  /// No description provided for @remapClearNormalLayerBody.
  ///
  /// In en, this message translates to:
  /// **'Marks all normal-layer remaps for deletion. Click Apply to upload the change to the keyboard.'**
  String get remapClearNormalLayerBody;

  /// No description provided for @remapClearFnLayerBody.
  ///
  /// In en, this message translates to:
  /// **'Marks all FN-layer remaps for deletion. Click Apply to clear them on the keyboard.'**
  String get remapClearFnLayerBody;

  /// No description provided for @remapClearLayerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get remapClearLayerConfirm;

  /// No description provided for @remapLayerCleared.
  ///
  /// In en, this message translates to:
  /// **'FN-layer remaps cleared on the keyboard.'**
  String get remapLayerCleared;

  /// No description provided for @remapMediaPlayPause.
  ///
  /// In en, this message translates to:
  /// **'Play / Pause'**
  String get remapMediaPlayPause;

  /// No description provided for @remapMediaStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get remapMediaStop;

  /// No description provided for @remapMediaPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous track'**
  String get remapMediaPrevious;

  /// No description provided for @remapMediaNext.
  ///
  /// In en, this message translates to:
  /// **'Next track'**
  String get remapMediaNext;

  /// No description provided for @remapMediaVolumeUp.
  ///
  /// In en, this message translates to:
  /// **'Volume up'**
  String get remapMediaVolumeUp;

  /// No description provided for @remapMediaVolumeDown.
  ///
  /// In en, this message translates to:
  /// **'Volume down'**
  String get remapMediaVolumeDown;

  /// No description provided for @remapMediaMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get remapMediaMute;

  /// No description provided for @errorRemapUnsupportedKey.
  ///
  /// In en, this message translates to:
  /// **'That key is not supported for remapping.'**
  String get errorRemapUnsupportedKey;

  /// No description provided for @errorRemapNoBindings.
  ///
  /// In en, this message translates to:
  /// **'Add at least one remap before applying.'**
  String get errorRemapNoBindings;

  /// No description provided for @errorRemapConflictMacro.
  ///
  /// In en, this message translates to:
  /// **'Key {key} is already used as a macro trigger. Clear the macro trigger or pick a different source key.'**
  String errorRemapConflictMacro(String key);

  /// No description provided for @errorRemapDuplicateSource.
  ///
  /// In en, this message translates to:
  /// **'Multiple remaps use source key {key}.'**
  String errorRemapDuplicateSource(String key);
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
