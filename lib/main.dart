import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

void main() {
  runApp(const MyApp());
}

class NewRoute extends StatelessWidget {
  const NewRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New route"),
      ),
      body: const Center(
        child: Text("This is new route"),
      ),
    );
  }
}

class CupertinoTestRoute extends StatelessWidget {
  const CupertinoTestRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black12,
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Cupertino Demo"),
      ),
      child: Center(
        child: CupertinoButton(
            color: CupertinoColors.activeBlue,
            child: const Text("Press"),
            onPressed: () {}),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          String routeName = settings.name!;
          // 如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
          // 引导用户登录；其他情况则正常打开路由。
          print('routeName$routeName');
          return NewRoute();
        });
      },
      routes: {
        "home": (context) => const DefaultTabController(
              length: 3,
              child: Scaffold(),
            ),
        "new_page": (context) => NewRoute(),
        "tip": (context) => TipRoute(
              text: ModalRoute.of(context)!.settings.arguments as String,
            ),
        "/": (context) => const MyHomePage(), //注册首页路由
      },
      theme: ThemeData(
        colorScheme:
            const ColorScheme.dark(primary: Color.fromARGB(229, 25, 24, 24)),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class TipRoute extends StatelessWidget {
  const TipRoute({
    super.key,
    required this.text, // 接收一个text参数
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("提示"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, "我是返回值"),
                child: const Text("返回"),
              ),
              Image.asset('assets/images/logo.png'),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDrawerHeader extends DrawerHeader {
  const CustomDrawerHeader({
    super.key,
    super.decoration,
    required super.child,
  });

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    final double statusBarHeight = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: statusBarHeight + 160.0 + 1.0,
      child: AnimatedContainer(
        padding: padding.add(EdgeInsets.only(top: statusBarHeight)),
        decoration: decoration,
        duration: duration,
        curve: curve,
        child: child == null
            ? null
            : DefaultTextStyle(
                style: theme.textTheme.bodyLarge!,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: child!,
                ),
              ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static const Color hoverColor = Colors.grey;
  static const Color drawerBackgroundColor = Color(0xFF222222);
  static const TextStyle textStyle = TextStyle(color: Colors.white);

  List<Widget> get titles => [
        ListTile(
          textColor: textStyle.color,
          title: const Text(
            "Home22",
          ),
          hoverColor: hoverColor,
          onTap: () {
            print("Home tap");
          },
          selectedTileColor: Colors.black,
        ),
        ListTile(
          textColor: textStyle.color,
          title: const Text("Home"),
          hoverColor: hoverColor,
          onTap: () {
            print("Home tap");
          },
          selected: false,
        ),
        ListTile(
          textColor: textStyle.color,
          title: const Text("Home"),
          hoverColor: hoverColor,
          onTap: () {
            print("Home tap");
          },
          selected: false,
        ),
        ListTile(
          textColor: textStyle.color,
          hoverColor: hoverColor,
          title: const Text("Home"),
          onTap: () {
            print("Home tap");
          },
          selected: false,
        ),
      ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    loadAsset().then((value) {
      print('loadAsset$value');
    });
    //导航到新路由
    // Navigator.of(context)
    //     .push(
    //   MaterialPageRoute(
    //       builder: (context) {
    //         // return NewRoute();
    //         print('object');
    //         return const TipRoute(
    //           // 路由参数
    //           text: "我是提示xxxx",
    //         );
    //       },
    //       // fullscreenDialog: true,
    //       maintainState: false),
    // )
    //     .then((value) {
    //   print("我是返回: $value");
    // });

    Navigator.of(context).pushNamed("tip", arguments: "hello");
  }

  static const TextStyle titleStyle =
      TextStyle(color: Colors.white, fontSize: 14);

  String get appBarTitle {
    final String formatted = DateFormat('MM dd,yyyy').format(DateTime.now());
    return formatted;
  }

  get appBar {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            appBarTitle,
            style: titleStyle,
          )),
      actions: <Widget>[
        IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: () {
              // handle the press
            }),
        IconButton(
            icon: const Icon(Icons.more_vert),
            iconSize: 20,
            color: Colors.grey,
            onPressed: () {
              // handle the press
            }),
      ],
    );
  }

  ListView get listView => ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const CustomDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/a.png'), fit: BoxFit.fill),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "账号信息",
                    style: textStyle,
                  )
                ],
              )),
          ...titles,
        ],
      );

  Drawer get drawer {
    return Drawer(
      backgroundColor: drawerBackgroundColor,
      width: MediaQuery.of(context).size.width * 0.8,
      // clipBehavior: Clip.none,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      child: listView,
    );
  }

  String get currentYear {
    return DateFormat('yyyy').format(DateTime.now());
  }

  int get passDays {
    var now = DateTime.now();
    var firstDayOfThisYear = DateTime(now.year, 1, 1);
    // 计算今年已经过去了多少天
    var pastDays = now.difference(firstDayOfThisYear).inDays;
    return pastDays + 1;
  }

  String get passProcess {
    return passProcessNumber.toString();
  }

  int get passProcessNumber {
    return (passDays * 100 ~/ currentYearTotalDays);
  }

  bool get isLeapYear {
    final year = int.parse(currentYear);
    final isLeapYear = (0 == year % 4 && year % 100 != 0) || (0 == year % 400);
    return isLeapYear;
  }

  int get currentYearTotalDays {
    return isLeapYear ? 366 : 365;
  }

  Widget get passTime {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36, top: 40),
      child: Column(
        children: [
          (Text(
            '$currentYear 已经过去 $passProcess%',
            style: const TextStyle(fontSize: 18),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 12),
            child: LinearProgressIndicator(
              value: passProcessNumber / 100,
              minHeight: 10,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              backgroundColor: Theme.of(context).colorScheme.primary,
              valueColor: const AlwaysStoppedAnimation(Colors.amber),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(top: 5, right: 30),
                  child: Text(
                    '$passDays / $currentYearTotalDays',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  )))
        ],
      ),
    );
  }

  Iterable<Widget> get days {
    return [
      {"title": "脉脉", "startDate": DateTime.parse("2021-10-13")},
      {"title": "脉脉", "startDate": DateTime.parse("2020-10-28")},
      {"title": "脉脉", "startDate": DateTime.parse("2021-10-13")},
    ].map((e) => renderDay(e));
  }

  Widget renderDay(day) {
    String title = day["title"];
    DateTime startDate = day["startDate"];
    var dateFormat = DateFormat('MM dd,yyyy');
    var now = DateTime.now();
    // 计算今年已经过去了多少天
    var pastDays = now.difference(startDate).inDays;
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(12), // 圆角半径
      ),
      margin: const EdgeInsets.only(bottom: 14, right: 16, left: 16),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      height: 90,
      child: Row(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Text(
              dateFormat.format(startDate),
              style: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(255, 211, 205, 205)),
            )
          ],
        ),
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(TextSpan(
                style: const TextStyle(
                    color: Color.fromARGB(255, 211, 205, 205), fontSize: 12),
                children: [
                  const TextSpan(text: "已经过去"),
                  TextSpan(
                      text: "$pastDays",
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white)),
                  const TextSpan(text: "Days"),
                ]))
          ],
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            passTime,
            ...days,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
