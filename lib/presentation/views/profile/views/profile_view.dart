


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/common/after_layout.dart';
import 'package:todo_task/presentation/views/profile/bloc/profile_bloc.dart';

import '../../../common/state_render.dart';
import '../../../res/assets_manager.dart';
import '../../../res/translations_manager.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with AfterLayout {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: desktopSize(20.w, 20),
            left: desktopSize(20.w, 20),
            right: desktopSize(20.w, 20)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Transform.rotate(
                        angle: 180 * pi / 180,
                        child: SvgPicture.asset(
                          SvgManager.arrowLeft,
                          width: desktopSize(23.w, 25),
                          colorFilter: ColorFilter.mode(
                              context.colorScheme.onPrimary,
                              BlendMode.srcIn),
                        ),
                      )),
                  SizedBox(
                    width: desktopSize(15.w, 15),
                  ),
                  Text(
                   Translation.profile_details.tr,
                    style: context.small.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: desktopSize(20.sp, 20),
                        color: context.colorScheme.onPrimary),
                  )
                ],
              ),
              BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (_, __) => true,
                builder: (context, state) {
                  return ScreenState.setState(
                      reqState: state.reqState,
                      online: () {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: desktopSize(30.w, 30),
                                ),
                                ...<dynamic>[
                                  state.details!.name,
                                  state.details!.phone,
                                  state.details!.level.name,
                                  state.details!.yearsExperience,
                                  state.details!.address,
                                ].map((e){
                                  return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: desktopSize(15.w, 15),
                                      horizontal: desktopSize(10.w, 10)
                                    ),
                                    margin: EdgeInsets.only(
                                      bottom: desktopSize(10.w, 10)
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.colorScheme.onPrimary.withOpacity(.08),
                                      borderRadius: BorderRadius.circular(10.r)
                                    ),
                                    child: Text(e.toString(), style: context.small.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: context.colorScheme.onPrimary.withOpacity(.4),
                                      fontSize: desktopSize(20.sp, 18)
                                    ),),
                                  );
                                })
                              ],
                            ),
                          ),
                        );
                      },
                      loading: () {
                        return Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: context.colorScheme.onPrimary,
                              strokeCap: StrokeCap.round,
                              strokeWidth: 3,
                            ),
                          ),
                        );
                      },
                      error: (){
                        return Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(desktopSize(20.w, 20)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: context.small.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: context.colorScheme.onPrimary,
                                        fontSize: desktopSize(18.w, 18)),
                                  ),
                                  SizedBox(
                                    height: desktopSize(5.w, 5),
                                  ),
                                  TextButton(
                                    onPressed: (){
                                      context.read<ProfileBloc>().add(GetProfileDetails());
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            context.colorScheme.primary),
                                        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: desktopSize(20.w, 20))),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.r)))),
                                    child: Text(
                                      Translation.try_again.tr,
                                      style: context.small.copyWith(
                                          fontSize: desktopSize(18.sp, 16),
                                          fontWeight: FontWeight.w700,
                                          color: context
                                              .theme.colorScheme.onPrimaryContainer),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    context.read<ProfileBloc>().add(GetProfileDetails());
  }
}
