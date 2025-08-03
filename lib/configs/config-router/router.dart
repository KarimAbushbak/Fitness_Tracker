import 'dart:async';

import 'package:fittnes_track/providers/on_boarding/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fittnes_track/configs/config-router/route_names.dart';
import 'package:fittnes_track/screens/main_screen.dart';
import 'package:fittnes_track/screens/onboarding_screen.dart';
import 'package:fittnes_track/screens/profile_screen.dart';
import 'package:fittnes_track/screens/sign_in_screen.dart';
import 'package:fittnes_track/screens/sign_up_screen.dart';
import 'package:fittnes_track/screens/workout_list_screen.dart';

import '../../providers/auth/auth_provider.dart';
part 'rediraction.dart';
final routeProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.workoutList,
    // You can change to '/home/workout-list' after auth
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Error: ${state.error}')),
    ),
    redirect: (context,state){
      handleRedirection(context, state, ref);

    },
    routes: [
      /// Onboarding
      GoRoute(
        name: RouteNames.onBoarding,
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      /// Sign In
      GoRoute(
        name: RouteNames.signIn,
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),

      /// Sign Up
      GoRoute(
        name: RouteNames.signUp,
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),


      /// Shell route for /home/*
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.workoutList,
                path: '/home/workout-list',
                builder: (context, state) => const WorkoutListScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.profile,
                path: '/home/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
