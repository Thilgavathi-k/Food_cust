import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../helper/route_helper.dart';
import '../../../../util/images.dart';
import '../../../base/confirmation_dialog.dart';

class SubscriptionView extends StatefulWidget {
  final OrderController orderController;
  const SubscriptionView({@required this.orderController});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  @override
  var myFormat = DateFormat('yyyy-MM-d');
  DateTime currentDate = DateTime.now();
  DateTime startcurrentDate = DateTime.now();
  DateTime endcurrentDate = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Widget build(BuildContext context) {
    List<String> _weekDays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


      Text('subscription_date'.tr, style: robotoMedium),



      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      CustomDatePicker(
        hint: 'choose_subscription_date'.tr,
        range: widget.orderController.subscriptionRange,
        onDatePicked: (DateTimeRange range) => widget.orderController.setSubscriptionRange(range),
      ),



      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('subscription_type'.tr, style: robotoMedium),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: [ BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.5)],
          ),
          child: DropdownButton<String>(
            value: widget.orderController.subscriptionType,
            underline: SizedBox(),
            items: <String>['daily', 'weekly', 'monthly','sunday'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.tr),
              );
            }).toList(),
            onChanged: (value) => widget.orderController.setSubscriptionType(value),
          ),
        ),
      ]),
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

      // orderController.subscriptionType != 'daily' ? Text('days'.tr, style: robotoMedium) : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //   Text('subscription_schedule'.tr, style: robotoMedium),
      //   InkWell(
      //     onTap: () async {
      //       TimeOfDay _time = await showTimePicker(context: context, initialTime: TimeOfDay.now(),);
      //       if(_time != null) {
      //         orderController.addDay(0, _time);
      //       }
      //     },
      //     child: Container(
      //       height: 50,
      //       padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
      //       alignment: Alignment.center,
      //       decoration: BoxDecoration(
      //         color: Theme.of(context).cardColor,
      //         borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
      //         boxShadow: [ BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.5)],
      //       ),
      //       child: Text(
      //         orderController.selectedDays[0] != null ? DateConverter.dateToTimeOnly(orderController.selectedDays[0]) : 'choose_time'.tr,
      //         style: robotoRegular,
      //       ),
      //     ),
      //   ),
      // ]),
      SizedBox(height: widget.orderController.subscriptionType != 'daily' ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
      widget.orderController.subscriptionType != 'daily' ? SizedBox(height: 50, child: ListView.builder(
        itemCount: widget.orderController.subscriptionType == 'weekly' ? 7
            : widget.orderController.subscriptionType == 'monthly' ? 31 : 0,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          bool _isSelected = widget.orderController.selectedDays[index] != null;

          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: InkWell(
              onTap: () async {
                if(widget.orderController.selectedDays[index] != null) {
                  widget.orderController.addDay(index, null);
                }else {
                  TimeOfDay _time = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 0, minute: 0));
                  if(_time != null) {
                    widget.orderController.addDay(index, _time);
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: _isSelected ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  border: _isSelected ? null : Border.all(color: Theme.of(context).disabledColor, width: 2),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    widget.orderController.subscriptionType == 'monthly' ? '${'day'.tr}: ${index + 1}'
                        : widget.orderController.subscriptionType == 'weekly' ? _weekDays[index].tr : '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(color: _isSelected ? Colors.white : Colors.black),
                  ),
                  SizedBox(height: _isSelected ? 2 : 0),
                  _isSelected ? Text(
                    DateConverter.dateToTimeOnly(widget.orderController.selectedDays[index]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(color: _isSelected ? Colors.white : Colors.black, fontSize: Dimensions.fontSizeExtraSmall),
                  ) : SizedBox(),
                ]),
              ),
            ),
          );
        },
      )) : SizedBox(),
    ]);
  }
}
