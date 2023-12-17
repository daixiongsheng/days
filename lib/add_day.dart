import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'color_page.dart';
import 'db/day.dart';
import 'extensions/color.dart';
import 'logger/logger.dart';

class AddDayPage extends StatefulWidget {
  Day? day;

  AddDayPage(this.day, {super.key});

  @override
  State<AddDayPage> createState() => AddDayPageState();
}

class AddDayPageState extends State<AddDayPage> {
  static const Color hoverColor = Colors.grey;
  static const Color drawerBackgroundColor = Color(0xFF222222);
  static const TextStyle textStyle = TextStyle(color: Colors.white);

  static const TextStyle titleStyle =
      TextStyle(color: Colors.white, fontSize: 14);

  static TextStyle subTitleStyle =
      TextStyle(color: parseColor('#ADABABFF'), fontSize: 10);

  String get appBarTitle {
    return AppLocalizations.of(context)!.addDay;
  }

  get isZh {
    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;
    return languageCode == 'zh';
  }

  get appBarTitleWidget {
    return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appBarTitle,
              style: titleStyle,
            ),
          ],
        ));
  }

  get appBar {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: appBarTitleWidget,
      leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop(null);
          }),
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_unameController.text.isEmpty) {
                logger.i("输入内容");
                return;
              }
              Day day =
                  Day(_unameController.text, _color, _date, widget.day?.id);
              Navigator.of(context).pop(day);
            }),
      ],
    );
  }

  final TextEditingController _unameController = TextEditingController();

  DateTime _date = DateTime.now();
  Color _color = ColorAsset.random();

  @override
  void initState() {
    super.initState();
    _date = widget.day?.startDate ?? DateTime.now();
    _color = widget.day?.color ?? ColorAsset.random();
    _unameController.text = widget.day?.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _unameController,
              autofocus: false,
              decoration: const InputDecoration(
                hintText: "那天发生了什么",
              ),
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2099),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        buttonTheme: const ButtonThemeData(
                          colorScheme: ColorScheme.light(
                            primary: Colors.red, // 这里是你想要的颜色
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    // 如果用户选择了日期，你可以在这里获取并使用该日期
                    logger.i('用户选择的日期是: ${selectedDate.toString()}');
                    setState(() {
                      _date = selectedDate;
                    });
                  }
                });
              },
              child: Row(
                children: [
                  Text(
                    DateFormat(AppLocalizations.of(context)!.appTitleFormat)
                        .format(_date),
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: FractionallySizedBox(
                alignment: Alignment.topCenter,
                heightFactor: 0.4,
                child: GestureDetector(
                  onTap: _selectColor,
                  child: Container(
                    color: _color,
                    child: const Row(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectColor() async {
    FocusScope.of(context).requestFocus(FocusNode());
    Color color = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const ColorsPage();
        },
        fullscreenDialog: true,
      ),
    );
    setState(() {
      _color = color;
    });
  }
}
