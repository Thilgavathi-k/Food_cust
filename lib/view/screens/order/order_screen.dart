import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/order/widget/order_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin {
  TabController _tabController;
  bool _isLoggedIn;


  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
      _tabController.addListener(_handleTabSelection);
      Get.find<OrderController>().getRunningOrders(1, notify: false);
      Get.find<OrderController>().getRunningSubscriptionOrders(1, notify: false);
      Get.find<OrderController>().getHistoryOrders(1, notify: false);
      // Get.find<OrderController>().getSubscriptions(1, notify: false);
    }
  }
  void _handleTabSelection() {
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'my_orders'.tr, isBackButtonExist: ResponsiveHelper.isDesktop(context)),
      body: _isLoggedIn ? GetBuilder<OrderController>(
        builder: (orderController) {
          return Column(children: [


            // Center(
            //   child: Container(
            //     width: Dimensions.WEB_MAX_WIDTH,
            //     color: Theme.of(context).cardColor,
            //     child: TabBar(
            //       controller: _tabController,
            //       indicatorColor: Theme.of(context).primaryColor,
            //       indicatorWeight: 3,
            //       labelColor: Theme.of(context).primaryColor,
            //       unselectedLabelColor: Theme.of(context).disabledColor,
            //       unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
            //       labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
            //       tabs: [
            //         Tab(
            //             child:Row(
            //           // mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Image.asset("assets/newimages/Artboard – 12.png",width: 20,height: 20,),
            //             Text('running'.tr)
            //
            //           ],
            //         )
            //         ),
            //         Tab(text: 'subscription'.tr,icon: Image.asset("assets/newimages/Artboard – 12.png",width: 20,height: 20,)),
            //         Tab(text: 'history'.tr,icon: Image.asset("assets/newimages/Artboard – 12.png",width: 20,height: 20,)),
            //       ],
            //     ),
            //   ),
            // ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  child: ColorfulTabBar(
                    indicatorHeight: 0,
                    unselectedLabelColor: Colors.black,
                    selectedHeight: 40,
                    unselectedHeight: 40,
                    tabShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tabs: [
                      TabItem(
                          title: Row(children: [
                            Image.asset("assets/newimages/Running.png",width: 20,height: 20,  color: _tabController.index == 0
          ? Colors.white
              : Colors.black),
                            SizedBox(width: 5),
                            Text('running'.tr)
                          ]),
                          unselectedColor: Color(0xffF6F6F6),
                          color: Color(0xfffb8d07)),
                      TabItem(
                          title: Row(children: [
                            Image.asset("assets/newimages/Subscribtion.png",width: 20,height: 20,color: _tabController.index == 1
          ? Colors.white
              : Colors.black),
                            SizedBox(width: 5),
                            Text('subscription'.tr)
                          ]),
                          unselectedColor: Color(0xffF6F6F6),
                          color: Color(0xfffb8d07)),
                      TabItem(


                          title: Row(children: [

                            Image.asset("assets/newimages/History.png",width: 20,height: 20,color: _tabController.index == 2
          ? Colors.white
              : Colors.black),
                            SizedBox(width: 5),
                            Text('history'.tr)
                          ]),

                          unselectedColor: Color(0xffF6F6F6),
                          color: Color(0xfffb8d07)),

                    ],
                    controller: _tabController,
                  ),
                ),
              ),
            ),

            Expanded(child: TabBarView(
              controller: _tabController,
              children: [
                OrderView(isRunning: true),
                OrderView(isRunning: false, isSubscription: true),
                OrderView(isRunning: false),
              ],
            )),

          ]);
        },
      ) : NotLoggedInScreen(),
    );
  }
}
