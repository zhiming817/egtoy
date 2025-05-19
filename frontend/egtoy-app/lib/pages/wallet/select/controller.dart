import 'package:egtoy/common/routers/routes.dart';
import 'package:get/get.dart';

import 'index.dart';

class YourTokenInfoClass {
  // 示例代币信息类
  final String name;
  final String symbol;
  final String contractAddress;
  final double balance;
  final String? iconUrl;

  YourTokenInfoClass({
    required this.name,
    required this.symbol,
    required this.contractAddress,
    required this.balance,
    this.iconUrl,
  });
}

class TokenSelectionController extends GetxController {
  final isLoading = true.obs;
  final RxList<YourTokenInfoClass> tokens = <YourTokenInfoClass>[].obs;
  final RxList<YourTokenInfoClass> filteredTokens = <YourTokenInfoClass>[].obs;
  final RxString searchQuery = ''.obs;

  // 假设你有一个 WalletService 来获取代币
  // final WalletService _walletService = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchUserTokens();
    // 监听搜索查询的变化
    debounce(
      searchQuery,
      (_) => filterTokens(),
      time: Duration(milliseconds: 300),
    );
  }

  void fetchUserTokens() async {
    isLoading.value = true;
    try {
      // TODO: 从 WalletService 或其他服务获取用户代币列表
      // 示例数据:
      await Future.delayed(Duration(seconds: 1)); // 模拟网络请求
      final fetchedTokens = [
        YourTokenInfoClass(
          name: 'EGTOY',
          symbol: 'EGT',
          contractAddress: 'EGT_contract_address',
          balance: 23.79,
          iconUrl: 'path/to/egt_icon.png',
        ),
        YourTokenInfoClass(
          name: 'ExamplePet',
          symbol: 'EXPET',
          contractAddress: 'EXPET_contract_address',
          balance: 12.0,
          iconUrl: 'path/to/expet_icon.png',
        ),
        YourTokenInfoClass(
          name: 'Solana',
          symbol: 'SOL',
          contractAddress: 'SOL_native_address',
          balance: 6.85559,
          iconUrl: 'path/to/sol_icon.png',
        ),
        // ...更多代币
      ];
      tokens.assignAll(fetchedTokens);
      filterTokens(); // 初始加载后应用一次过滤（显示所有）
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tokens: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void filterTokens() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredTokens.assignAll(tokens);
    } else {
      filteredTokens.assignAll(
        tokens.where(
          (token) =>
              token.name.toLowerCase().contains(query) ||
              token.symbol.toLowerCase().contains(query),
        ),
      );
    }
  }

  void selectToken(YourTokenInfoClass token) {
    //Get.back(result: token); // 返回选中的代币信息
    Get.toNamed(AppRoutes.TokenSend, arguments: {'tokenInfo': token});
  }
}
