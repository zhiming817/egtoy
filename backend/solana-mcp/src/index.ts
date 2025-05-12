/**
 * Solana MCP Tutorial
 * 
 * This file demonstrates how to create a Model Context Protocol (MCP) server
 * that interacts with the Solana devnet to check SOL balances.
 */
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { Connection, PublicKey, LAMPORTS_PER_SOL } from "@solana/web3.js";
import fs from 'fs';
import path from 'path';
import os from 'os';
import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

// Log file path - use the user's temporary directory to ensure write permissions
const LOG_FILE = path.join(os.tmpdir(), 'solana-mcp-server.log');

/**
 * Logs messages to a local file.
 * @param level Log level
 * @param message Log message
 * @param data Additional data
 */
function logToFile(level: LogLevel, message: string, data?: any) {
  const timestamp = new Date().toISOString();
  let logEntry = `[${timestamp}] [${level}] ${message}`;
  
  if (data) {
    logEntry += `\n${typeof data === 'object' ? JSON.stringify(data, null, 2) : data}`;
  }
  
  logEntry += '\n';
  
  fs.appendFileSync(LOG_FILE, logEntry);
  
  // Simultaneously output to the console
  console.log(logEntry);
}
// log level
enum LogLevel {
  DEBUG = 'DEBUG',
  INFO = 'INFO',
  WARN = 'WARN',
  ERROR = 'ERROR'
}

interface BalanceResult {
  success: boolean;
  balance: number;
  error: string | null;
}

/**
 * Query SOL balance of Solana address with retry mechanism
 * @param connection Solana Network connection instance
 * @param address Solana address to be queried
 * @param retries retry count
 * @returns Formatted balance information
 */
export async function getSolanaBalance(
  connection: Connection, 
  address: string,
  retries = 3
): Promise<BalanceResult> {
  for (let i = 0; i < retries; i++) {
    try {
      
      const publicKey = new PublicKey(address);  
      const balance = await connection.getBalance(publicKey);

      return {
        success: true,
        balance: balance / LAMPORTS_PER_SOL,
        error: null
      };
    } catch (error) {
      // If it is the last retry, return an error
      if (i === retries - 1) {
        return {
          success: false,
          balance: 0,
          error: error instanceof Error ? error.message : String(error)
        };
      }
      // Otherwise, wait and retry
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
    }
  }

  return {
    success: false,
    balance: 0,
    error: 'Balance query failed: exceeds maximum retry count'
  };
}

// Create a connection to Solana devnet
 const RPC_ENDPOINT = process.env.SOLANA_RPC_ENDPOINT || "https://api.devnet.solana.com"; // Fallback if not set

const connection = new Connection(RPC_ENDPOINT, {
    commitment: "confirmed",
    confirmTransactionInitialTimeout: 60000, // 60 seconds timeout
  });

// Initialize the MCP server with a name, version, and capabilities
const server = new McpServer({
    name: "solana-devnet",
    version: "0.0.1",
    capabilities: ["get-sol-balance"]
});

// Define a tool that gets the SOL balance for a given address
server.tool(
    "get-sol-balance",
    "query my wallet balance",
    {
        //address: z.string().describe(" Solana address"),
    },
    async ({  }) => {
        const address = process.env.DEFAULT_SOLANA_ADDRESS; // Fallback if not set
      
        if (!address) {
            logToFile(LogLevel.ERROR, "DEFAULT_SOLANA_ADDRESS is not set in .env file.");
            return {
                content: [
                    {
                        type: "text",
                        text: "Configuration error: Default Solana address is not set.",
                    },
                ],
            };
        }

        const result = await getSolanaBalance(connection, address);

        if (result.success) {
            logToFile(LogLevel.INFO, `Balance query successful, send response`, { address, balance: result.balance });
            return {
                content: [
                    {
                        type: "text",
                        text: `your wallet balance is：${result.balance} SOL`,
                    },
                ],
            };
        } else {
            logToFile(LogLevel.ERROR, `Balance query failed, sending error response`, { address, error: result.error });
            return {
                content: [
                    {
                        type: "text",
                        text: `query file,i am sorry! the reason is：${result.error}`,
                    },
                ],
            };
        }
    }
);

// Export server instance for testing
export { server };

/**
 * Main function to start the MCP server
 * Uses stdio for communication with LLM clients
 */
async function main() {
    // Create a log file (if it does not exist)
    try {
        // Ensure that the log directory exists and is writable
        fs.writeFileSync(LOG_FILE, `[${new Date().toISOString()}] [INFO] ========== MCP server start ==========\n`, { flag: 'a' });
        logToFile(LogLevel.INFO, `Log system initialization successful, logs will be written to: ${LOG_FILE}`);
    } catch (error) {
        console.error(`Unable to write log file: ${error}`);
        console.error('Will continue to run without logging to a file');
    }
    
    // Create a transport layer using standard input/output
    const transport = new StdioServerTransport();
    
    // Connect the server to the transport
    await server.connect(transport);
    
    console.log("Solana Devnet MCP Server running on stdio");
}

// Start the server and handle any fatal errors
main().catch((error) => {
    console.error("Fatal error in main():", error);
    process.exit(1);
});

