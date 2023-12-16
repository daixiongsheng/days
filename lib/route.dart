import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

// Widget build(BuildContext context) {
//   return MaterialApp(
//     title: 'Flutter Demo',
//     initialRoute: '/',
//     debugShowCheckedModeBanner: false,
//     localizationsDelegates: const [
//       AppLocalizations.delegate, // 本地化代理
//       GlobalMaterialLocalizations.delegate,
//       GlobalWidgetsLocalizations.delegate,
//       GlobalCupertinoLocalizations.delegate,
//     ],
//     supportedLocales: const [
//       Locale('en', ''), // 英文
//       Locale('zh', ''), // 中文
//     ],
//     onGenerateRoute: (RouteSettings settings) {
//       return MaterialPageRoute(builder: (context) {
//         String routeName = settings.name!;
//         // 如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
//         // 引导用户登录；其他情况则正常打开路由。
//         print('routeName$routeName');
//         return const NewRoute();
//       });
//     },
//     routes: {
//       "home": (context) => const DefaultTabController(
//         length: 3,
//         child: Scaffold(),
//       ),
//       "new_page": (context) => const NewRoute(),
//       "tip": (context) => TipRoute(
//         text: ModalRoute.of(context)!.settings.arguments as String,
//       ),
//       "/": (context) => const MyHomePage(), //注册首页路由
//     },
//     theme: ThemeData(
//       colorScheme:
//       const ColorScheme.dark(primary: Color.fromARGB(229, 25, 24, 24)),
//       useMaterial3: true,
//     ),
//   );
// }
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
