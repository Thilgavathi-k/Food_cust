import 'dart:async';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/cart_widget.dart';
import 'package:efood_multivendor/view/screens/cart/cart_screen.dart';
import 'package:efood_multivendor/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:efood_multivendor/view/screens/dashboard/widget/running_order_view_widget.dart';
import 'package:efood_multivendor/view/screens/favourite/favourite_screen.dart';
import 'package:efood_multivendor/view/screens/home/home_screen.dart';
import 'package:efood_multivendor/view/screens/menu/menu_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_screen.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;
  bool _isLogin;

  @override
  void initState() {
    super.initState();

    _isLogin = Get.find<AuthController>().isLoggedIn();

    if(_isLogin){
      Get.find<OrderController>().getRunningOrders(1, notify: false);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      HomeScreen(),
      FavouriteScreen(),
      CartScreen(fromNav: true),
      OrderScreen(),
      Container(),
    ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if(_canExit) {
            return true;
          }else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr, style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            ));
            _canExit = true;
            Timer(Duration(seconds: 2), () {
              _canExit = false;
            });
            return false;
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,

        floatingActionButton: GetBuilder<OrderController>(builder: (orderController) {
          return ResponsiveHelper.isDesktop(context) ? SizedBox() :
          (orderController.showBottomSheet && orderController.runningOrderList != null && orderController.runningOrderList.isNotEmpty)
              ? SizedBox.shrink() : Padding(
                padding: const EdgeInsets.only(left: 10),
                child: FloatingActionButton(

            elevation: 5,
            backgroundColor: _pageIndex == 2 ? Theme.of(context).primaryColor : Color(0xffffdbbf),
            onPressed: () => _setPage(2),
            child: CartWidget(color: _pageIndex == 2 ? Theme.of(context).cardColor : Color(0xff483838), size: 30),
          ),
              );
        }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: ResponsiveHelper.isDesktop(context) ? SizedBox() : GetBuilder<OrderController>(builder: (orderController) {

          return (orderController.showBottomSheet && (orderController.runningOrderList != null && orderController.runningOrderList.length > 0))
              ? SizedBox() : Container(

            margin: EdgeInsets.only(left: 5, right: 5),
                child:ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30),
                  ),
                  child: BottomAppBar(
                    padding: EdgeInsets.symmetric(vertical: 5),
            elevation: 5,
            notchMargin: 5,
            clipBehavior: Clip.antiAlias,
            shape: CircularNotchedRectangle(),
                  color: Color(0xffffdbbf),


            child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(children: [
    BottomNavItem(iconimage: "assets/newimages/Artboard – 12.png", isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
    BottomNavItem(iconimage: "assets/newimages/Artboard – 14.png", isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
    Expanded(child: SizedBox()),
    BottomNavItem(iconimage:"assets/newimages/Artboard – 15.png", isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
    BottomNavItem(iconimage:"assets/newimages/Artboard – 16.png", isSelected: _pageIndex == 4, onTap: () {
    Get.bottomSheet(MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);

                    }),
                  ]),
            ),
          ),
                ),
              );
        }
        ),
        body: GetBuilder<OrderController>(
            builder: (orderController) {
              List<OrderModel> _runningOrder = orderController.runningOrderList != null ? orderController.runningOrderList : [];

              List<OrderModel> _reversOrder =  List.from(_runningOrder.reversed);
              return ExpandableBottomSheet(
                background: PageView.builder(
                  controller: _pageController,
                  itemCount: _screens.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _screens[index];
                  },
                ),
                persistentContentHeight: 100,

                onIsContractedCallback: () {
                  if(!orderController.showOneOrder) {
                    orderController.showOrders();
                  }
                },
                onIsExtendedCallback: () {
                  if(orderController.showOneOrder) {
                    orderController.showOrders();
                  }
                },

                enableToggle: true,

                expandableContent: (ResponsiveHelper.isDesktop(context) || !_isLogin || orderController.runningOrderList == null
                    || orderController.runningOrderList.isEmpty || !orderController.showBottomSheet) ? null
                    : Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    if(orderController.showBottomSheet){
                      orderController.showRunningOrders();
                    }
                  },
                  child: RunningOrderViewWidget(reversOrder: _reversOrder),
                ),

              );
            }
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
