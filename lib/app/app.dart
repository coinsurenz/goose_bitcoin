import 'package:flutter/material.dart';
import 'package:goose_bitcoin/widgets/buy_bitcoin.dart';
import 'package:goose_bitcoin/widgets/confirmation_screen.dart';
import 'package:goose_bitcoin/widgets/splash_screen.dart';
import 'package:goose_bitcoin/widgets/success_screen.dart';
import 'package:goose_bitcoin/services/app_services.dart';
import 'package:goose_bitcoin/models/price_data.dart';
import 'dart:async';

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String bitcoinAmount = '';
  String message = '';
  final apiProvider = ApiService();
  String errorMessage = '';
  List<PricePoint> priceHistory = [];
  String currentPrice = "";
  bool isLoading = true;

// Simulated buy function- just delay for 2 seconds then return message
  void buyBitcoin() {
    setState(() {
      isLoading = true;
    });
    try {
      // presuming we were going to send a double to the imaginary api here
      final double parsedValueforApi = double.parse(bitcoinAmount);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          message = 'You successfully bought $bitcoinAmount Bitcoin';
          bitcoinAmount = '';
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        message = 'Failed to buy Bitcoin';
        bitcoinAmount = '';
        isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final historyData = await apiProvider.fetchPriceHistory();
      final price = await apiProvider.fetchPrice();
      setState(() {
        priceHistory = historyData;
        currentPrice = price;
        isLoading = false;
      });
      // if (test) {
      //         setState(() {
      //   priceHistory = historyData;
      //   currentPrice = price;
      //   isLoading = false;
      //   errorMessage = "";
      // });
      // } else {
      //       setState(() {
      //   errorMessage = "Failed to fetch price data";
      //   isLoading = false;
      // });
      // }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to fetch price data";
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    void getData() async {
      super.initState();
      await fetchData();
    }
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: NoTransitionPageTransitionsBuilder(),
          TargetPlatform.iOS: NoTransitionPageTransitionsBuilder(),
        }),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF607D8B),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Bitcoin Demo App For Swan'),
          backgroundColor: const Color(0xFF263238),
        ),
        body: Navigator(
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return CustomPageRoute(
                  builder: (context) {
                    if (isLoading) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [CircularProgressIndicator()],
                      );
                    } else {
                      return SplashScreen(
                        onBuyPressed: () {
                          Navigator.of(context).pushNamed('/buy');
                        },
                        errorMessage: errorMessage,
                        fetchAndRefresh: () async {
                          final completer = Completer<void>();
                          fetchData().then((_) {
                            completer.complete();
                          });

                          completer.future.then((_) {
                            Navigator.of(context).pushNamed('/');
                          });
                        },
                        priceHistory: priceHistory,
                        currentPrice: currentPrice,
                      );
                    }
                  },
                );
              case '/buy':
                return CustomPageRoute(
                  builder: (context) {
                    return BitcoinBuyForm(
                      bitcoinAmount: bitcoinAmount,
                      onAmountChanged: (amount) {
                        setState(() {
                          bitcoinAmount = amount;
                        });
                      },
                      onBuyPressed: () {
                        if (double.tryParse(bitcoinAmount) != null) {
                          Navigator.of(context).pushNamed('/confirm');
                        } else {
                          setState(() {
                            bitcoinAmount = '';
                          });
                        }
                      },
                    );
                  },
                );
              case '/confirm':
                return MaterialPageRoute(
                  builder: (context) {
                    return ConfirmationScreen(
                      bitcoinAmount: bitcoinAmount,
                      onBack: () {
                        Navigator.of(context).pushNamed('/buy');
                        setState(() {
                          bitcoinAmount = '';
                        });
                      },
                      onBuyPressed: () {
                        buyBitcoin();
                        Navigator.of(context).pushNamed('/success');
                      },
                    );
                  },
                );
              case '/success':
                return MaterialPageRoute(
                  builder: (context) {
                    if (isLoading) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [CircularProgressIndicator()],
                      );
                    } else {
                      return SuccessScreen(
                        message: message,
                        onClick: () async {
                          setState(() {
                            message = '';
                            bitcoinAmount = '';
                          });
                          final completer = Completer<void>();
                          fetchData().then((_) {
                            completer.complete();
                          });
                            completer.future.then((_) {
                            Navigator.of(context).pushNamed('/');
                          });
                        },
                      );
                    }
                  },
                );
              default:
                return null;
            }
          },
        ),
      ),
    );
  }
}

// I don't like the stock transition for MaterialPageRoute on this app so I'm overriding it with this and CustomPageRoute
class NoTransitionPageTransitionsBuilder extends PageTransitionsBuilder {
  final Duration transitionDuration;

  NoTransitionPageTransitionsBuilder(
      {this.transitionDuration = const Duration(milliseconds: 500)});// TODO check

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.linear),
      ),
      child: child,
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}

// Provide snappier transition for MaterialPageRoute where needed
class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
