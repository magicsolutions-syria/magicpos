import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../components/text_with_icon.dart';
import '../theme/app_profile.dart';

class MainScreensTemplate extends StatelessWidget {
  const MainScreensTemplate({super.key, required this.child});
  final Widget child;
  final double ratio = 2.24 / 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 670,
          margin: EdgeInsets.all(ratio * MediaQuery.of(context).size.width),
          padding: EdgeInsets.symmetric(
            horizontal: (ratio + 0.015) * MediaQuery.of(context).size.width,
            vertical: ratio * MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).fieldsColor,
            borderRadius: BorderRadius.circular(
              ratio * MediaQuery.of(context).size.width,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Image(
                    width: 150,
                    height: 150,
                    image: AssetImage(AppProfile.logo),
                  ),
                  Text(
                    AppProfile.name,
                    style: TextStyle(
                      fontSize: 42,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              child,
              SizedBox(
                height: ratio / 10 * MediaQuery.of(context).size.width,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWithIcon(
                    title: "${AppProfile.tel}${FieldsNames.tel}",
                    icon: Icons.phone_outlined,
                  ),
                  TextWithIcon(
                    title: "${AppProfile.mobile}${FieldsNames.mobile}",
                    icon: Icons.phone_android_outlined,
                  ),
                  TextWithIcon(

                    title: "${AppProfile.facebook}${FieldsNames.faceBook}",
                    icon: Icons.facebook_outlined,
                  ),
                  TextWithIcon(
                    title: "${AppProfile.email}${FieldsNames.email}",
                    icon: Icons.email_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// finish refactor