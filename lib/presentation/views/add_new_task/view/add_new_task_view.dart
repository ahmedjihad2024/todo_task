import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:todo_task/app/enums.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/domain/model/models.dart';
import 'package:todo_task/presentation/common/after_layout.dart';
import 'package:todo_task/presentation/common/toast.dart';
import 'package:todo_task/presentation/res/translations_manager.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:todo_task/presentation/views/add_new_task/bloc/add_new_task_bloc.dart';
import 'package:todo_task/presentation/views/add_new_task/view/widgets/custom_form.dart';
import '../../../../app/constants.dart';
import '../../../common/overlay_loading.dart';
import '../../../common/state_render.dart';
import '../../../common/tasks_functions.dart';
import '../../../res/assets_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart' as intl;

import '../../home/bloc/home_bloc.dart';

class AddNewTaskView extends StatefulWidget {
  final bool newTask;
  final TaskDetails? taskDetails;

  const AddNewTaskView({super.key, this.newTask = true, this.taskDetails});

  @override
  State<AddNewTaskView> createState() => _AddNewTaskViewState();
}

class _AddNewTaskViewState extends State<AddNewTaskView> with AfterLayout {
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

    if (!widget.newTask) {
      titleController.text = widget.taskDetails!.title;
      descriptionController.text = widget.taskDetails!.description;
      selectedDateTime = widget.taskDetails!.createdAt;
      selectedPriority = widget.taskDetails!.priority;
    }
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
    if (widget.newTask) {
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
                .format(selectedDateTime!)));
      }
    } else {
      bool isImageChanged = selectedFile != null;
      bool isTitleChanged = titleController.text.trim().isNotEmpty &&
          titleController.text != widget.taskDetails!.title;
      bool isPriorityChanged = selectedPriority != widget.taskDetails!.priority;
      bool isDescriptionChanged =
          descriptionController.text.trim().isNotEmpty &&
              descriptionController.text != widget.taskDetails!.description;
      bool isDueDateChanged =
          selectedDateTime!.compareTo(widget.taskDetails!.createdAt) != 0;

      if(!isDueDateChanged && !isTitleChanged && !isPriorityChanged && !isDescriptionChanged && !isDueDateChanged) return;

      context.read<AddNewTaskBloc>().add(UpdateTaskEvent(
        id: widget.taskDetails!.id,
          image: isImageChanged ? File(selectedFile!.path!) : null,
          title: isTitleChanged ? titleController.text : null,
          priority: isPriorityChanged ? selectedPriority.name : null,
          description: isDescriptionChanged ? descriptionController.text : null,
          dueDate: isDueDateChanged
              ? intl.DateFormat("yyyy-MM-dd", context.locale.languageCode)
                  .format(selectedDateTime!)
              : null
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocConsumer<AddNewTaskBloc, AddNewTaskState>(
        buildWhen: (_, __) => false,
        listener: (context, state) {
          if (state.errorMessage != null && state.reqState == ReqState.error) {
            overlayLoading.hideLoading();
            showToast(
                msg: state.errorMessage!,
                type: ToastificationType.warning,
                context: context,
                timeInSec: 5);
          } else if (state.reqState == ReqState.success) {
            overlayLoading.hideLoading();
            // add task in home
            if(widget.newTask){
              context.read<HomeBloc>().add(HomeAddTaskEvent(state.taskDetails!));
            }else{
              context.read<HomeBloc>().add(HomeUpdateTaskEvent(state.taskDetails!));
            }
            Navigator.pop(context);
          } else if (state.reqState == ReqState.loading) {
            overlayLoading.showLoading();
          }
        },
        builder: (context, state) {
          return PopScope(
            canPop: state.reqState != ReqState.loading,
            child: SingleChildScrollView(
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
                              widget.newTask
                                  ? Translation.add_new_task.tr
                                  : Translation.update.tr,
                              style: context.small.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: desktopSize(20.sp, 20),
                                  color: context.colorScheme.onPrimary),
                            )
                          ],
                        ),
                        SizedBox(
                          height: desktopSize(20.w, 15),
                        ),
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
                              height: desktopSize(65.w, 120),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!widget.newTask && selectedFile == null)
                                    CachedNetworkImage(
                                      imageUrl:
                                          "${Constants.baseUrl}images/${widget.taskDetails!.image}",
                                      fit: BoxFit.cover,
                                    )
                                  else if (selectedFile == null) ...[
                                    Icon(
                                      Icons.image_outlined,
                                      size: desktopSize(45.sp, 45),
                                      color: context.colorScheme.primary,
                                    ),
                                    5.horizontalSpace,
                                    Text(
                                      Translation.add_image.tr,
                                      style: context.small.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: desktopSize(20.sp, 20),
                                          color: context.colorScheme.primary),
                                    )
                                  ] else
                                    Image.file(
                                      File(selectedFile!.path!),
                                      fit: BoxFit.cover,
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: desktopSize(15.w, 15),
                        ),
                        Text(
                          Translation.task_title.tr,
                          style: context.small.copyWith(
                              fontSize: desktopSize(16.sp, 16),
                              fontWeight: FontWeight.w400,
                              color:
                                  context.colorScheme.onPrimary.withOpacity(.4)),
                        ),
                        SizedBox(
                          height: desktopSize(5.w, 5),
                        ),
                        CustomForm(
                          hintText: Translation.enter_title_here.tr,
                          keyboardType: TextInputType.text,
                          controller: titleController,
                          focusNode: titleFocus,
                          height: desktopSize(50.w, 55),
                          padding: EdgeInsets.symmetric(
                              horizontal: desktopSize(13.w, 15)),
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: desktopSize(15.w, 15),
                        ),
                        Text(
                          Translation.task_description.tr,
                          style: context.small.copyWith(
                              fontSize: desktopSize(16.sp, 16),
                              fontWeight: FontWeight.w400,
                              color:
                                  context.colorScheme.onPrimary.withOpacity(.4)),
                        ),
                        SizedBox(
                          height: desktopSize(5.w, 5),
                        ),
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
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: desktopSize(15.w, 15),
                        ),
                        Text(
                          Translation.priority.tr,
                          style: context.small.copyWith(
                              fontSize: desktopSize(16.sp, 16),
                              fontWeight: FontWeight.w400,
                              color:
                                  context.colorScheme.onPrimary.withOpacity(.4)),
                        ),
                        SizedBox(
                          height: desktopSize(5.w, 5),
                        ),
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
                                size: desktopSize(30.sp, 30),
                                color: context.colorScheme.primary,
                              ),
                              SizedBox(
                                width: desktopSize(5.w, 5),
                              ),
                              Expanded(
                                child: DropdownButton<TaskPriority>(
                                  value: selectedPriority,
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(13.r),
                                  padding: EdgeInsetsDirectional.only(
                                      end: desktopSize(13.w, 13)),
                                  icon: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    size: desktopSize(40.sp, 30),
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
                        SizedBox(
                          height: desktopSize(15.w, 15),
                        ),
                        Text(
                          Translation.due_date.tr,
                          style: context.small.copyWith(
                              fontSize: desktopSize(16.sp, 16),
                              fontWeight: FontWeight.w400,
                              color:
                                  context.colorScheme.onPrimary.withOpacity(.4)),
                        ),
                        SizedBox(
                          height: desktopSize(5.w, 5),
                        ),
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
                                      fontSize: desktopSize(16.sp, 16),
                                      fontWeight: FontWeight.w500,
                                      color: context.colorScheme.onPrimary
                                          .withOpacity(.4)),
                                ),
                                Icon(
                                  Icons.date_range_rounded,
                                  size: desktopSize(30.sp, 30),
                                  color: context.colorScheme.primary,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: desktopSize(15.w, 15),
                        ),
                        TextButton(
                          onPressed: onClick,
                          style: ButtonStyle(
                              minimumSize: WidgetStatePropertyAll(
                                  Size(double.infinity, desktopSize(50.w, 60))),
                              backgroundColor: WidgetStatePropertyAll(
                                  context.colorScheme.primary),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.r)))),
                          child: Text(
                            widget.newTask
                                ? Translation.add_task.tr
                                : Translation.update.tr,
                            style: context.small.copyWith(
                                fontSize: desktopSize(20.sp, 20),
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
            ),
          );
        },
      ),
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    overlayLoading = OverlayLoading(context);
  }
}
