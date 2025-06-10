import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../firebase_options.dart';

class FirebaseEngine {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Initialise Firebase et Firebase Analytics
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Log lorsqu'un utilisateur se connecte
  static Future<void> userLogsIn(String loginMethod) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  /// Log lorsqu'un utilisateur ajoute un item au panier
  static Future<void> addsItemToCart(String itemId, String itemName, double price) async {
    await _analytics.logEvent(
      name: 'add_to_cart',
      parameters: {
        'item_id': itemId,
        'item_name': itemName,
        'price': price,
      },
    );
  }

  static Future<void> pagesTracked(String pageName) async {
    await _analytics.logEvent(
        name: "pages_tracked",
        parameters: {
          "page_name": pageName
        }
    );
  }

  /// Log lorsqu'un utilisateur effectue un achat
  static Future<void> purchase(String transactionId, double amount) async {
    await _analytics.logPurchase(
      transactionId: transactionId,
      value: amount,
      currency: 'USD', // Tu peux changer la devise selon ton besoin
    );
  }

  /// Log un événement personnalisé
  static Future<void> logCustomEvent(String eventName, Map<String, Object> parameters) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  /// #### ONBOARDING'S ANALYTICS :

  /// Track onboarding screen duration :

    static DateTime? _onboardingStartTime;
    // Commence le suivi du temps sur l'onboarding
    static void startOnboardingTracking() {
      _onboardingStartTime = DateTime.now();
    }

  /// Enregistre le temps avant d'appuyer sur "Suivant"
  static Future<void> logOnboardingNextPressed(int stepNumber) async {
    if (_onboardingStartTime != null) {
      final duration = DateTime.now().difference(_onboardingStartTime!).inSeconds;

      await _analytics.logEvent(
        name: "onboarding_next_pressed",
        parameters: {
          "step": stepNumber, // Numéro de l'étape dans l'onboarding
          "duration": duration, // Temps en secondes avant appui sur "Suivant"
        },
      );

      // Réinitialiser le timer pour la prochaine étape
      _onboardingStartTime = DateTime.now();
    }
  }


/// Track yeeguide selection duration :

    /// Yeeguide selected (custom event) :

    /// Unavailable yeeguide selected (custom event)

    /// Yeeguide confirmed (custom event) :
    /// Changed yeeguide (custom event) :
    /// User name entered () :
}
