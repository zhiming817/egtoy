import 'package:bip39/bip39.dart' as bip39;
import 'package:solana/solana.dart';
import 'package:bs58/bs58.dart' as bs58;
import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletService extends GetxService {
  // 当前钱包
  final Rx<Ed25519HDKeyPair?> _currentWallet = Rx<Ed25519HDKeyPair?>(null);
  Ed25519HDKeyPair? getCurrentWallet() => _currentWallet.value;

  // 安全存储
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _mnemonicKey = 'wallet_mnemonic';

  WalletService();

  // 设置当前钱包
  void setCurrentWallet(Ed25519HDKeyPair wallet) {
    _currentWallet.value = wallet;
  }

  // 创建新钱包
  Future<Ed25519HDKeyPair> createWallet() async {
    // 生成助记词
    final mnemonic = bip39.generateMnemonic();

    // 保存助记词
    await _storage.write(key: _mnemonicKey, value: mnemonic);

    // 从助记词创建钱包
    final wallet = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
    return wallet;
  }

  // 从助记词导入钱包
  Future<Ed25519HDKeyPair> importWalletFromMnemonic(String mnemonic) async {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception('无效的助记词');
    }

    // 保存助记词
    await _storage.write(key: _mnemonicKey, value: mnemonic);

    // 从助记词创建钱包
    final wallet = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
    return wallet;
  }

  // 获取钱包助记词
  Future<String?> getMnemonic() async {
    return await _storage.read(key: _mnemonicKey);
  }

  // 清除钱包
  Future<void> clearWallet() async {
    _currentWallet.value = null;
    await _storage.delete(key: _mnemonicKey);
  }

  Future<Wallet> importWalletFromPrivateKey(List<int> privateKey) async {
    final wallet = await Ed25519HDKeyPair.fromPrivateKeyBytes(
      privateKey: privateKey,
    );
    return wallet;
  }

  Future<Ed25519HDKeyPair> importWalletFromPrivateKeyString(
    String privateKeyString,
  ) async {
    try {
      // 首先清理输入，移除任何空白字符
      privateKeyString = privateKeyString.trim();
      Ed25519HDKeyPair wallet;

      // 尝试作为Base58格式的私钥处理
      try {
        // Solana私钥通常为64字节(需要被base58编码), 长度通常在43-44左右
        final secretKey = bs58.base58.decode(privateKeyString);

        // 修复：使用fromPrivateKeyBytes而不是fromSecretKey
        if (secretKey.length >= 32) {
          // 获取私钥部分（通常前32字节是私钥）
          final privateKey = secretKey.sublist(0, 32);
          wallet = await Ed25519HDKeyPair.fromPrivateKeyBytes(
            privateKey: privateKey,
          );
          setCurrentWallet(wallet); // 设置当前钱包
          return wallet;
        } else {
          throw FormatException('解码后的私钥长度不足');
        }
      } catch (e) {
        // 如果Base58解码失败，继续尝试其他格式
        print("Base58解码失败，尝试其他格式: $e");
      }

      // 尝试作为十六进制字符串处理
      String hexString = privateKeyString;
      if (hexString.startsWith('0x')) {
        hexString = hexString.substring(2);
      }

      // 确保字符串长度是偶数
      if (hexString.length % 2 != 0) {
        hexString = '0$hexString';
      }

      // 检查是否只包含有效的十六进制字符
      if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(hexString)) {
        throw FormatException('私钥必须是有效的十六进制字符串或Base58编码');
      }

      final privateKeyBytes = List<int>.generate(
        hexString.length ~/ 2,
        (i) => int.parse(hexString.substring(i * 2, i * 2 + 2), radix: 16),
      );

      wallet = await Ed25519HDKeyPair.fromPrivateKeyBytes(
        privateKey: privateKeyBytes,
      );
      setCurrentWallet(wallet); // 设置当前钱包
      return wallet;
    } catch (e) {
      // 更详细的错误信息
      print("导入钱包失败: $e");
      throw FormatException('无效的私钥格式: ${e.toString()}');
    }
  }
}
