import 'package:flutter/material.dart';
import 'package:egtoy/common/entities/entities.dart';
import 'package:egtoy/common/utils/utils.dart';
import 'package:egtoy/common/values/values.dart';
import 'package:egtoy/common/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget agentListItem(AgentItem item) {
  return Container(
    height: 161.h,
    padding: EdgeInsets.all(20.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 右侧
        SizedBox(
          width: 260.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 作者
              Container(
                margin: EdgeInsets.all(0),
                child: Text(
                  "Agent Name: ${item.agentName}",
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.normal,
                    color: AppColors.thirdElementText,
                    fontSize: 14.sp,
                    height: 1,
                  ),
                ),
              ),
              // 标题
              InkWell(
                onTap: () {
                  // ExtendedNavigator.rootNavigator.pushNamed(
                  //   Routes.detailsPageRoute,
                  //   arguments: DetailsPageArguments(item: item),
                  // );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child: Text(
                    "TTS Model Name:${item.ttsModelName}",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryText,
                      fontSize: 16.sp,
                      height: 1,
                    ),
                    overflow: TextOverflow.clip,
                    maxLines: 3,
                  ),
                ),
              ),
              // Spacer
              Spacer(),
              // 一行 3 列
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // 分类
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 60.w),
                      child: Text(
                        "TTS voice Name:${item.ttsVoiceName}",
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.normal,
                          color: AppColors.secondaryElementText,
                          fontSize: 14.sp,
                          height: 1,
                        ),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                    ),
                    // 添加时间
                    Container(width: 15.w),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 100.w),
                      child: Text(
                        "LLM Model Name:${item.llmModelName}",
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.normal,
                          color: AppColors.thirdElementText,
                          fontSize: 14.sp,
                          height: 1,
                        ),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                    ),
                    // 更多
                    Spacer(),
                    InkWell(
                      child: Icon(
                        Icons.more_horiz,
                        color: AppColors.primaryText,
                        size: 24.sp,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
