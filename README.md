# TokenFactoryPlus Smart Contract

## Overview
This smart contract implements a basic token system with minting, transferring, and burning functionalities. It ensures a maximum supply limit, tracks token balances, and enforces ownership restrictions.

## Features
- **Mint Token**: The contract owner can mint a new token with a specified name, symbol, and supply.
- **Transfer Tokens**: Users can transfer tokens to other principals.
- **Burn Tokens**: Users can burn their tokens, reducing the total supply.
- **Retrieve Balance**: Anyone can check the balance of a given principal.
- **Retrieve Token Details**: Provides token metadata including name, symbol, and total supply.

## Constants
- `MAX_SUPPLY (1,000,000)`: Defines the maximum allowable supply for any token.
- `CONTRACT_OWNER`: The owner of the contract, set to the transaction sender.

## Data Structures
- `token-details`: Stores metadata of the token, including its name, symbol, and total supply.
- `balances`: A mapping of principals to their token balances.

## Error Codes
- `ERR_NOT_OWNER (100)`: Raised when a non-owner attempts an owner-restricted action.
- `ERR_INVALID_SUPPLY (101)`: Raised when the minting supply is invalid (zero or exceeds `MAX_SUPPLY`).
- `ERR_INSUFFICIENT_BALANCE (102)`: Raised when a user attempts to transfer or burn more tokens than they own.
- `ERR_TOKEN_EXISTS (103)`: Raised when attempting to mint a token that already exists.

## Functions

### 1. Mint a New Token
#### `mint-token (name, symbol, supply) -> (ok true | err code)`
- Only callable by the contract owner.
- Creates a new token and assigns the entire supply to the owner.
- Ensures the total supply does not exceed `MAX_SUPPLY`.

### 2. Transfer Tokens
#### `transfer-tokens (to, amount) -> (ok true | err code)`
- Transfers tokens from the sender to the recipient.
- Ensures the sender has a sufficient balance.

### 3. Burn Tokens
#### `burn-tokens (amount) -> (ok true | err code)`
- Reduces the sender's balance and decreases the total supply.
- Ensures the sender has enough tokens to burn.

### 4. Get Balance
#### `get-balance (who) -> uint`
- Returns the token balance of a given principal.

### 5. Get Token Details
#### `get-token-details () -> (tuple name, symbol, total-supply)`
- Returns the token's metadata including name, symbol, and total supply.

## Usage
1. **Deploy the contract.**
2. **Mint a token** using `mint-token` (Only the owner can do this).
3. **Transfer tokens** between users using `transfer-tokens`.
4. **Burn tokens** using `burn-tokens`.
5. **Retrieve balances and token details** using `get-balance` and `get-token-details`.

## Security Considerations
- Only the contract owner can mint new tokens.
- Token transfers and burns are restricted by available balances.
- The total supply cannot exceed `MAX_SUPPLY`.

## License
This smart contract is open-source and available for modification and distribution under an MIT License.

