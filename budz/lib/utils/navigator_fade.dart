// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

/// Navigator.push(context,  RouteNavigator(page: const TertiaryButtonShowcase()));
///
/// Navigator.pop(context,  RouteNavigator(page: const TertiaryButtonShowcase()));

RouteNavigator({required Widget page}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 100),
  );
}
