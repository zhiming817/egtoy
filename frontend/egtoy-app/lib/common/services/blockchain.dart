import 'dart:async';

// import 'package:egtoy/common/services/contract.dart';
import 'package:egtoy/common/services/solana.dart';
import 'package:egtoy/common/services/wallet.dart';
import 'package:solana/solana.dart';

class BlockchainManager {
  late final WalletService walletService;
  late final SolanaService solanaService;
  //late final ContractService contractService;

  Wallet? currentWallet;

  BlockchainManager({bool devnet = true}) {
    walletService = WalletService();
    solanaService = SolanaService(devnet: devnet);
    //contractService = ContractService();
  }

  // 应用中的其他方法...
}
