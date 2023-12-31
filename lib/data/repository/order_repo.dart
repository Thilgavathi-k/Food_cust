import 'dart:convert';

import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> getRunningOrderList(int offset) async {
    return await apiClient.getData('${AppConstants.RUNNING_ORDER_LIST_URI}?offset=$offset&limit=${100}');
  }

  Future<Response> getRunningSubscriptionOrderList(int offset) async {
    return await apiClient.getData('${AppConstants.RUNNING_SUBSCRIPTION_ORDER_LIST_URI}?offset=$offset&limit=${100}');
  }

  Future<Response> getHistoryOrderList(int offset) async {
    return await apiClient.getData('${AppConstants.HISTORY_ORDER_LIST_URI}?offset=$offset&limit=10');
  }

  Future<Response> getOrderDetails(String orderID) async {
    return await apiClient.getData('${AppConstants.ORDER_DETAILS_URI}$orderID');
  }

  Future<Response> cancelOrder(String orderID, String reason) async {
    return await apiClient.postData(AppConstants.ORDER_CANCEL_URI, {'_method': 'put', 'order_id': orderID, 'reason': reason});
  }

  Future<Response> trackOrder(String orderID) async {
    return await apiClient.getData('${AppConstants.TRACK_URI}$orderID');
  }

  Future<Response> placeOrder(PlaceOrderBody orderBody) async {
    return await apiClient.postData(AppConstants.PLACE_ORDER_URI, orderBody.toJson());
  }

  Future<Response> sendNotificationRequest(String orderId) async {
    return await apiClient.getData('${AppConstants.SEND_CHECKOUT_NOTIFICATION_URL}/$orderId');
  }

  Future<Response> getDeliveryManData(String orderID) async {
    return await apiClient.getData('${AppConstants.LAST_LOCATION_URI}$orderID');
  }

  Future<Response> switchToCOD(String orderID) async {
    return await apiClient.postData(AppConstants.COD_SWITCH_URL, {'_method': 'put', 'order_id': orderID});
  }

  Future<Response> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    return await apiClient.getData('${AppConstants.DISTANCE_MATRIX_URI}'
        '?origin_lat=${originLatLng.latitude}&origin_lng=${originLatLng.longitude}'
        '&destination_lat=${destinationLatLng.latitude}&destination_lng=${destinationLatLng.longitude}');
  }

  Future<Response> getRefundReasons() async {
    return await apiClient.getData('${AppConstants.REFUND_REASONS_URI}');
  }

  Future<Response> getCancelReasons() async {
    return await apiClient.getData('${AppConstants.ORDER_CANCELLATION_URI}?offset=1&limit=30&type=customer');
  }

  Future<Response> submitRefundRequest(Map<String, String> body, XFile data) async {
    return apiClient.postMultipartData(AppConstants.REFUND_REQUEST_URI, body,  [MultipartBody('image[]', data)]);
  }

  Future<Response> getExtraCharge(double distance) async {
    return await apiClient.getData(AppConstants.VEHICLE_CHARGE_URI + '?distance=$distance');
  }

  Future<Response> getFoodsWithFoodIds(List<int> ids) async {
    return await apiClient.postData(AppConstants.PRODUCT_LIST_WITH_IDS_URI, {'food_id': jsonEncode(ids)});
  }

  Future<Response> getSubscriptionList(int offset) async {
    return await apiClient.getData('${AppConstants.SUBSCRIPTION_LIST_URL}?offset=$offset&limit=10');
  }

  Future<Response> updateSubscriptionStatus(int subscriptionID, String startDate, String endDate, String status, String note, String reason) async {
    return await apiClient.postData(
      AppConstants.SUBSCRIPTION_LIST_URL + '/$subscriptionID',
      {'_method': 'put', 'status': status, 'note': note, 'cancellation_reason': reason, 'start_date': startDate, 'end_date': endDate},
    );
  }

  Future<Response> getSubscriptionDeliveryLog(int subscriptionID, int offset) async {
    print("GETLOGLIST");
    print(subscriptionID);
    print(offset);
    print("kdkfkdlfjkdjkf");
    return await apiClient.getData('${AppConstants.SUBSCRIPTION_LIST_URL}/$subscriptionID/delivery-log?offset=$offset&limit=10');
  }

  Future<Response> getSubscriptionPauseLog(int subscriptionID, int offset) async {
    return await apiClient.getData('${AppConstants.SUBSCRIPTION_LIST_URL}/$subscriptionID/pause-log?offset=$offset&limit=10');
  }
}