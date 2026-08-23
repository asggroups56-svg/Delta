import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/onboarding/presentation/view/widget/work_flow_step_widget.dart';

class AutomationIllustrationWidget extends StatelessWidget {
  const AutomationIllustrationWidget({super.key, required this.color});
final Color color;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Flow card container
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Container(
            width: 270.w,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.12),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                )
              ],
              border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WorkFlowStepWidget(
                  icon: Icons.add_shopping_cart_rounded,
                  titleKey: 'newPurchaseOrder',
                  statusKey: 'receivedAutomatically',
                  stepColor: const Color(0xFF0B409C),
                  isCompleted: true,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 2.w,
                      height: 24.h,
                      color: Colors.green,
                    ),
                  ),
                ),
                WorkFlowStepWidget(
                  icon: Icons.receipt_long_rounded,
                  titleKey: 'issueInvoiceUpdateStock',
                  statusKey: 'realtimeProcessing',
                  stepColor: Colors.orange,
                  isCompleted: true,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 2.w,
                      height: 24.h,
                      color: Colors.green,
                    ),
                  ),
                ),
                WorkFlowStepWidget(
                  icon: Icons.mark_email_read_rounded,
                  titleKey: 'sendReportToCustomer',
                  statusKey: 'sentSuccessfully',
                  stepColor: Colors.green,
                  isCompleted: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}