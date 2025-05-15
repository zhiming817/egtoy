import 'package:egtoy/common/entities/entities.dart';
import 'package:get/get.dart';

class MainState {
  // 选中的分类Code
  var _selCategoryCode = "".obs;
  set selCategoryCode(value) => _selCategoryCode.value = value;
  get selCategoryCode => _selCategoryCode.value;
}
