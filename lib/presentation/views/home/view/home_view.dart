import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:todo_task/app/enums.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/common/after_layout.dart';
import 'package:todo_task/presentation/common/overlay_loading.dart';
import 'package:todo_task/presentation/res/color_manager.dart';
import 'package:todo_task/presentation/res/routes_manager.dart';
import 'package:todo_task/presentation/res/translations_manager.dart';
import 'package:todo_task/presentation/views/home/bloc/home_bloc.dart';
import 'package:todo_task/presentation/views/home/view/widgets/taks_card.dart';

import '../../../../data/network/api.dart';
import '../../../common/state_render.dart';
import '../../../common/toast.dart';
import '../../../res/assets_manager.dart';
import 'widgets/top_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AfterLayout {
  // TaskState selectedState = TaskState.all;
  late RefreshController refreshController;
  late OverlayLoading overlayLoading;

  @override
  void initState() {
    refreshController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20.w),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                                onPressed: () {
                                  overlayLoading.showLoading();
                                  context.read<HomeBloc>().add(LogoutEvent((){
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                        RoutesManager.login.route, (_) => false);
                                    overlayLoading.hideLoading();
                                  }));
                                },
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
                          initialSelection: TaskState.all,
                          onSelectedTap: (state) {
                            // selectedState = state;
                            context.read<HomeBloc>().add(ApplyFilterEvent(state));
                          },
                        ),
                      ],
                    ),
                  ),
                  5.verticalSpace,
                  BlocConsumer<HomeBloc, HomeState>(
                    buildWhen: (_, __) => true,
                    listener: (context, state) async {
                      if (state.errorMessage != null &&
                          state.reqState == ReqState.toastError) {
                        showToast(
                            msg: state.errorMessage!,
                            type: ToastificationType.warning,
                            context: context,
                            timeInSec: 5);
                      }
                    },
                    builder: (context, state) {
                      return ScreenState.setState(
                          reqState: state.reqState,
                          online: () {
                            return Expanded(
                              child: SmartRefresher(
                                  controller: refreshController,
                                  enablePullUp: true,
                                  onRefresh: () {
                                    refreshController.loadComplete();
                                    refreshController.refreshToIdle();
                                    context
                                        .read<HomeBloc>()
                                        .add(RefreshTasksEvent());
                                  },
                                  onLoading: () {
                                    context.read<HomeBloc>().add(
                                        LoadMoreTasksEvent(refreshController));
                                  },
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ...state.tasksGroup.map((item){
                                          return TaskCard(item);
                                        })
                                      ],
                                    ),
                                  )),
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
                          empty: () {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  state.errorMessage!,
                                  style: context.small.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: context.colorScheme.onPrimary,
                                      fontSize: 18.sp),
                                ),
                              ),
                            );
                          },
                      error: (){
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.errorMessage!,
                                  style: context.small.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: context.colorScheme.onPrimary,
                                      fontSize: 18.sp),
                                ),
                                5.verticalSpace,
                                TextButton(
                                  onPressed: (){
                                    context.read<HomeBloc>().add(RefreshTasksEvent());
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          context.colorScheme.primary),
                                      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20.w)),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.r)))),
                                  child: Text(
                                    Translation.try_again.tr,
                                    style: context.small.copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: context
                                            .theme.colorScheme.onPrimaryContainer),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  )
                ],
              ),

              // Floating Action Button
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              minimumSize:
                                  WidgetStatePropertyAll(Size(50.w, 50.w)),
                              padding:
                                  const WidgetStatePropertyAll(EdgeInsets.zero),
                              backgroundColor: WidgetStatePropertyAll(context
                                  .colorScheme.onPrimary
                                  .withOpacity(.1))),
                          child: Icon(
                            Icons.qr_code_2_rounded,
                            size: 40.sp,
                            color: context.colorScheme.primary,
                          )),
                      10.verticalSpace,
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(RoutesManager.addNewTask.route);
                          },
                          style: ButtonStyle(
                              fixedSize:
                                  WidgetStatePropertyAll(Size(60.w, 60.w)),
                              backgroundColor: WidgetStatePropertyAll(
                                  context.colorScheme.primary),
                              shadowColor: WidgetStatePropertyAll(context
                                  .colorScheme.onPrimary
                                  .withOpacity(.7)),
                              elevation: const WidgetStatePropertyAll(10)),
                          child: Icon(
                            Icons.add,
                            size: 40.sp,
                            color: context.colorScheme.onPrimaryContainer,
                          ))
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
  Future<void> afterLayout(BuildContext context) async {
    context.read<HomeBloc>().add(RefreshTasksEvent());
    overlayLoading = OverlayLoading(context);
  }

}
