import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class MainPage extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Divider(height: 1),
          Divider(height: 1),

          Divider(height: 1),
          Divider(height: 1),
        ],
      ),
    );
  }
}
