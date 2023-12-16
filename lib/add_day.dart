import 'package:flutter/material.dart';
import 'package:flutter_application_1/color_page.dart';
import 'package:flutter_application_1/logger/logger.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'extensions/color.dart';

class Day {
  final String title;
  final Color color;
  final DateTime startDate;

  const Day(this.title, this.color, this.startDate);
}

class AddDay extends StatefulWidget {
  const AddDay({super.key});

  @override
  State<AddDay> createState() => AddDayPageState();
}

class AddDayPageState extends State<AddDay> {
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
            Navigator.pop(context, null);
          }),
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              //
              if (_unameController.text.isEmpty) {
                logger.i("输入内容");
                return;
              }
              Day day = Day(_unameController.text, _color, _date);
              Navigator.pop(context, day);
            }),
      ],
    );
  }

  final TextEditingController _unameController = TextEditingController();

  DateTime _date = DateTime.now();
  Color _color = ColorAsset.random();

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
              decoration: const InputDecoration(
                hintText: "那天发生了什么",
              ),
            ),
            GestureDetector(
              onTap: () {
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
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        buttonTheme: const ButtonThemeData(
                          colorScheme: ColorScheme.light(
                            primary: Colors.red, // 这里是你想要的颜色
                          ),
                        ),
                      ),
                      child: AlertDialog(
                        title: const Text('选择一种颜色'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: _color, // 初始化颜色，你可以根据需要修改
                            onColorChanged: (Color color) {
                              // 这里可以处理颜色变化的逻辑，例如保存选择的颜色
                              _color = color;
                            },
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('确认'),
                            onPressed: () {
                              setState(() {
                                _color = _color;
                              });
                              Navigator.of(context).pop();
                              // 这里可以处理点击确认后的逻辑
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Row(
                children: [
                  ColoredBox(
                    color: _color,
                    child: SizedBox(
                      width: 100,
                      height: 40,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
