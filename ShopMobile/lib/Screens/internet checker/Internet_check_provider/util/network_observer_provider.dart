import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/constant.dart';
import '../controller/network_provider_controller.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class ProviderNetworkObserver extends StatefulWidget {
  final Widget child;

  const ProviderNetworkObserver({Key? key, required this.child}) : super(key: key);

  @override
  _ProviderNetworkObserverState createState() => _ProviderNetworkObserverState();
}

class _ProviderNetworkObserverState extends State<ProviderNetworkObserver> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final networkObserver = ref.watch(networkProviderController);
        // If the status is offline, show the custom offline screen
        if (networkObserver.status == ConnectivityStatus.offline) {
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
                      //'No Wi-Fi Connection',
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
                      onPressed: () {},
                      child:  Text(
                        lang.S.of(context).retry,
                        //'Retry',
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          // If the status is online, return the original child widget
          return widget.child;
        }
      },
    );
  }
}
