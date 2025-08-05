import "package:flutter/material.dart";
import "package:magicposbeta/modules/page_profile.dart";
import "package:magicposbeta/theme/home_pages_profiles.dart";

class CustomButton extends StatelessWidget {
  final double ratio = 0.12;
  final PageProfile profile;
  final double fontSize;
  final bool nullOnPressed;
  final double width;
  final double iconSize;
  final double height;

  const CustomButton(
      {super.key,
      this.fontSize = 20,
      this.iconSize = 40,
      this.height = 180,
      this.nullOnPressed = false,
      this.width = 180,
      required this.profile,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: nullOnPressed
            ? null
            : () {

                Navigator.of(context).pushNamed(
                  profile.route,
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                profile.icon,
                color: Colors.blue,
                size: iconSize,
              ),
              Text(
                '${profile.enName}\n${profile.arName}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//todo remove provider
