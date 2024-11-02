import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/constants.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/domain/model/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:todo_task/presentation/common/tasks_functions.dart';
import 'package:todo_task/presentation/res/routes_manager.dart';

import '../../../../res/translations_manager.dart';
import '../../bloc/home_bloc.dart';

class TaskCard extends StatelessWidget {
  final TaskDetails details;

  const TaskCard(this.details);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(left: 20.w, right: 10.w, top: 10.w, bottom: 10.w),
        height: 110.w,
        alignment: Alignment.center,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: "${Constants.baseUrl}images/${details.image}",
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          details.title,
                          style: context.small.copyWith(
                              fontSize: 22.sp,
                              height: 1,
                              color: context.colorScheme.onPrimary,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.r),
                            color: getTaskStateColor(details.status)
                                .withOpacity(.09)),
                        child: Text(
                          getTaskStateText(details.status),
                          style: context.small.copyWith(
                              fontSize: 14.sp,
                              height: 1,
                              color: getTaskStateColor(details.status),
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  5.verticalSpace,
                  Text(
                    details.description.split("\n").first,
                    softWrap: false,
                    style: context.small.copyWith(
                        fontSize: 17.sp,
                        height: 1,
                        color: context.colorScheme.onPrimary.withOpacity(.3),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flag_outlined,
                            size: 25.sp,
                            color: getTaskPriorityColor(details.priority),
                          ),
                          5.horizontalSpace,
                          Text(
                            getPriorityText(details.priority),
                            style: context.small.copyWith(
                                fontSize: 14.sp,
                                color: getTaskPriorityColor(details.priority),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Text(
                        DateFormat("yyyy-MM-dd", context.locale.languageCode)
                            .format(details.createdAt),
                        style: context.small.copyWith(
                            fontSize: 14.sp,
                            color:
                                context.colorScheme.onPrimary.withOpacity(.3),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                PopupMenuButton<String>(
                  onSelected: (String item) {
                    if(item == "1"){
                      // edit
                      Navigator.of(context).pushNamed(RoutesManager.addNewTask.route, arguments: {
                        'new-task': false,
                        "details": details
                      });
                    }else{
                      // 2 - delete
                      context.read<HomeBloc>().add(HomeDeleteTaskEvent(details));
                    }
                  },
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: "1",
                        child: Text(
                          Translation.edit.tr,
                          style: context.small.copyWith(
                              fontSize: 17.sp,
                              color: context.colorScheme.onPrimary,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: "2",
                        child: Text(
                          Translation.delete.tr,
                          style: context.small.copyWith(
                              fontSize: 17.sp,
                              color: context.colorScheme.onPrimary,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ];
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
