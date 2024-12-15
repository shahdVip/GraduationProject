import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grad_roze/components/bottomNavBar/customer_layout.dart';
import 'package:grad_roze/components/business_components/business_layout.dart';
import 'package:grad_roze/pages/business_pages/inventory/inventory_widget.dart';
import 'package:grad_roze/pages/business_profile/business_profile_model.dart';
import 'package:grad_roze/pages/business_profile/business_profile_widget.dart';
import 'package:grad_roze/pages/cameraPage/camera_page_widget.dart';
import 'package:grad_roze/pages/cart/cart_widget.dart';
import 'package:grad_roze/pages/favorite_list/favorite_list_widget.dart';
import 'package:grad_roze/pages/full_top_picks/full_top_picks_model.dart';
import 'package:grad_roze/pages/full_top_picks/full_top_picks_widget.dart';
import 'package:grad_roze/pages/myprofile_customer/myprofile_customer_widget.dart';
import 'package:grad_roze/pages/navigation_menu/navigation_menu.dart';
import 'package:grad_roze/pages/navigation_menu_users/navigation_menu_users.dart';
import 'package:grad_roze/pages/webview/webview_model.dart';
import 'package:grad_roze/pages/webview/webview_widget.dart';
import 'package:provider/provider.dart';

import '/index.dart';
import '/custom/util.dart';
import '/custom/theme.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => const OnboardingWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => const OnboardingWidget(),
        ),
        FFRoute(
          name: 'onboarding',
          path: '/onboarding',
          builder: (context, params) => const OnboardingWidget(),
        ),
        FFRoute(
          name: 'SignInUp',
          path: '/signInUp',
          builder: (context, params) => const SignInUpWidget(),
        ),
        FFRoute(
          name: 'OTP',
          path: '/otp',
          builder: (context, params) => OtpWidget(
            email: params.getParam(
              'email',
              ParamType.String,
            ),
            role: params.getParam(
              'role',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'ForgotPassword',
          path: '/forgotPassword',
          builder: (context, params) => ForgotPasswordWidget(),
        ),
        FFRoute(
          name: 'AdminDashboard',
          path: '/adminDashboard',
          builder: (context, params) => const AdminDashboardWidget(),
        ),
        FFRoute(
          name: 'AdminUsersSection',
          path: '/adminUsersSection',
          builder: (context, params) => const AdminUsersSectionWidget(),
        ),
        FFRoute(
          name: 'AdminUsersSectionWithNav',
          path: '/AdminUsersSectionWithNav',
          builder: (context, params) => const NavigationMenuUsersWidget(),
        ),
        FFRoute(
          name: 'Adminprofile',
          path: '/adminprofile',
          builder: (context, params) => const AdminprofileWidget(),
        ),
        FFRoute(
          name: 'orderSection',
          path: '/orderSection',
          builder: (context, params) => const OrderSectionWidget(),
        ),
        FFRoute(
          name: 'orderDetails',
          path: '/orderDetails',
          builder: (context, params) => const OrderDetailsWidget(),
        ),
        FFRoute(
          name: 'businessProfile',
          path: '/businessProfile',
          builder: (context, params) {
            return BusinessProfileWidget(
              username: params.getParam(
                'username',
                ParamType.String,
              ),
            );
          },
        ),
        FFRoute(
          name: 'favoriteList',
          path: '/favoriteList',
          builder: (context, params) => const FavoriteListWidget(),
        ),
        FFRoute(
          name: 'customerProfile',
          path: '/customerProfile',
          builder: (context, params) {
            return CustomerProfileWidget(
              username: params.getParam(
                'username',
                ParamType.String,
              ),
              email: params.getParam(
                'email',
                ParamType.String,
              ),
              address: params.getParam(
                'address',
                ParamType.String,
              ),
              phoneNumber: params.getParam(
                'phoneNumber',
                ParamType.String,
              ),
              profilePhoto: params.getParam(
                'profilePhoto',
                ParamType.String,
              ),
            );
          },
        ),
        FFRoute(
          name: 'NavigationMenu',
          path: '/NavigationMenu',
          builder: (context, params) => const NavigationMenuWidget(),
        ),
        FFRoute(
          name: 'NavigationMenuOrders',
          path: '/NavigationMenuOrders',
          builder: (context, params) => const NavigationMenuOrdersWidget(),
        ),
        FFRoute(
          name: 'moodQuiz',
          path: '/moodQuiz',
          builder: (context, params) => const MoodQuizWidget(),
        ),
        FFRoute(
          name: 'customerHome',
          path: '/customerHome',
          builder: (context, params) => const CustomerHomeWidget(),
        ),
        FFRoute(
          name: 'HomePage',
          path: '/homePage',
          builder: (context, params) => const CustomerLayout(),
        ),
        FFRoute(
          name: 'FullExplore',
          path: '/fullExplore',
          builder: (context, params) => const ViewMoreExploreWidget(),
        ),
        FFRoute(
          name: 'myprofileCustomer',
          path: '/myprofileCustomer',
          builder: (context, params) => const MyprofileCustomerWidget(),
        ),
        FFRoute(
          name: 'cart',
          path: '/cart',
          builder: (context, params) => const CartWidget(),
        ),
        FFRoute(
          name: 'inventory',
          path: '/inventory',
          builder: (context, params) => const InventoryWidget(),
        ),
        FFRoute(
          name: 'webview',
          path: '/webview',
          builder: (context, params) => const WebviewWidget(),
        ),
        FFRoute(
          name: 'myprofileCustomer',
          path: '/myprofileCustomer',
          builder: (context, params) => const MyprofileCustomerWidget(),
        ),
        FFRoute(
          name: 'cart',
          path: '/cart',
          builder: (context, params) => const CartWidget(),
        ),
        FFRoute(
          name: 'inventory',
          path: '/inventory',
          builder: (context, params) => const InventoryWidget(),
        ),
        FFRoute(
          name: 'business_Pages',
          path: '/business',
          builder: (context, params) => const BusinessLayout(),
        ),
        // FFRoute(
        //   name: 'FullTopPicks',
        //   path: '/fullTopPicks',
        //   builder: (context, params) => const FullTopPicksWidget(),
        // )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() =>
      const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
