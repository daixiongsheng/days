import 'package:flutter/material.dart';
import 'package:flutter_application_1/color_page.dart';
import 'package:flutter_application_1/extensions/color.dart';
import 'package:flutter_application_1/logger/logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lunar/lunar.dart';

import 'add_day.dart';
import 'db/db.dart';
import 'route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context)?.appTitle ?? '',
      initialRoute: Routes.home,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate, // 本地化代理
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        // "add": (context) => const ColorsPage(),
        // Routes.add: (context) => const AddDay(),
        Routes.home: (context) => const MyHomePage(), //注册首页路由
      },
      supportedLocales: const [
        Locale('en', ''), // 英文
        Locale('zh', ''), // 中文
      ],
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

  void forceUpdate() {
    setState(() {
      _counter++;
    });
  }

  void initDays() async {
    var data = await DB.getInstance().getAllDays();
    setState(() {
      days = data;
    });
  }

  @override
  void initState() {
    super.initState();
    logger.i('start load');
    ColorAsset.loadColors().then((value) {
      // Navigator.of(context).pushNamed("add");
      forceUpdate();
    });
    DB.getInstance().getAllDays().then((value) {
      setState(() {
        days = value;
      });
    });
  }

  static const Color hoverColor = Colors.grey;
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

  void _addDay([Day? changedDay]) async {
    Day? day = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AddDayPage(changedDay);
        },
        fullscreenDialog: true,
      ),
    );
    if (day == null) {
      return;
    }
    DB.getInstance().insertOrUpdateDay(day);
    var index = days.indexOf(day);

    if (index != -1) {
      days[index].updateWith(day);
    } else {
      days.add(day);
    }
    forceUpdate();
  }

  static const TextStyle titleStyle =
      TextStyle(color: Colors.white, fontSize: 14);

  static TextStyle subTitleStyle =
      TextStyle(color: parseColor('#ADABABFF'), fontSize: 10);

  String get appBarTitle {
    final String formatted =
        DateFormat(AppLocalizations.of(context)!.appTitleFormat)
            .format(DateTime.now());
    return formatted;
  }

  get isZh {
    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;
    return languageCode == 'zh';
  }

  get appBarTitleWidget {
    if (!isZh) {
      return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            appBarTitle,
            style: titleStyle,
          ));
    }
    Lunar date = Lunar.fromDate(DateTime.now());
    final String subTitle =
        '${date.getYearInGanZhi()}${date.getYearShengXiao()}年  ${date.getMonthInChinese()}月${date.getDayInChinese()}';

    return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appBarTitle,
              style: titleStyle,
            ),
            Text(
              subTitle,
              style: subTitleStyle,
            ),
          ],
        ));
  }

  get appBar {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: appBarTitleWidget,
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

  List<Day> days = [];

  Iterable<Widget> get daysWidget {
    return days.map((e) => renderDay(e));
  }

  Widget renderDay(Day day) {
    String title = day.title;
    DateTime startDate = day.startDate;
    var dateFormat = DateFormat('MM dd,yyyy');
    var now = DateTime.now();
    // 计算今年已经过去了多少天
    var pastDays = now.difference(startDate).inDays;
    return Container(
      padding: const EdgeInsets.only(bottom: 14, right: 16, left: 16),
      child: Material(
        color: day.color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            logger.i("tap");
            _addDay(day);
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('提示'),
                  content: const Text('你已经长按我了！'),
                  actions: <Widget>[
                    FloatingActionButton(
                      // child: Text('确定'),
                      child: const Icon(Icons.delete),
                      onPressed: () {
                        days.remove(day);
                        DB.getInstance().deleteDay(day);
                        Navigator.of(context).pop();
                        forceUpdate();
                      },
                    ),
                  ],
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: parseColor('#caca4e'),
          child: Container(
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
                        fontSize: 12, color: Color.fromARGB(255, 64, 17, 17)),
                  )
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(TextSpan(
                      style: const TextStyle(
                          color: Color.fromARGB(255, 211, 205, 205),
                          fontSize: 12),
                      children: [
                        const TextSpan(text: "已经过去"),
                        TextSpan(
                            text: "$pastDays",
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white)),
                        const TextSpan(text: "Days"),
                      ]))
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: const CustomDrawer(),
      body: EasyRefresh.custom(
        header: CustomHeader(), // 可以替换为你自定义的刷新头部
        onRefresh: () async {
          // 刷新请求
          initDays();
        },
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const HomeTopHeader(),
                ...daysWidget,
              ],
            );
          }, childCount: 1)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDay,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

abstract class HomeStatelessWidget extends StatelessWidget {
  const HomeStatelessWidget({super.key});

  String get currentYear {
    return DateFormat('yyyy').format(DateTime.now());
  }

  bool get isLeapYear {
    final year = int.parse(currentYear);
    final isLeapYear = (0 == year % 4 && year % 100 != 0) || (0 == year % 400);
    return isLeapYear;
  }

  int get currentYearTotalDays {
    return isLeapYear ? 366 : 365;
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
}

class HomeTopHeader extends HomeStatelessWidget {
  const HomeTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36, top: 40),
      child: Column(
        children: [
          (Text(
            '$currentYear 已经   过去 $passProcess%',
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
}

class CustomDrawer extends HomeStatelessWidget {
  const CustomDrawer({super.key});

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

  @override
  Widget build(BuildContext context) {
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
}

class CustomHeader extends Header {
  @override
  double get extent => 0.0;

  @override
  double get overExtent => 40.0;

  @override
  double get triggerDistance => 40.0;

  @override
  Widget contentBuilder(
      context,
      refreshState,
      pulledExtent,
      refreshTriggerPullDistance,
      refreshIndicatorExtent,
      axisDirection,
      float,
      completeDuration,
      enableInfiniteRefresh,
      success,
      noMore) {
    // 根据不同的刷新状态展示不同的内容

    return const Image(
        image: AssetImage('assets/images/a.png'), fit: BoxFit.fitWidth);
  }
}
