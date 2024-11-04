


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/extensions.dart';

import '../../../../res/assets_manager.dart';
import '../../../../res/translations_manager.dart';

class OnBoardingPhoneStyle extends StatelessWidget {
  final Function() onClick;
  const OnBoardingPhoneStyle(this.onClick, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                ImagesManager.art,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Translation.on_splash_title_one.tr,
                        textAlign: TextAlign.center,
                        style: context.small.copyWith(
                            fontSize: size(mobile: 30.sp, tablet: 23.sp),
                            fontWeight: FontWeight.w700,
                            color: context.theme.colorScheme.onPrimary),
                      ),
                      SizedBox(
                        height: size(mobile: 15.w, tablet: 8.w),
                      ),
                      Text(
                        Translation.on_splash_title_two.tr,
                        textAlign: TextAlign.center,
                        style: context.small.copyWith(
                            fontSize: size(mobile: 18.sp, tablet: 14.sp),
                            fontWeight: FontWeight.w400,
                            color: context.theme.colorScheme.onPrimary
                                .withOpacity(.5)),
                      ),
                      SizedBox(
                        height: size(mobile: 30.w, tablet: 20.w),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: onClick,
                              style: ButtonStyle(
                                  padding: WidgetStatePropertyAll(EdgeInsets.all(size(mobile: 15.w, tablet: 10.w))),
                                  backgroundColor:
                                  WidgetStatePropertyAll(context.colorScheme.primary),
                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r)))
                              ),

                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    Translation.let_start.tr,
                                    style: context.small.copyWith(
                                        fontSize: size(mobile: 22.sp, tablet: 17.sp),
                                        fontWeight: FontWeight.w700,
                                        color: context.theme.colorScheme.onPrimaryContainer),
                                  ),
                                  8.horizontalSpace,
                                  SvgPicture.asset(
                                    SvgManager.arrowLeft,
                                    width: size(mobile: 23.w, tablet: 18.w),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size(mobile: 60.w, tablet: 35.w),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
