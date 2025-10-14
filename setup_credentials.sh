#!/bin/bash

# CryptoTerm Credentials Setup Script
# This script helps you set up your exchange API credentials securely

set -e

CREDENTIALS_DIR="$HOME/.crypto_term"
CREDENTIALS_FILE="$CREDENTIALS_DIR/credentials.json"
EXAMPLE_FILE="credentials.example.json"

echo "🔐 CryptoTerm Credentials Setup"
echo "================================"
echo ""

# Create directory if it doesn't exist
if [ ! -d "$CREDENTIALS_DIR" ]; then
    echo "📁 Creating credentials directory..."
    mkdir -p "$CREDENTIALS_DIR"
    chmod 700 "$CREDENTIALS_DIR"
fi

# Check if credentials file already exists
if [ -f "$CREDENTIALS_FILE" ]; then
    echo "⚠️  Warning: Credentials file already exists at $CREDENTIALS_FILE"
    read -p "Do you want to overwrite it? (yes/no): " OVERWRITE
    if [ "$OVERWRITE" != "yes" ]; then
        echo "❌ Setup cancelled. Existing credentials file preserved."
        exit 0
    fi
fi

echo ""
echo "Choose setup method:"
echo "1) Interactive setup (enter credentials now)"
echo "2) Copy example file (edit manually later)"
echo "3) Use environment variables (no file needed)"
echo ""
read -p "Enter choice (1-3): " CHOICE

case $CHOICE in
    1)
        echo ""
        echo "📝 Interactive Credentials Setup"
        echo "================================="
        echo ""
        echo "BitGet Credentials:"
        read -p "  API Key: " BITGET_API_KEY
        read -s -p "  Secret Key: " BITGET_SECRET_KEY
        echo ""
        read -s -p "  Passphrase: " BITGET_PASSPHRASE
        echo ""
        echo ""
        echo "ByBit Credentials:"
        read -p "  API Key: " BYBIT_API_KEY
        read -s -p "  Secret Key: " BYBIT_SECRET_KEY
        echo ""
        echo ""

        # Create JSON file
        cat > "$CREDENTIALS_FILE" << EOF
{
  "bitget": {
    "api_key": "$BITGET_API_KEY",
    "secret_key": "$BITGET_SECRET_KEY",
    "passphrase": "$BITGET_PASSPHRASE"
  },
  "bybit": {
    "api_key": "$BYBIT_API_KEY",
    "secret_key": "$BYBIT_SECRET_KEY",
    "passphrase": ""
  }
}
EOF

        chmod 600 "$CREDENTIALS_FILE"
        echo "✅ Credentials file created at: $CREDENTIALS_FILE"
        echo "✅ File permissions set to 600 (owner read/write only)"
        ;;

    2)
        if [ ! -f "$EXAMPLE_FILE" ]; then
            echo "❌ Error: Example file not found at $EXAMPLE_FILE"
            echo "   Please run this script from the CryptoTerm root directory."
            exit 1
        fi

        cp "$EXAMPLE_FILE" "$CREDENTIALS_FILE"
        chmod 600 "$CREDENTIALS_FILE"
        
        echo ""
        echo "✅ Example file copied to: $CREDENTIALS_FILE"
        echo "✅ File permissions set to 600 (owner read/write only)"
        echo ""
        echo "⚠️  IMPORTANT: Edit this file with your real credentials:"
        echo "   nano $CREDENTIALS_FILE"
        echo "   or"
        echo "   vim $CREDENTIALS_FILE"
        ;;

    3)
        echo ""
        echo "📋 Environment Variables Setup"
        echo "=============================="
        echo ""
        echo "Add these lines to your ~/.bashrc or ~/.zshrc:"
        echo ""
        echo "# BitGet API Credentials"
        echo "export BITGET_API_KEY=\"your_api_key_here\""
        echo "export BITGET_SECRET_KEY=\"your_secret_key_here\""
        echo "export BITGET_PASSPHRASE=\"your_passphrase_here\""
        echo ""
        echo "# ByBit API Credentials"
        echo "export BYBIT_API_KEY=\"your_api_key_here\""
        echo "export BYBIT_SECRET_KEY=\"your_secret_key_here\""
        echo ""
        echo "Then run: source ~/.bashrc (or source ~/.zshrc)"
        echo ""
        echo "✅ No credentials file needed with environment variables."
        exit 0
        ;;

    *)
        echo "❌ Invalid choice. Setup cancelled."
        exit 1
        ;;
esac

echo ""
echo "🎉 Setup complete!"
echo ""
echo "🔒 Security reminders:"
echo "  • Never commit credentials to Git"
echo "  • Never share credentials with anyone"
echo "  • Rotate API keys regularly (every 30-90 days)"
echo "  • Use minimal API permissions (disable withdrawals if not needed)"
echo "  • Enable IP whitelisting on your exchange accounts"
echo "  • Test with demo mode first before live trading"
echo ""
echo "📖 For more information, see SECURITY.md"
echo ""
echo "▶️  You can now run: v run src/main.v"
