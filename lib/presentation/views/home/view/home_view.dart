import 'dart:io';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
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
import 'package:flutter/services.dart';
import 'package:todo_task/presentation/res/routes_manager.dart';
import 'package:todo_task/presentation/res/translations_manager.dart';
import 'package:todo_task/presentation/views/home/bloc/home_bloc.dart';
import 'package:todo_task/presentation/views/home/view/widgets/taks_card.dart';
import 'package:window_manager/window_manager.dart';

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

  late HomeBloc _homeBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = context.read<HomeBloc>();
  }

  @override
  void initState() {
    refreshController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    _homeBloc.add(CloseStreams());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: desktopSize(20.w, 20)),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: desktopSize(20.w, 20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              SvgManager.appName,
                              colorFilter: ColorFilter.mode(
                                  context.colorScheme.onPrimary,
                                  BlendMode.srcIn),
                              width: desktopSize(
                                  size(
                                    mobile: 60.w,
                                  ),
                                  100),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      RoutesManager.profileDetails.route);
                                },
                                icon: Icon(
                                  Icons.person,
                                  size: desktopSize(30.sp, 30),
                                  color: context.colorScheme.onPrimary,
                                )),
                            IconButton(
                                onPressed: () {
                                  overlayLoading.showLoading();
                                  context.read<HomeBloc>().add(LogoutEvent(() {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            RoutesManager.login.route,
                                            (_) => false);
                                    overlayLoading.hideLoading();
                                  }));
                                },
                                icon: Icon(
                                  Icons.logout,
                                  size: desktopSize(30.sp, 30),
                                  color: context.colorScheme.primary,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: size(mobile: 10.w, tablet: 5.w),
                        ),
                        Row(
                          children: [
                            Text(
                              Translation.my_tasks.tr,
                              style: context.small.copyWith(
                                  fontSize: desktopSize(
                                      size(mobile: 20.sp, tablet: 16.sp), 20),
                                  color: context.colorScheme.onPrimary
                                      .withOpacity(.3),
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        TopBar(
                          initialSelection: TaskState.all,
                          onSelectedTap: (state) {
                            // selectedState = state;
                            context
                                .read<HomeBloc>()
                                .add(ApplyFilterEvent(state));
                          },
                        ),
                      ],
                    ),
                  ),
                  5.verticalSpace,
                  BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (_, __) => true,
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
                                        ...state.tasksGroup.map((item) {
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
                                      fontSize: desktopSize(
                                          size(mobile: 18.sp, tablet: 14.sp),
                                          18)),
                                ),
                              ),
                            );
                          },
                          error: () {
                            return Expanded(
                              child: Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(desktopSize(20.w, 20)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        state.errorMessage!,
                                        textAlign: TextAlign.center,
                                        style: context.small.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                context.colorScheme.onPrimary,
                                            fontSize: desktopSize(
                                                size(
                                                    mobile: 18.sp,
                                                    tablet: 13.sp),
                                                18)),
                                      ),
                                      5.verticalSpace,
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<HomeBloc>()
                                              .add(RefreshTasksEvent());
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(context
                                                    .colorScheme.primary),
                                            padding: WidgetStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                    horizontal:
                                                        desktopSize(20.w, 20))),
                                            shape: WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r)))),
                                        child: Text(
                                          Translation.try_again.tr,
                                          style: context.small.copyWith(
                                              fontSize: desktopSize(
                                                  size(
                                                      mobile: 18.sp,
                                                      tablet: 12.sp),
                                                  16),
                                              fontWeight: FontWeight.w700,
                                              color: context.theme.colorScheme
                                                  .onPrimaryContainer),
                                        ),
                                      ),
                                    ],
                                  ),
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
                  padding: EdgeInsets.all(desktopSize(20.w, 20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          onPressed: () async {
                            await startQrScanner(context);
                          },
                          style: ButtonStyle(
                              minimumSize: WidgetStatePropertyAll(Size(
                                  desktopSize(
                                      size(mobile: 50.w, tablet: 35.w), 50),
                                  desktopSize(
                                      size(mobile: 50.w, tablet: 35.w), 50))),
                              padding:
                                  const WidgetStatePropertyAll(EdgeInsets.zero),
                              backgroundColor: WidgetStatePropertyAll(context
                                  .colorScheme.onPrimary
                                  .withOpacity(.1))),
                          child: Icon(
                            Icons.qr_code_2_rounded,
                            size: desktopSize(
                                size(mobile: 40.sp, tablet: 25.sp), 25),
                            color: context.colorScheme.primary,
                          )),
                      10.verticalSpace,
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(RoutesManager.addNewTask.route);
                          },
                          style: ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(Size(
                                  desktopSize(
                                      size(mobile: 60.w, tablet: 45.w), 60),
                                  desktopSize(
                                      size(mobile: 60.w, tablet: 45.w), 60))),
                              backgroundColor: WidgetStatePropertyAll(
                                  context.colorScheme.primary),
                              padding:
                                  const WidgetStatePropertyAll(EdgeInsets.zero),
                              shadowColor: WidgetStatePropertyAll(context
                                  .colorScheme.onPrimary
                                  .withOpacity(.7)),
                              elevation: const WidgetStatePropertyAll(10)),
                          child: Icon(
                            Icons.add,
                            size: desktopSize(size(mobile: 40.sp, tablet: 35.sp), 30),
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

  Future<void> startQrScanner(BuildContext context) async {
    if (Platform.isWindows) {
      Navigator.of(context).pushNamed(RoutesManager.qrScanner.route).then((id) {
        if (id != null)
          context
              .read<HomeBloc>()
              .add(GetTaskById(id.toString(), overlayLoading));
      });
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (scannerContext) => AiBarcodeScanner(
            hideGalleryButton: false,
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
            ),
            onDetect: (BarcodeCapture capture) {
              final String? scannedValue = capture.barcodes.first.rawValue;

              context
                  .read<HomeBloc>()
                  .add(GetTaskById(scannedValue!, overlayLoading));
              Navigator.of(scannerContext).pop();
            },
            hideSheetTitle: true,
            hideSheetDragHandler: true,
            validator: (value) => value.barcodes.first.rawValue != null,
          ),
        ),
      );
    }
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    if (Platform.isWindows) await windowManager.show();
    context.read<HomeBloc>().add(RefreshTasksEvent());
    overlayLoading = OverlayLoading(context);
    context.read<HomeBloc>().toastStream().listen((toast) {
      showToast(
          msg: toast,
          type: ToastificationType.warning,
          context: context,
          timeInSec: 5);
    });
    context.read<HomeBloc>().qrResult().listen((taskDetails) {
      Navigator.of(context)
          .pushNamed(RoutesManager.taskDetails.route, arguments: taskDetails);
    });
  }
}
