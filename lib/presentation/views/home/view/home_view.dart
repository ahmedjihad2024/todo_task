import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/app.dart';
import 'package:todo_task/app/enums.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/common/after_layout.dart';
import 'package:todo_task/presentation/res/color_manager.dart';
import 'package:todo_task/presentation/res/routes_manager.dart';
import 'package:todo_task/presentation/res/translations_manager.dart';

import '../../../res/assets_manager.dart';
import 'widgets/top_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AfterLayout {
  TaskState selectedState = TaskState.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.w),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        SvgManager.appName,
                        colorFilter: ColorFilter.mode(
                            context.colorScheme.onPrimary, BlendMode.srcIn),
                        width: desktopSize(
                            size(
                              mobile: 60.w,
                            ),
                            60),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.person,
                            size: 30.sp,
                            color: context.colorScheme.onPrimary,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.logout,
                            size: 30.sp,
                            color: context.colorScheme.primary,
                          ))
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Text(
                        Translation.my_tasks.tr,
                        style: context.small.copyWith(
                            fontSize: 20.sp,
                            color:
                                context.colorScheme.onPrimary.withOpacity(.3),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  5.verticalSpace,
                  TopBar(
                    initialSelection: selectedState,
                    onSelectedTap: (state) {
                      selectedState = state;
                    },
                  )
                ],
              ),

              // Floating Action Button
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 20.w
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              minimumSize: WidgetStatePropertyAll(
                                  Size(50.w, 50.w)
                              ),
                              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                              backgroundColor: WidgetStatePropertyAll(context.colorScheme.onPrimary.withOpacity(.1))
                          ),
                          child: Icon(
                            Icons.qr_code_2_rounded,
                            size: 40.sp,
                            color: context.colorScheme.primary,
                          )
                      ),
                      10.verticalSpace,
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(RoutesManager.addNewTask.route);
                        },
                        style: ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(
                            Size(60.w, 60.w)
                          ) ,
                          backgroundColor: WidgetStatePropertyAll(context.colorScheme.primary),
                          shadowColor: WidgetStatePropertyAll(
                            context.colorScheme.onPrimary.withOpacity(.7)
                          ),
                          elevation: const WidgetStatePropertyAll(10)
                        ),
                        child: Icon(
                          Icons.add,
                          size: 40.sp,
                          color: context.colorScheme.onPrimaryContainer,
                        )
                    )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {}
}
