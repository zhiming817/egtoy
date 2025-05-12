import { Connection, clusterApiUrl ,PublicKey, LAMPORTS_PER_SOL} from "@solana/web3.js";
// import { getSolanaBalance } from 'solanaBalance';


interface BalanceResult {
  success: boolean;
  balance: number;
  error: string | null;
}

/**
 * 查询 Solana 地址的 SOL 余额，带有重试机制
 * @param connection Solana 网络连接实例
 * @param address 要查询的 Solana 地址
 * @param retries 重试次数
 * @returns 格式化的余额信息
 */
export async function getSolanaBalance(
  connection: Connection, 
  address: string,
  retries = 3
): Promise<BalanceResult> {
  for (let i = 0; i < retries; i++) {
    try {
      // 创建公钥对象
      const publicKey = new PublicKey(address);
      
      // 查询余额
      const balance = await connection.getBalance(publicKey);

      // 返回格式化的查询结果
      return {
        success: true,
        balance: balance / LAMPORTS_PER_SOL,
        error: null
      };
    } catch (error) {
      // 如果是最后一次重试，则返回错误
      if (i === retries - 1) {
        return {
          success: false,
          balance: 0,
          error: error instanceof Error ? error.message : String(error)
        };
      }
      // 否则等待后重试
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
    }
  }

  // 兜底返回
  return {
    success: false,
    balance: 0,
    error: '查询余额失败：超过最大重试次数'
  };
}

async function main() {
    // 创建连接，增加 commitment 和 confirmTransactionInitialTimeout
    // const connection = new Connection(clusterApiUrl('devnet'), {
    //     commitment: 'confirmed',
    //     confirmTransactionInitialTimeout: 60000 // 60秒超时
    // });
      const RPC_ENDPOINT = "https://crimson-dimensional-field.solana-devnet.quiknode.pro/4d9178b804f1a135bd98eb7d54a25969cb262f1e/";

  const connection = new Connection(RPC_ENDPOINT, {
    commitment: "confirmed",
    confirmTransactionInitialTimeout: 60000, // 60秒超时
  });
    
    const address = "EQKsPeerwacq5L2kW7qPAjqnJMYhL7ousMY1HKsc219p";
    console.log('开始查询余额...');
    
    const result = await getSolanaBalance(connection, address);
    console.log(result);
}

main().catch(error => {
    console.error('执行出错:', error);
    process.exit(1);
});