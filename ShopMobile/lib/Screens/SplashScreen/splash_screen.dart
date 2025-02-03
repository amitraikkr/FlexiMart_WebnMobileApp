// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/model/business_info_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Repository/API/business_info_repo.dart';
import '../../currency.dart';
import '../Authentication/Repo/licnese_repo.dart';
import '../Home/home.dart';
import '../internet checker/Internet_check_provider/util/network_observer_provider.dart';
import '../language/language_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isUpdateAvailable = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void getPermission() async {
    // ignore: unused_local_variable
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  checkUser() async {
    // bool result = await InternetConnectionChecker().hasConnection;
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.first == ConnectivityResult.wifi || connectivityResult.first == ConnectivityResult.mobile) {
      await PurchaseModel().isActiveBuyer().then((value) {
        if (!value) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
             // title:  Text("Not Active User"),
              title:  Text(lang.S.of(context).notActiveUser),
             // content: const Text("Please use the valid purchase code to use the app."),
              content:  Text("${lang.S.of(context).pleaseUseTheValidPurchaseCodeToUseTheApp}."),
              actions: [
                TextButton(
                  onPressed: () {
                    //Exit app
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else {
                      exit(0);
                    }
                  },
                  child:  Text(lang.S.of(context).oK),
                ),
              ],
            ),
          );
        } else {
          nextPage();
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: Center(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // Add slight transparency
                  borderRadius: BorderRadius.circular(24.0), // Increase border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                      child: const Icon(
                        Icons.wifi_off,
                        key: ValueKey<int>(1), // For animation
                        size: 70.0,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                     Text(
                       lang.S.of(context).noWiFiConnection,
                     // 'No Wi-Fi Connection',
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                     Text(
                       lang.S.of(context).pleaseCheckYourInternetConnectionAndTryAgain,
                     // 'Please check your internet connection and try again.',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(kMainColor)),
                      onPressed: () {
                        checkUser();
                      },
                      child:  Text(
                        lang.S.of(context).retry,
                       // 'Retry',
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // init();
    getPermission();
    getCurrency();
    setLanguage();

    checkUser();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency') ?? '৳';
    currencyName = prefs.getString('currencyName') ?? 'Bangladeshi Taka';
  }

  void setLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String selectedLanguage = prefs.getString('lang') ?? 'English';
    context.read<LanguageChangeProvider>().changeLocale(languageMap[selectedLanguage]!);
  }

  Future<void> nextPage() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 1));
    if (prefs.getString('token') != null) {
      BusinessInformation? data;
      data = await BusinessRepository().checkBusinessData();
      if (data == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoard()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ProviderNetworkObserver(
        child: Scaffold(
          backgroundColor: kMainColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                height: 230,
                width: 230,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(splashLogo))),
              ),
              const Spacer(),
              Column(
                children: [
                  Center(
                    child: Text(
                     // 'Powered By $companyName',
                      '${lang.S.of(context).poweredBy} $companyName',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 20.0),
                    ),
                  ),
                  Center(
                    child: Text(
                      'V $appVersion',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
