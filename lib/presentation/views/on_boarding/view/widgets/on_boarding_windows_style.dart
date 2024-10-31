

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_task/app/extensions.dart';

import '../../../../res/assets_manager.dart';
import '../../../../res/translations_manager.dart';

class OnBoardingWindowsStyle extends StatelessWidget {
  final Function() onClick;
  const OnBoardingWindowsStyle(this.onClick, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImagesManager.art2,
              width: 300,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(
              width: 80,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Translation.on_splash_title_one.tr,
                  textAlign: TextAlign.center,
                  style: context.small.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: context.theme.colorScheme.onPrimary),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  Translation.on_splash_title_two.tr,
                  textAlign: TextAlign.center,
                  style: context.small.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: context.theme.colorScheme.onPrimary
                          .withOpacity(.5)),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: onClick,
                      style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 100
                          )),
                          backgroundColor:
                          WidgetStatePropertyAll(context.colorScheme.primary),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Translation.let_start.tr,
                            style: context.small.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: context.theme.colorScheme.onPrimaryContainer),
                          ),
                            const SizedBox(
                              width: 8,
                            ),
                          SvgPicture.asset(
                            SvgManager.arrowLeft,
                            width: 23,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}
