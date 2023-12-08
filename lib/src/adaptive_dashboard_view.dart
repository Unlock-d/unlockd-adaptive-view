import 'package:unlockd_adaptive_view/src/adaptive_layout.dart';
import 'package:unlockd_adaptive_view/src/breakpoints.dart';
import 'package:unlockd_adaptive_view/src/slot_layout.dart';
import 'package:flutter/material.dart';

/// An adaptive view that provide base dashboard view.
///
/// Internally this widget use [AdaptiveLayout] to provide adaptivity.
class AdaptiveDashboardView extends StatelessWidget {
  /// Creates a const [AdaptiveDashboardView] widget.
  const AdaptiveDashboardView({
    required this.bodyBuilder,
    this.sidebarBuilder,
    this.bottomNavigationBarBuilder,
    this.animationDuration = defaultAnimationDuration,
    this.smallBreakpoint = defaultSmallBreakpoint,
    this.mediumBreakpoint = defaultMediumBreakpoint,
    this.largeBreakpoint = defaultLargeBreakpoint,
    super.key,
  });

  final Widget Function(BuildContext) bodyBuilder;
  final Widget Function(BuildContext)? sidebarBuilder;
  final Widget Function(BuildContext)? bottomNavigationBarBuilder;
  final Duration animationDuration;
  final Breakpoint smallBreakpoint;
  final Breakpoint mediumBreakpoint;
  final Breakpoint largeBreakpoint;

  static const defaultSmallBreakpoint = WidthPlatformBreakpoint(end: 700);
  static const defaultMediumBreakpoint =
      WidthPlatformBreakpoint(begin: 700, end: 1200);
  static const defaultLargeBreakpoint = WidthPlatformBreakpoint(begin: 1200);

  static const defaultAnimationDuration = Duration(milliseconds: 500);

  /// Animation from bottom offscreen up onto the screen.
  static AnimatedWidget bottomToTop(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from on the screen down off the screen.
  static AnimatedWidget topToBottom(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, 1),
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from left off the screen into the screen.
  static AnimatedWidget leftOutIn(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from on screen to left off screen.
  static AnimatedWidget leftInOut(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1, 0),
      ).animate(animation),
      child: child,
    );
  }

  /// Animation from right off screen to on screen.
  static AnimatedWidget rightOutIn(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Fade in animation.
  static Widget fadeIn(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInCubic),
      child: child,
    );
  }

  /// Fade out animation.
  static Widget fadeOut(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: ReverseAnimation(animation),
        curve: Curves.easeInCubic,
      ),
      child: child,
    );
  }

  /// Keep widget on screen while it is leaving
  static Widget stayOnScreen(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 1).animate(animation),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: AdaptiveLayout(
          bodyRatio: 1,
          primaryNavigation: SlotLayout(
            animationDuration: defaultAnimationDuration,
            config: {
              Breakpoints.standard: SlotLayout.from(
                key: const Key('primaryNavigation'),
                builder: sidebarBuilder,
              ),
            },
          ),
          bottomNavigation: SlotLayout(
            animationDuration: defaultAnimationDuration,
            config: <Breakpoint, SlotLayoutConfig>{
              smallBreakpoint: SlotLayout.from(
                key: const Key('bottomNavigation'),
                builder: bottomNavigationBarBuilder,
              ),
            },
          ),
          body: SlotLayout(
            animationDuration: defaultAnimationDuration,
            config: <Breakpoint, SlotLayoutConfig?>{
              Breakpoints.standard: SlotLayout.from(
                key: const Key('body'),
                inAnimation: fadeIn,
                outAnimation: fadeOut,
                builder: bodyBuilder,
              ),
              mediumBreakpoint: SlotLayout.from(
                key: const Key('body'),
                inAnimation: fadeIn,
                outAnimation: fadeOut,
                builder: bodyBuilder,
              ),
            },
          ),
        ),
      ),
    );
  }
}
