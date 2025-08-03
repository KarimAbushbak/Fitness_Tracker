part of 'router.dart';

FutureOr<String?> handleRedirection(
  BuildContext context,
  GoRouterState state,
  Ref<Object?> ref,
) {
  final isSignInRoute = state.matchedLocation == RouteNames.signIn;
  final isOnBoardingRoute = state.matchedLocation == RouteNames.onBoarding;
  final isSignUpRoute = state.matchedLocation == RouteNames.signUp;
  if(isSignInRoute || isOnBoardingRoute || isSignUpRoute) {
    return null;

  }



  final hasSeenOnboarding = _hasSeenOnboarding(ref);
  if (!hasSeenOnboarding) {
    return RouteNames.onBoarding;
  }
  final isAuthenticated = _isAuthenticated(ref);
  if (!isAuthenticated) {
    return RouteNames.signIn;
  }

  return null;
}

bool _hasSeenOnboarding(Ref<Object?> ref) {
  final hasSeenOnBoarding = ref.read(hasSeenOnboardingProvider);
  return hasSeenOnBoarding;
}

bool _isAuthenticated(Ref<Object?> ref) {
  final user = ref.read(authNotifierProvider);
  return user?.isAuthenticated == true;
}
