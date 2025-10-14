# CryptoTerm

> A powerful terminal-based cryptocurrency management and trading platform built with V

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![V Version](https://img.shields.io/badge/V-latest-blue.svg)](https://vlang.io/)
[![Version](https://img.shields.io/badge/version-0.0.1-green.svg)](https://github.com/archyboy/CryptoTerm)

## Overview

CryptoTerm is a comprehensive command-line interface (CLI) application designed for cryptocurrency traders and enthusiasts who prefer working in a terminal environment. Built with the V programming language, it provides direct API integration with major cryptocurrency exchanges, offering real-time market data, portfolio management, and automated trading capabilities—all from the comfort of your terminal.

## Key Features

### 🔐 Multi-User Authentication System
- Secure user login with password protection
- Auto-login functionality for trusted environments
- Session management with automatic logout capabilities
- User profile persistence across sessions

### 📊 Exchange Integration
Currently supporting multiple cryptocurrency exchanges with full API integration:
- **BitGet** - Complete spot trading support with demo and live modes
- **ByBit** - Advanced trading features and market data
- Extensible architecture for adding additional exchanges (MEXC ready)

### 💼 Portfolio & Wallet Management
- **Live Wallet Tracking**: Real-time monitoring of your cryptocurrency holdings
- **Asset Overview**: Comprehensive view of all assets across accounts
- **Multi-Wallet Support**: Manage multiple wallets including paper wallets and hardware wallet addresses
- **Owned Coins Dashboard**: Quick access to your current positions

### 📈 Market Intelligence
- **Real-Time Market Data**: Live price feeds and market statistics
- **New Coins Tracker**: Stay updated with newly listed cryptocurrencies
- **Market Analysis**: Sort and filter coins by various metrics:
  - Trading volume
  - Market capitalization
  - Price movements
  - Volatility indicators

### 📰 News & Announcements
- Integrated news feed from exchanges
- Important announcements and updates
- Market-moving news aggregation from crypto API services

### 🤖 AI-Powered Trading Assistant
- **Trade Recommendations**: AI-driven suggestions based on:
  - Historical data analysis
  - Market trends and patterns
  - User-defined parameters and risk tolerance
  - Multiple data source correlation
- **Automated Trading Robot**: Configure automated trading strategies

### 🛠️ Trading Operations
- **Manual Order Placement**: Full control over buy/sell orders
- **Quick Buy Interface**: Streamlined coin purchasing workflow
- **Spot Trading**: Execute spot market trades directly from terminal
- **Order Management**: Track and modify existing orders

### 🎨 Advanced Terminal UI
- Clean, intuitive menu-driven interface
- Color-coded information display using themes
- Terminal title updates with exchange and mode information
- Responsive layout adapting to terminal dimensions
- Real-time data updates without screen flicker

### 🔧 Developer Features
- **Demo Mode**: Test strategies without risking real funds
- **Sandbox Environment**: Experiment with features safely
- **Comprehensive Error Handling**: Detailed error messages and recovery
- **Logging System**: Track all operations for debugging
- **Modular Architecture**: Easy to extend and maintain

## Architecture

CryptoTerm follows a clean, modular architecture:

```
CryptoTerm/
├── src/
│   ├── main.v              # Application entry point
│   ├── application/        # Core application logic
│   │   ├── application.v   # Main app controller & menu system
│   │   ├── buy.v          # Buy operations
│   │   ├── market.v       # Market data display
│   │   ├── live_wallet.v  # Real-time wallet tracking
│   │   ├── manual_order.v # Manual order placement
│   │   └── ...
│   ├── config.v           # Configuration management
│   ├── userstuff.v        # User authentication & profiles
│   ├── helpers.v          # Utility functions
│   └── constants.v        # Application constants
├── exchanges/
│   ├── bitget/
│   │   ├── bitget.v       # BitGet API implementation
│   │   ├── api_params.v   # Parameter handling
│   │   └── converts.v     # Data type conversions
│   └── bybit/
│       └── bybit.v        # ByBit API implementation
├── themes/                # UI theming system
├── fancystuff/           # Enhanced UI components
└── tests/                # Unit and integration tests
```

### Security Architecture

CryptoTerm implements secure API communication:
- HMAC-SHA256 signature generation for authenticated requests
- Base64-encoded authentication headers
- Timestamp-based request validation
- Secure credential storage
- Separate demo mode for testing without real credentials

## Installation

### Prerequisites

- [V compiler](https://github.com/vlang/v) (latest version)
- Git
- Terminal with UTF-8 support
- Active internet connection

### Quick Start

```bash
# Clone the repository
git clone https://github.com/archyboy/CryptoTerm.git
cd CryptoTerm

# Install dependencies
v install

# Run the application
v run src/main.v
```

### Configuration

1. **Exchange API Keys**: Edit the exchange initialization in `src/main.v` or relevant exchange module files to add your API credentials.

2. **Demo Mode**: Toggle demo mode in `src/main.v`:
```v
mut exchange := bitget.Exchange{
    demo_mode: true  // Set to false for live trading
}
```

3. **Default Exchange**: Choose your preferred exchange in `main.v`:
```v
// For BitGet
mut exchange := bitget.Exchange{ demo_mode: false }

// Or for ByBit
// mut exchange := bybit.Exchange{ demo_mode: false }
```

## Usage

### First Time Setup

1. Run the application
2. Create your user account when prompted
3. Configure your exchange API credentials
4. Choose between Demo Mode or Live Mode

### Main Menu Options

- **SA** - Sandbox: Safe environment for testing and learning
- **AN** - Announcements: Latest news and updates
- **W** - Wallet: View all assets across accounts
- **LI** - Live Wallet: Real-time portfolio tracking
- **O** - Owned Coins: Quick view of current holdings
- **M** - Market: Browse and analyze market data
- **N** - New Coins: Discover newly listed cryptocurrencies
- **MO** - Manual Order: Place custom buy/sell orders
- **B** - Buy: Quick buy interface
- **S** - Sell: Sell spot positions
- **A** - Advises: AI-powered trading suggestions
- **R** - Robot AI: Configure automated trading
- **C** - Config: Application settings
- **SW** - Switch Mode: Toggle between Demo and Live modes
- **LO** - Log Out: End current session
- **Q** - Quit: Exit application

### Example Workflow

```bash
# Start CryptoTerm
v run src/main.v

# Login with your credentials
# Choose 'LI' to view your live wallet
# Press 'M' to analyze the market
# Use 'B' to place a buy order
# Check 'A' for AI recommendations
```

## API Integration Details

### BitGet Exchange

CryptoTerm implements full BitGet API v2 integration:
- **Authentication**: HMAC-SHA256 with API key and secret
- **Endpoints Supported**:
  - Account information
  - Market data
  - Order placement and management
  - Real-time price feeds
- **Rate Limiting**: Automatically managed
- **Error Handling**: Comprehensive response parsing

### Adding New Exchanges

The modular design makes it easy to add new exchange integrations:

1. Create a new module in `exchanges/[exchange_name]/`
2. Implement the `Exchange` interface
3. Add authentication and API methods
4. Import in `src/main.v`
5. Add menu options in `application.v`

## Development

### Building from Source

```bash
# Development build with debugging
v -g src/main.v

# Production build (optimized)
v -prod src/main.v
```

### Running Tests

```bash
# Run all tests
v test tests/

# Run specific test
v test tests/price_up_down.v
```

### Project Dependencies

- **disco07.colorize**: Enhanced terminal color support
- Standard V libraries:
  - `net.http`: HTTP client for API communication
  - `crypto.sha256` & `crypto.hmac`: Cryptographic operations
  - `term`: Terminal manipulation
  - `json`: JSON parsing and encoding
  - `log`: Application logging

## Roadmap

### Upcoming Features

- [ ] Additional exchange integrations (Binance, Coinbase, Kraken)
- [ ] Advanced charting in terminal (candlestick patterns)
- [ ] Portfolio performance analytics
- [ ] Tax reporting tools
- [ ] Telegram/Discord notifications
- [ ] Custom trading strategies scripting
- [ ] WebSocket support for real-time data
- [ ] Multi-currency fiat support
- [ ] DCA (Dollar Cost Averaging) automation
- [ ] Stop-loss and take-profit automation

### Version 0.1.0 Goals

- Complete BitGet and ByBit integration
- Stable user authentication system
- AI recommendation engine v1
- Comprehensive test coverage
- Documentation completion

## Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow V language conventions and style guide
- Add tests for new features
- Update documentation
- Ensure demo mode functionality for testing
- Comment complex algorithms

## Security Considerations

⚠️ **Important Security Notes:**

- Never commit API keys to the repository
- Use environment variables for sensitive credentials
- Always test with demo mode first
- Be cautious with automated trading - start with small amounts
- Regularly rotate API keys
- Use API keys with minimal necessary permissions
- Enable IP whitelisting on exchanges when possible

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

**Trading cryptocurrencies carries risk. This software is provided "as is" without warranty of any kind. The authors are not responsible for any financial losses incurred through the use of this software. Always do your own research and never invest more than you can afford to lose.**

## Support

- **Issues**: [GitHub Issues](https://github.com/archyboy/CryptoTerm/issues)
- **Discussions**: [GitHub Discussions](https://github.com/archyboy/CryptoTerm/discussions)

## Acknowledgments

- [V Language](https://vlang.io/) - For the amazing programming language
- BitGet & ByBit - For comprehensive API documentation
- The V community - For support and libraries

---

**Made with ❤️ and V by the CryptoTerm team**
