# Solana MCP Service

`solana-mcp` is a backend service for handling operations related to the Solana blockchain.

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Project](#running-the-project)
- [Building the Project](#building-the-project)
- [Running Tests](#running-tests)

## Installation

After cloning the repository, navigate to the `backend/solana-mcp` directory and run the following command to install dependencies:

```bash
npm install
```

## Configuration

If the project requires environment variables, ensure you create a `.env` file in the `backend/solana-mcp` directory and configure the variables as needed. For example:

```env
SOLANA_RPC_URL=https://api.mainnet-beta.solana.com
PRIVATE_KEY=YOUR_PRIVATE_KEY_HERE
```

## Running the Project

To run the project in development mode (if a `start:dev` or similar script is configured):

```bash
npm run start:dev
```

Alternatively, to run the compiled JavaScript files directly (assuming the entry point is `build/index.js`):

```bash
npm start
```
or
```bash
node build/index.js
```

Please check the `scripts` section in [backend/solana-mcp/package.json](backend/solana-mcp/package.json) for the exact run commands.

## Building the Project

To compile the TypeScript code to JavaScript:

```bash
npm run build
```
This will typically output the compiled files to the `build` directory.

## Running Tests

The project uses Jest for testing. Run the following command to execute tests:

```bash
npm test
```