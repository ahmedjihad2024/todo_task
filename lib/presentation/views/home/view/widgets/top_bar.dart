

import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/extensions.dart';

import '../../../../../app/enums.dart';
import '../../../../common/tasks_functions.dart';

class TopBar extends StatefulWidget {
  final Function(TaskState state) onSelectedTap;
  final TaskState initialSelection;
  const TopBar({super.key, required this.initialSelection, required this.onSelectedTap});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {

  late TaskState selectedState;

  @override
  void initState() {
    selectedState = widget.initialSelection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...TaskState.values.map((item) {
          return TextButton(
              onPressed: () {
                setState(() {
                  selectedState = item;
                  widget.onSelectedTap(item);
                });
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      item == selectedState ? context.colorScheme.primary : context.colorScheme.onPrimary.withOpacity(.08)
                  )
              ),
              child: Text(
                getTaskStateText(item),
                style: context.small.copyWith(
                  fontSize: 16.sp,
                  color: item == selectedState
                      ? context.colorScheme.onPrimaryContainer
                      : context.colorScheme.onPrimary.withOpacity(.5),
                  fontWeight: item == selectedState
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
              ));
        })
      ],
    );
  }
}
