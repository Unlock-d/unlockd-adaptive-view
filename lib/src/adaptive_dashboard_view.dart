import 'package:adaptive_view/src/adaptive_layout.dart';
import 'package:adaptive_view/src/breakpoints.dart';
import 'package:adaptive_view/src/slot_layout.dart';
import 'package:flutter/material.dart';

class AdaptiveDashboardView extends StatelessWidget {
  const AdaptiveDashboardView({
    required this.body,
    required this.currentIndex,
    required this.destinations,
    this.sidebarBuilder,
    super.key,
  });

  final Widget body;
  final int currentIndex;
  final List<RoutedNavigationDestination> destinations;
  final Widget Function(BuildContext)? sidebarBuilder;

  static const smallBreakpoint = WidthPlatformBreakpoint(end: 700);
  static const mediumBreakpoint =
      WidthPlatformBreakpoint(begin: 700, end: 1200);
  static const largeBreakpoint = WidthPlatformBreakpoint(begin: 1200);

  static const animationDuration = Duration(milliseconds: 400);

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

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: destinations.map(
        (e) {
          return BottomNavigationBarItem(
            label: e.widget.label,
            icon: e.widget.icon,
          );
        },
      ).toList(),
      onTap: (index) {
        destinations[index].navigate(context, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarTheme(
      data: const BottomNavigationBarThemeData(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: AdaptiveLayout(
            bodyRatio: 1,
            animationDuration: animationDuration,
            primaryNavigation: SlotLayout(
              animationDuration: animationDuration,
              config: {
                Breakpoints.standard: SlotLayout.from(
                  key: const Key('primaryNavigation'),
                  builder: (_) {
                    if (smallBreakpoint.isActive(context)) {
                      return const SizedBox();
                    }
                    return AnimatedContainer(
                      duration: animationDuration,
                      width: largeBreakpoint.isActive(context) ? 192 : 72,
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                      ),
                    );
                  },
                ),
                // largeBreakpoint: SlotLayout.from(
                //   key: const Key('primaryNavigation1'),
                //   builder: (_) {
                //     return Container(
                //       width: 192,
                //       decoration: const BoxDecoration(
                //         color: Colors.blueGrey,
                //       ),
                //     );
                //   },
                // ),
              },
            ),
            bottomNavigation: SlotLayout(
              animationDuration: animationDuration,
              config: <Breakpoint, SlotLayoutConfig>{
                smallBreakpoint: SlotLayout.from(
                  key: const Key('bottomNavigation'),
                  builder: _buildBottomNavigationBar,
                ),
              },
            ),
            body: SlotLayout(
              animationDuration: animationDuration,
              config: <Breakpoint, SlotLayoutConfig?>{
                Breakpoints.standard: SlotLayout.from(
                  key: const Key('body'),
                  inAnimation: fadeIn,
                  outAnimation: fadeOut,
                  builder: (_) => body,
                ),
                mediumBreakpoint: SlotLayout.from(
                  key: const Key('body'),
                  inAnimation: fadeIn,
                  outAnimation: fadeOut,
                  builder: (_) => body,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class RoutedNavigationDestination {
  RoutedNavigationDestination({required this.widget, required this.navigate});

  final NavigationDestination widget;
  final void Function(BuildContext context, int index) navigate;
}
