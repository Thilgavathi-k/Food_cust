import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final String iconimage;
  final Function onTap;
  final bool isSelected;
  BottomNavItem({@required this.iconimage, this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:InkWell(
        onTap: onTap,
        child: Image.asset(iconimage.toString(),width: 40,height: 40,color: isSelected ? Theme.of(context).primaryColor :  Color(0xff483838),),

      )

      // child: IconButton(
      //   // icon: Icon(iconData, color: isSelected ? Theme.of(context).primaryColor : Colors.grey, size: 25),
      //   icon: iconimage,color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
      //   onPressed: onTap,
      // ),
      // child: InkWell(
      //   onTap: onTap,
      //   child:  iconimage,
      // ),
    );
  }
}
