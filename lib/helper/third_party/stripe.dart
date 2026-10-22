// ignore_for_file: avoid_print, use_build_context_synchronously, implementation_imports

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/settings/constants.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/src/platforms/stripe_checkout.dart';

enum PaymentOption { montly, annually }

class StripePaymentHandle {
  final BuildContext context;
  Map<String, dynamic>? paymentIntent;

  StripePaymentHandle({required this.context});

  static String choosePrice(PaymentOption option) {
    String choice = '';
    switch (option) {
      case PaymentOption.annually:
        choice = '29.99';
        break;
      case PaymentOption.montly:
        choice = '4.99';
        break;
    }
    return choice;
  }

  Future<bool> createFreeSubscription() async {
    try {
      print("Bearer ${HiveFunction.getUser().accessToken}");
      Dio dio = new Dio();
      Options options = Options(
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          'Content-Type': 'application/json'
        },
      );

      Response res = await dio.post(
        'https://dev.grocipe.app/api/v1/subscription/create_free_sbscription/',
        options: options,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        print("Create Free Subscription: ${res.data}");
        return true;
      } else {
        print("Failed to create subscription, status code: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      context.showErrorSnackBar("Failed: $e");
      print(e);
      return false;
    }
  }

  Future<dynamic> checkout(mounted,
      {required String product, required String couponId}) async {
    try {
      var freeUser = await http.post(
        Uri.parse(
          '${Constants.url}/subscription/create_free_sbscription/',
        ),
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          'Content-Type': 'application/json'
        },
      );
      var freeUserResponse = json.decode(freeUser.body);
      print(freeUserResponse);

      print("Price id $product");
      print("Coupon id $couponId");
      print("My Access token ${HiveFunction.getUser().accessToken}");
      var res = await http.post(
        Uri.parse(
          '${Constants.url}/subscription/create_subscription_session/?price_id=$product&coupon_id=$couponId',
        ),
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          "token": HiveFunction.getUser().accessToken,
          'Content-Type': 'application/json'
        },
      );
      var httpResponse = json.decode(res.body);
      print(httpResponse);
      print("------");
      String subscriptionId = httpResponse['clientSubID'];
      print("--------");

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                context.pop();
                var res = await http.post(
                  Uri.parse(
                    '${Constants.url}/subscription/session_completed/?subcription_id=$subscriptionId',
                  ),
                  headers: {
                    "Authorization":
                        "Bearer ${HiveFunction.getUser().accessToken}",
                    "Accept": "application/json",
                    "token": HiveFunction.getUser().accessToken,
                    'Content-Type': 'application/json'
                  },
                  body: json.encode(
                    {
                      "subscriptionId": subscriptionId,
                    },
                  ),
                );
                print(res.statusCode);
                print(json.decode(res.body).toString());
              },
              icon: Icon(
                Icons.chevron_left,
                color: context.colors.black,
              ),
            ),
          ),
          body: CheckoutPage(
            sessionId: httpResponse['clientSubID'],
            publishableKey:
                'pk_test_51PG64aRsPs6WvkcRemLBiqh4vbhEaoek5EAMAuSlNouAgjdAuP0vtaEDJkNoCOTRF5eCvv0rR5vMtMq1Ah95Mr5j00aCU9ivHW',
            // stripeAccountId: stripeAccountId,
            onCompleted: (response) {
              print("HELOO");
              print(response);
            },
            successUrl: 'https://www.grocipe.com',
            canceledUrl: 'https://checkout.stripe.dev/cancel',
          ),
        ),
      ));
    } catch (e) {
      context.showErrorSnackBar("Payment Failed: $e");
    }
  }

  Future<String> checkSubscriptionType() async {
    try {
      var res = await http.post(
        Uri.parse(
          '${Constants.url}/subscription/subscription_details/',
        ),
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          'Content-Type': 'application/json'
        },
      );
      var httpResponse = json.decode(res.body);
      print(httpResponse);

      String subscription_type = httpResponse['subscription_type'];
      return subscription_type;
    } catch (e) {
      context.showErrorSnackBar("Failed: $e");
      return "Free";
    }
  }

  Future<dynamic> upgradeSubScription(mounted,
      {required String product}) async {
    try {
      var res = await http.post(
        Uri.parse(
          '${Constants.url}/subscription/create_subscription_session/?price_id=$product',
        ),
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          "token": HiveFunction.getUser().accessToken,
          'Content-Type': 'application/json'
        },
      );
      var httpResponse = json.decode(res.body);
      print(httpResponse);
      print("------");
      String subscriptionId = httpResponse['clientSubID'];
      print("--------");

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                context.pop();
                var res = await http.post(
                  Uri.parse(
                    '${Constants.url}/subscription/session_completed/?subcription_id=$subscriptionId',
                  ),
                  headers: {
                    "Authorization":
                        "Bearer ${HiveFunction.getUser().accessToken}",
                    "Accept": "application/json",
                    "token": HiveFunction.getUser().accessToken,
                    'Content-Type': 'application/json'
                  },
                  body: json.encode(
                    {
                      "subscriptionId": subscriptionId,
                    },
                  ),
                );
                print(res.statusCode);
                print(json.decode(res.body).toString());
              },
              icon: Icon(
                Icons.chevron_left,
                color: context.colors.black,
              ),
            ),
          ),
          body: CheckoutPage(
            sessionId: httpResponse['clientSubID'],
            publishableKey:
                'pk_test_51PG64aRsPs6WvkcRemLBiqh4vbhEaoek5EAMAuSlNouAgjdAuP0vtaEDJkNoCOTRF5eCvv0rR5vMtMq1Ah95Mr5j00aCU9ivHW',
            // stripeAccountId: stripeAccountId,
            onCompleted: (response) {
              print("HELOO");
              print(response);
            },
            successUrl: 'https://www.grocipe.com',
            canceledUrl: 'https://checkout.stripe.dev/cancel',
          ),
        ),
      ));
    } catch (e) {
      context.showErrorSnackBar("Payment Failed: $e");
    }
  }

  Future<void> stripeMakePayment(PaymentOption option) async {
    try {
      print(
          '${Constants.url}/subscription/create_subscription_session/?price_id=price_1PG7ViRsPs6WvkcRnuXuDgmc');
      String price = choosePrice(option);
      var res = await http.post(
        Uri.parse(
          '${Constants.url}/subscription/create_subscription_session/?price_id=price_1PG7ViRsPs6WvkcRnuXuDgmc&return_url="https/example.com/',
        ),
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          "token": HiveFunction.getUser().accessToken,
          'Content-Type': 'application/json'
        },
      );
      var httpResponse = json.decode(res.body);
      print(httpResponse);
      print("------");
      String subscriptionId = httpResponse['clientSubID'];

      paymentIntent = await createPaymentIntent(price, 'usd');
      log(paymentIntent.toString());
      var user = HiveFunction.getUser();
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              // applePay: PaymentSheetApplePay(merchantCountryCode: merchantCountryCode),
              billingDetails: BillingDetails(
                name: user.lastName + user.firstName,
                email: user.email,
              ),
              customFlow: false,

              // Customer keys
              // customerEphemeralKeySecret: paymentIntent!['ephemeralKey'],
              // customerId: paymentIntent!['id'],
              paymentIntentClientSecret:
                  httpResponse!['clientSubID'], //Gotten from payment intent
              // style: context.,
              merchantDisplayName: 'Ikay',
            ),
          )
          .then((value) {});
      //STEP 3: Display Payment sheet
      displayPaymentSheet(subscriptionId);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> displayPaymentSheet(String subscriptionId) async {
    try {
      // Display the payment sheet
      await Stripe.instance.presentPaymentSheet();
      Fluttertoast.showToast(
        msg: 'Payment successfully completed',
      );

      // Send subscription ID to backend after successful payment
      print(
        '${Constants.url}/subscription/session_completed/?subcription_id=$subscriptionId',
      );
      var res = await http.post(
        Uri.parse(
          '${Constants.url}/subscription/session_completed/?subcription_id=$subscriptionId',
        ),
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          "token": HiveFunction.getUser().accessToken,
          'Content-Type': 'application/json'
        },
        body: json.encode(
          {
            "subscriptionId": subscriptionId,
          },
        ),
      );
      print(res.statusCode);
      print(json.decode(res.body));
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(
          msg: 'Error from Stripe: ${e.error.localizedMessage}',
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Unforeseen error: $e',
        );
      }
    }
  }

//create Payment
  createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['SRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      print(json.decode(
        response.body,
      ));
      return json.decode(
        response.body,
      );
    } catch (err) {
      throw Exception(err.toString());
    }
  }

//calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
