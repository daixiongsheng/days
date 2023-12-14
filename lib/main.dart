import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

void main() {
  runApp(const MyApp());
}

class NewRoute extends StatelessWidget {
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
        "/": (context) =>
            const MyHomePage(title: 'Flutter Demo Home Page'), //注册首页路由
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

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

  List<Widget> titles = [
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

  late AppBar appBar = AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text(
      widget.title,
      style: textStyle,
      textAlign: TextAlign.end,
    ),
  );

  late ListView listView = ListView(
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

  late Drawer drawer = Drawer(
    backgroundColor: drawerBackgroundColor,
    width: MediaQuery.of(context).size.width * 0.8,
    // clipBehavior: Clip.none,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.zero),
    ),
    child: listView,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            const DefaultTextStyle(
              style: TextStyle(
                color: Colors.amber,
                fontSize: 20,
              ),
              textAlign: TextAlign.left,
              child: Text.rich(TextSpan(
                  children: [
                    TextSpan(
                        text: "span1", style: TextStyle(color: Colors.black))
                  ],
                  text: AutofillHints.addressCity,
                  style: TextStyle(color: Colors.red))),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
