import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialCard extends StatefulWidget {
  const SocialCard({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);
  final String icon;
  final Function()? press;

  @override
  State<SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<SocialCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        margin:EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(12),
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Color(0XFF45454),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(widget.icon),
      ),
    );
  }
}