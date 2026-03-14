import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ky'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Islam Education KG'**
  String get appTitle;

  /// No description provided for @loading.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @errorGeneric.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так. Попробуйте снова.'**
  String get errorGeneric;

  /// No description provided for @welcomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Добро пожаловать'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Простое и структурированное обучение основам ислама.'**
  String get welcomeSubtitle;

  /// No description provided for @selectLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Выберите язык'**
  String get selectLanguage;

  /// No description provided for @languageKyrgyz.
  ///
  /// In ru, this message translates to:
  /// **'Кыргызча'**
  String get languageKyrgyz;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @continueText.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get continueText;

  /// No description provided for @homeTab.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get homeTab;

  /// No description provided for @categoriesTab.
  ///
  /// In ru, this message translates to:
  /// **'Категории'**
  String get categoriesTab;

  /// No description provided for @learningPathTab.
  ///
  /// In ru, this message translates to:
  /// **'Путь'**
  String get learningPathTab;

  /// No description provided for @bookmarksTab.
  ///
  /// In ru, this message translates to:
  /// **'Закладки'**
  String get bookmarksTab;

  /// No description provided for @profileTab.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTab;

  /// No description provided for @homeGreeting.
  ///
  /// In ru, this message translates to:
  /// **'Ассаляму алейкум'**
  String get homeGreeting;

  /// No description provided for @homeGreetingSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Учитесь шаг за шагом в удобном темпе.'**
  String get homeGreetingSubtitle;

  /// No description provided for @continueLearning.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить обучение'**
  String get continueLearning;

  /// No description provided for @featuredLessons.
  ///
  /// In ru, this message translates to:
  /// **'Рекомендуемые уроки'**
  String get featuredLessons;

  /// No description provided for @categoriesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Категории'**
  String get categoriesTitle;

  /// No description provided for @dailyUsefulCardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Полезно сегодня'**
  String get dailyUsefulCardTitle;

  /// No description provided for @dailyUsefulCardBody.
  ///
  /// In ru, this message translates to:
  /// **'Небольшая практика каждый день помогает закрепить знания.'**
  String get dailyUsefulCardBody;

  /// No description provided for @startLearning.
  ///
  /// In ru, this message translates to:
  /// **'Начать обучение'**
  String get startLearning;

  /// No description provided for @searchLessons.
  ///
  /// In ru, this message translates to:
  /// **'Поиск уроков'**
  String get searchLessons;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Введите название или ключевое слово'**
  String get searchHint;

  /// No description provided for @completed.
  ///
  /// In ru, this message translates to:
  /// **'Завершено'**
  String get completed;

  /// No description provided for @beginnerRoadmap.
  ///
  /// In ru, this message translates to:
  /// **'Путь начинающего'**
  String get beginnerRoadmap;

  /// No description provided for @progress.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс'**
  String get progress;

  /// No description provided for @completedLessons.
  ///
  /// In ru, this message translates to:
  /// **'Завершённые уроки'**
  String get completedLessons;

  /// No description provided for @nextLesson.
  ///
  /// In ru, this message translates to:
  /// **'Следующий урок'**
  String get nextLesson;

  /// No description provided for @noNextLesson.
  ///
  /// In ru, this message translates to:
  /// **'Вы завершили все доступные уроки.'**
  String get noNextLesson;

  /// No description provided for @savedLessons.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённые уроки'**
  String get savedLessons;

  /// No description provided for @selectedLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Выбранный язык'**
  String get selectedLanguage;

  /// No description provided for @aboutApp.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get aboutApp;

  /// No description provided for @feedbackSupport.
  ///
  /// In ru, this message translates to:
  /// **'Обратная связь / поддержка'**
  String get feedbackSupport;

  /// No description provided for @changeLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Сменить язык'**
  String get changeLanguage;

  /// No description provided for @aboutDescription.
  ///
  /// In ru, this message translates to:
  /// **'Это образовательное приложение с проверенным и структурированным контентом. Приложение не является платформой для фетв.'**
  String get aboutDescription;

  /// No description provided for @supportPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Раздел поддержки будет добавлен в следующей версии.'**
  String get supportPlaceholder;

  /// No description provided for @markCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Отметить как завершённый'**
  String get markCompleted;

  /// No description provided for @lessonSteps.
  ///
  /// In ru, this message translates to:
  /// **'Пошаговое содержание'**
  String get lessonSteps;

  /// No description provided for @playAudio.
  ///
  /// In ru, this message translates to:
  /// **'Слушать аудио'**
  String get playAudio;

  /// No description provided for @noAudioAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Для этого урока аудио пока не добавлено.'**
  String get noAudioAvailable;

  /// No description provided for @bookmarkAdded.
  ///
  /// In ru, this message translates to:
  /// **'Урок сохранён в закладки.'**
  String get bookmarkAdded;

  /// No description provided for @bookmarkRemoved.
  ///
  /// In ru, this message translates to:
  /// **'Урок удалён из закладок.'**
  String get bookmarkRemoved;

  /// No description provided for @completeSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Урок отмечен как завершённый.'**
  String get completeSuccess;

  /// No description provided for @emptyLessons.
  ///
  /// In ru, this message translates to:
  /// **'Уроков пока нет.'**
  String get emptyLessons;

  /// No description provided for @emptyBookmarks.
  ///
  /// In ru, this message translates to:
  /// **'У вас пока нет закладок.'**
  String get emptyBookmarks;

  /// No description provided for @emptyCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Вы ещё не завершили уроки.'**
  String get emptyCompleted;

  /// No description provided for @profileStats.
  ///
  /// In ru, this message translates to:
  /// **'Статистика'**
  String get profileStats;

  /// No description provided for @lessonNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Урок не найден.'**
  String get lessonNotFound;
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
      <String>['ky', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
