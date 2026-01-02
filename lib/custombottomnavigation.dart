import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';

class Custombottomnavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavTap;

  const Custombottomnavigation({
    super.key,
    required this.selectedIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
      backgroundColor: bg,
      color: kred,
      onTap: onNavTap,
      items: List.generate(4, (index) {
        return Padding(
          padding: EdgeInsets.only(top: selectedIndex == index ? 0 : 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIconForIndex(index),
                color: Colors.white,
              ),
              const SizedBox(height: 2),
              if (selectedIndex != index)
                Text(
                  _getLabelForIndex(index),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

IconData _getIconForIndex(int index) {
  switch (index) {
    case 0:
      return Icons.home_outlined;
    case 1:
      return Icons.request_quote_outlined;
    case 2:
      return Icons.bookmark_add_outlined;
    case 3:
      return Icons.handyman_outlined;
    default:
      return Icons.help_outline;
  }
}

String _getLabelForIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'News';
    case 2:
      return 'Report';
    case 3:
      return 'Profile';
    default:
      return '';
  }
}
