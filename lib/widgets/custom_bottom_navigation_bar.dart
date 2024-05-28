import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.selectedPageIndex,
    required this.onIconTap,
  });

  final int selectedPageIndex;
  final Function onIconTap;

  @override
  Widget build(BuildContext context) {
    final barHeight = MediaQuery.of(context).size.height * 0.08;
    final style = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontSize: 12, fontWeight: FontWeight.w600);

    return BottomAppBar(
      color: selectedPageIndex == 0 ? Colors.black : Colors.white,
      child: SizedBox(
        height: barHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _bottomBarNavItem(0, 'Home', style, 'home'),
            _bottomBarNavItem(1, 'Donate', style, 'donate'),
            _addVideoNavItem(barHeight),
            _bottomBarNavItem(3, 'Inbox', style, 'message'),
            _bottomBarNavItem(4, 'Profile', style, 'user'),
          ],
        ),
      ),
    );
  }

  Widget _bottomBarNavItem(
      int index, String label, TextStyle textStyle, String iconName) {
    bool isSelected = selectedPageIndex == index;
    Color iconAndTextColor = isSelected ? Colors.black : Colors.grey;

    if (isSelected && selectedPageIndex == 0) {
      iconAndTextColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => onIconTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/${isSelected ? '${iconName}_filled' : iconName}.svg',
            // ignore: deprecated_member_use
            color: iconAndTextColor,
            height: 24,
            width: 24,
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            label,
            style: textStyle.copyWith(color: iconAndTextColor),
          ),
        ],
      ),
    );
  }

  Widget _addVideoNavItem(double height) {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.redAccent],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          Icons.add,
          color: selectedPageIndex == 0 ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
