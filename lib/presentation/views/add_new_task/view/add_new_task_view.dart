import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:todo_task/app/app.dart';
import 'package:todo_task/app/enums.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/data/request/request.dart';
import 'package:todo_task/presentation/common/toast.dart';
import 'package:todo_task/presentation/res/translations_manager.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:todo_task/presentation/views/add_new_task/bloc/add_new_task_bloc.dart';
import 'package:todo_task/presentation/views/add_new_task/view/widgets/custom_form.dart';
import '../../../../app/dependency_injection.dart';
import '../../../../data/network/api.dart';
import '../../../common/overlay_loading.dart';
import '../../../common/state_render.dart';
import '../../../common/tasks_functions.dart';
import '../../../res/assets_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart' as intl;

import '../../../res/routes_manager.dart';

class AddNewTaskView extends StatefulWidget {
  const AddNewTaskView({super.key});

  @override
  State<AddNewTaskView> createState() => _AddNewTaskViewState();
}

class _AddNewTaskViewState extends State<AddNewTaskView> {
  PlatformFile? selectedFile;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late FocusNode titleFocus;
  late FocusNode descriptionFocus;
  TaskPriority selectedPriority = TaskPriority.low;
  DateTime? selectedDateTime;
  late OverlayLoading overlayLoading;

  Future<void> addImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    titleFocus = FocusNode();
    descriptionFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }

  void onClick() async {
    if (titleController.text.trim().isEmpty) {
      titleFocus.requestFocus();
    } else if (descriptionController.text.trim().isEmpty) {
      descriptionFocus.requestFocus();
    } else if (selectedFile == null) {
      showToast(
          msg: Translation.choose_image.tr,
          type: ToastificationType.warning,
          context: context);
    } else if (selectedDateTime == null) {
      showToast(
          msg: Translation.choose_due_date.tr,
          type: ToastificationType.warning,
          context: context);
    } else {

      context.read<AddNewTaskBloc>().add(AddTaskEvent(
          image: File(selectedFile!.path!),
          title: titleController.text,
          priority: selectedPriority.name,
          description: descriptionController.text,
          dueDate: intl.DateFormat("yyyy-MM-dd", context.locale.languageCode)
              .format(selectedDateTime!))
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    overlayLoading = OverlayLoading(context);

    return Scaffold(
      body: BlocConsumer<AddNewTaskBloc, AddNewTaskState>(
        buildWhen: (_, __) => false,
        listener: (context, state) {
          if (state.errorMessage != null && state.reqState == ReqState.error) {
            sleep(const Duration(seconds: 1));
            overlayLoading.hideLoading();
            showToast(
                msg: state.errorMessage!,
                type: ToastificationType.warning,
                context: context,
                timeInSec: 5);
          } else if (state.reqState == ReqState.success) {
            overlayLoading.hideLoading();
            Navigator.pop(context);
          } else if (state.reqState == ReqState.loading) {
            overlayLoading.showLoading();
          }
        },
        builder: (context, state) {
          return PopScope(
            canPop: state.reqState != ReqState.loading,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20.w),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, left: 20.w, right: 20.w),
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
                                  width: 23.w,
                                  colorFilter: ColorFilter.mode(
                                      context.colorScheme.onPrimary,
                                      BlendMode.srcIn),
                                ),
                              )),
                          15.horizontalSpace,
                          Text(
                            Translation.add_new_task.tr,
                            style: context.small.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                                color: context.colorScheme.onPrimary),
                          )
                        ],
                      ),
                      20.verticalSpace,
                      DottedBorder(
                        strokeWidth: 2,
                        color: context.colorScheme.primary,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10.r),
                        dashPattern: const [3, 3],
                        child: InkWell(
                          onTap: addImage,
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            width: double.infinity,
                            height: 65.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (selectedFile == null) ...[
                                  Icon(
                                    Icons.image_outlined,
                                    size: 45.sp,
                                    color: context.colorScheme.primary,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    Translation.add_image.tr,
                                    style: context.small.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.sp,
                                        color: context.colorScheme.primary),
                                  )
                                ] else
                                  Image.file(File(selectedFile!.path!))
                              ],
                            ),
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      Text(
                        Translation.task_title.tr,
                        style: context.small.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: context.colorScheme.onPrimary.withOpacity(.4)),
                      ),
                      5.verticalSpace,
                      CustomForm(
                        hintText: Translation.enter_title_here.tr,
                        keyboardType: TextInputType.text,
                        controller: titleController,
                        focusNode: titleFocus,
                        height: desktopSize(50.w, 55),
                        padding: EdgeInsets.symmetric(
                            horizontal: desktopSize(13.w, 15)),
                        width: desktopSize(double.infinity, 300),
                      ),
                      15.verticalSpace,
                      Text(
                        Translation.task_description.tr,
                        style: context.small.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: context.colorScheme.onPrimary.withOpacity(.4)),
                      ),
                      5.verticalSpace,
                      CustomForm(
                        hintText: Translation.enter_description_here.tr,
                        keyboardType: TextInputType.name,
                        controller: descriptionController,
                        height: desktopSize(200.w, 200),
                        maxLines: 20,
                        textInputAction: TextInputAction.newline,
                        focusNode: descriptionFocus,
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(desktopSize(13.w, 15)),
                        width: desktopSize(double.infinity, 300),
                      ),
                      15.verticalSpace,
                      Text(
                        Translation.priority.tr,
                        style: context.small.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: context.colorScheme.onPrimary.withOpacity(.4)),
                      ),
                      5.verticalSpace,
                      Container(
                        height: desktopSize(50.w, 50),
                        width: double.infinity,
                        padding: EdgeInsetsDirectional.only(
                            start: desktopSize(13.w, 13)),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: context.colorScheme.onPrimary.withOpacity(.05),
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 30.sp,
                              color: context.colorScheme.primary,
                            ),
                            5.horizontalSpace,
                            Expanded(
                              child: DropdownButton<TaskPriority>(
                                value: selectedPriority,
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(13.r),
                                padding: EdgeInsetsDirectional.only(
                                    end: desktopSize(13.w, 13)),
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: desktopSize(40.sp, 25),
                                  color: context.colorScheme.primary,
                                ),
                                elevation: 16,
                                menuWidth: desktopSize(140.w, 150),
                                menuMaxHeight: .6 * deviceDetails.height,
                                style: context.small.copyWith(
                                    fontSize: desktopSize(16.sp, 14),
                                    fontWeight: FontWeight.w400,
                                    color: context.colorScheme.primary),
                                underline: Container(
                                  height: 0,
                                ),
                                alignment: Alignment.centerLeft,
                                onChanged: (TaskPriority? p) {
                                  setState(() {
                                    selectedPriority = p!;
                                  });
                                },
                                items: TaskPriority.values
                                    .map<DropdownMenuItem<TaskPriority>>(
                                        (TaskPriority value) {
                                  return DropdownMenuItem<TaskPriority>(
                                    value: value,
                                    child: Text(
                                      getPriorityText(value),
                                      style: context.small.copyWith(
                                          fontSize: desktopSize(18.sp, 14),
                                          fontWeight: FontWeight.w500,
                                          color: context.colorScheme.primary),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      Text(
                        Translation.due_date.tr,
                        style: context.small.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: context.colorScheme.onPrimary.withOpacity(.4)),
                      ),
                      5.verticalSpace,
                      InkWell(
                        onTap: () async {
                          DateTime? result = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 1 * 365)));
                          if (result != null) {
                            setState(() {
                              selectedDateTime = result;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(13.r),
                        child: Container(
                          height: desktopSize(50.w, 50),
                          width: double.infinity,
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal: desktopSize(13.w, 13)),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              // color: context.colorScheme.onPrimaryContainer,
                              borderRadius: BorderRadius.circular(13.r),
                              border: Border.all(
                                  color: context.colorScheme.onPrimary
                                      .withOpacity(.2),
                                  width: .5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDateTime == null
                                    ? Translation.choose_due_date.tr
                                    : intl.DateFormat("d MMMM, yyyy",
                                            context.locale.languageCode)
                                        .format(selectedDateTime!),
                                style: context.small.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: context.colorScheme.onPrimary
                                        .withOpacity(.4)),
                              ),
                              Icon(
                                Icons.date_range_rounded,
                                size: 30.sp,
                                color: context.colorScheme.primary,
                              )
                            ],
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      TextButton(
                        onPressed: onClick,
                        style: ButtonStyle(
                            minimumSize: WidgetStatePropertyAll(
                                Size(double.infinity, 50.w)),
                            backgroundColor: WidgetStatePropertyAll(
                                context.colorScheme.primary),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)))),
                        child: Text(
                          Translation.add_task.tr,
                          style: context.small.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color:
                                  context.theme.colorScheme.onPrimaryContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
