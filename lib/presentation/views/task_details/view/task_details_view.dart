import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:todo_task/app/enums.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/common/after_layout.dart';
import 'package:todo_task/presentation/common/capture_widget.dart';
import 'package:todo_task/presentation/common/tasks_functions.dart';
import 'package:todo_task/presentation/views/task_details/bloc/task_details_bloc.dart';

import '../../../../app/constants.dart';
import '../../../../domain/model/models.dart';
import '../../../common/overlay_loading.dart';
import '../../../common/state_render.dart';
import '../../../common/toast.dart';
import '../../../res/assets_manager.dart';
import '../../../res/routes_manager.dart';
import '../../../res/translations_manager.dart';
import '../../home/bloc/home_bloc.dart';

class TaskDetailsView extends StatefulWidget {
  final TaskDetails tasksDetails;

  const TaskDetailsView({super.key, required this.tasksDetails});

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> with AfterLayout {
  late TaskState selectedState;
  late OverlayLoading overlayLoading;
  final CaptureController captureController = CaptureController();

  @override
  void initState() {
    selectedState = widget.tasksDetails.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: BlocConsumer<TaskDetailsBloc, TaskDetailsState>(
        buildWhen: (_, __) => false,
        listener: (context, state) {
          if(state.errorMessage != null && state.reqState == ReqState.toastError){
            overlayLoading.hideLoading();
            showToast(
                msg: state.errorMessage!,
                type: ToastificationType.warning,
                context: context,
                timeInSec: 5);
          }
          else if (state.errorMessage != null && state.reqState == ReqState.error) {
            overlayLoading.hideLoading();
            showToast(
                msg: state.errorMessage!,
                type: ToastificationType.warning,
                context: context,
                timeInSec: 5);
          } else if (state.reqState == ReqState.success) {
            overlayLoading.hideLoading();
            context.read<HomeBloc>().add(HomeUpdateTaskEvent(TaskDetails(
                  image: widget.tasksDetails.image,
                  priority: widget.tasksDetails.priority,
                  description: widget.tasksDetails.description,
                  title: widget.tasksDetails.title,
                  user: widget.tasksDetails.user,
                  id: widget.tasksDetails.id,
                  status: selectedState,
                  createdAt: widget.tasksDetails.createdAt,
                  updatedAt: widget.tasksDetails.updatedAt,
                )));
          } else if (state.reqState == ReqState.loading) {
            overlayLoading.showLoading();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: desktopSize(20.w, 20)),
              child: SafeArea(
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding:
                          EdgeInsets.only(top: desktopSize(20.w, 20), left: desktopSize(20.w, 20), right: desktopSize(20.w, 20)),
                    child: SizedBox(
                        width: Platform.isWindows ? 500 : null,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                          width: desktopSize(size(mobile: 23.w, tablet: 19.w), 25),
                                          colorFilter: ColorFilter.mode(
                                              context.colorScheme.onPrimary,
                                              BlendMode.srcIn),
                                        ),
                                      )),
                                  SizedBox(
                                    width: desktopSize(size(mobile: 15.w, tablet: 12.w), 15),
                                  ),
                                  Text(
                                    Translation.task_details.tr,
                                    style: context.small.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: desktopSize(size(mobile: 20.sp, tablet: 18.sp), 20),
                                        color: context.colorScheme.onPrimary),
                                  ),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    onSelected: (String item) {
                                      if (item == "1") {
                                        // edit
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushNamed(
                                            RoutesManager.addNewTask.route,
                                            arguments: {
                                              'new-task': false,
                                              "details": widget.tasksDetails
                                            });
                                      } else {
                                        // 2 - delete
                                        context.read<HomeBloc>().add(
                                            HomeDeleteTaskEvent(
                                                widget.tasksDetails));
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem<String>(
                                          value: "1",
                                          child: Text(
                                            Translation.edit.tr,
                                            style: context.small.copyWith(
                                                fontSize: desktopSize(size(mobile: 17.sp, tablet: 13.sp), 16),
                                                color:
                                                    context.colorScheme.onPrimary,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: "2",
                                          child: Text(
                                            Translation.delete.tr,
                                            style: context.small.copyWith(
                                                fontSize: desktopSize(size(mobile: 17.sp, tablet: 13.sp), 16),
                                                color:
                                                    context.colorScheme.onPrimary,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ];
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: desktopSize(20.w, 20),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                clipBehavior: Clip.hardEdge,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${Constants.baseUrl}images/${widget.tasksDetails.image}",
                                  width: double.infinity,
                                  height: desktopSize(size(mobile: 250.w, tablet: 200.w), 250),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: desktopSize(15.w, 15),
                              ),
                              Text(
                                widget.tasksDetails.title,
                                softWrap: true,
                                style: context.small.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: desktopSize(size(mobile: 30.sp, tablet: 25.sp), 30),
                                    color: context.colorScheme.onPrimary),
                              ),
                              Text(
                                widget.tasksDetails.description,
                                softWrap: true,
                                style: context.small.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: desktopSize(size(mobile: 18.sp, tablet: 14.sp), 18),
                                    color: context.colorScheme.onPrimary
                                        .withOpacity(.5)),
                              ),
                              SizedBox(
                                height: desktopSize(15.w, 15),
                              ),
                              Container(
                                height: desktopSize(size(mobile: 50.w, tablet: 35.w), 50),
                                width: double.infinity,
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: desktopSize(13.w, 13)),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    // color: context.colorScheme.onPrimaryContainer,
                                    borderRadius: BorderRadius.circular(13.r),
                                    color: context.colorScheme.primary
                                        .withOpacity(.08)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat("d MMMM, yyyy",
                                              context.locale.languageCode)
                                          .format(widget.tasksDetails.createdAt),
                                      style: context.small.copyWith(
                                          fontSize: desktopSize(size(mobile: 16.sp, tablet: 13.sp), 16),
                                          fontWeight: FontWeight.w600,
                                          color: context.colorScheme.onPrimary),
                                    ),
                                    Icon(
                                      Icons.date_range_rounded,
                                      size: desktopSize(size(mobile: 30.sp, tablet: 25.sp), 30),
                                      color: context.colorScheme.primary,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: desktopSize(10.w, 10),
                              ),
                              Container(
                                height: desktopSize(size(mobile: 50.w, tablet: 35.w), 50),
                                width: double.infinity,
                                padding: EdgeInsetsDirectional.only(
                                    start: desktopSize(13.w, 13)),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: context.colorScheme.primary
                                      .withOpacity(.08),
                                  borderRadius: BorderRadius.circular(13.r),
                                ),
                                child: DropdownButton<TaskState>(
                                  value: selectedState,
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(13.r),
                                  padding: EdgeInsetsDirectional.only(
                                      end: desktopSize(13.w, 13)),
                                  icon: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    size: desktopSize(size(mobile: 40.sp, tablet: 25.sp), 25),
                                    color: context.colorScheme.primary,
                                  ),
                                  elevation: 16,
                                  menuWidth: desktopSize(140.w, 150),
                                  menuMaxHeight: .6 * deviceDetails.height,
                                  style: context.small.copyWith(
                                      fontSize: desktopSize(size(mobile: 16.sp, tablet: 13.sp), 16),
                                      fontWeight: FontWeight.w600,
                                      color: context.colorScheme.primary),
                                  underline: Container(
                                    height: 0,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  onChanged: (TaskState? p) {
                                    setState(() {
                                      selectedState = p!;
                                    });
                                    context.read<TaskDetailsBloc>().add(
                                        UpdateTaskEvent(
                                            id: widget.tasksDetails.id,
                                            status: p!.name));
                                  },
                                  items: TaskState.values
                                      .getRange(1, TaskState.values.length)
                                      .map<DropdownMenuItem<TaskState>>(
                                          (TaskState value) {
                                    return DropdownMenuItem<TaskState>(
                                      value: value,
                                      child: Text(
                                        getTaskStateText(value),
                                        style: context.small.copyWith(
                                            fontSize: desktopSize(size(mobile: 18.sp, tablet: 14.sp), 16),
                                            fontWeight: FontWeight.w600,
                                            color: context.colorScheme.primary),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: desktopSize(10.w, 10),
                              ),
                              Container(
                                height: desktopSize(size(mobile: 50.w, tablet: 35.w), 50),
                                width: double.infinity,
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: desktopSize(13.w, 13)),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    // color: context.colorScheme.onPrimaryContainer,
                                    borderRadius: BorderRadius.circular(13.r),
                                    color: context.colorScheme.primary
                                        .withOpacity(.08)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.flag_outlined,
                                      size: desktopSize(size(mobile: 30.sp, tablet: 22.sp), 30),
                                      color: context.colorScheme.primary,
                                    ),
                                    SizedBox(
                                      width: desktopSize(5.w, 5),
                                    ),
                                    Text(
                                      getPriorityText(
                                          widget.tasksDetails.priority),
                                      style: context.small.copyWith(
                                          fontSize: desktopSize(size(mobile: 16.sp, tablet: 13.sp), 16),
                                          fontWeight: FontWeight.w600,
                                          color: context.colorScheme.primary),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: desktopSize(10.w, 10),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<TaskDetailsBloc>()
                                          .add(SaveQrAsImage(captureController));
                                    },
                                    splashColor: Colors.transparent,
                                    child: CaptureWidget(
                                      controller: captureController,
                                      child: Container(
                                        color: context.theme.scaffoldBackgroundColor,
                                        child: QrImageView(
                                          data: widget.tasksDetails.id,
                                          version: QrVersions.auto,
                                          size: desktopSize(size(mobile: 300.w, tablet: 250.w), 300),
                                          gapless: true,
                                          eyeStyle: QrEyeStyle(
                                              eyeShape: QrEyeShape.square,
                                              color: context.colorScheme.onPrimary),
                                          embeddedImageStyle:
                                              const QrEmbeddedImageStyle(
                                            size: Size(50, 50),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ]),
                      ),
                  )));
        },
      ),
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    overlayLoading = OverlayLoading(context);
  }
}
