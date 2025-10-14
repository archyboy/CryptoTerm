# Quick Start: Setting Up Credentials

## 🚀 Fastest Method (Environment Variables)

```bash
# Set your credentials
export BITGET_API_KEY="your_bitget_api_key"
export BITGET_SECRET_KEY="your_bitget_secret_key"
export BITGET_PASSPHRASE="your_bitget_passphrase"

export BYBIT_API_KEY="your_bybit_api_key"
export BYBIT_SECRET_KEY="your_bybit_secret_key"

# Run the app
v run src/main.v
```

## 📁 Alternative: Configuration File

```bash
# Option 1: Use setup script (interactive)
./setup_credentials.sh

# Option 2: Manual setup
cp credentials.example.json ~/.crypto_term/credentials.json
nano ~/.crypto_term/credentials.json  # Edit with your credentials
chmod 600 ~/.crypto_term/credentials.json
```

## 🧪 Testing Without Credentials (Demo Mode)

Edit `src/main.v`:
```v
mut exchange := bitget.Exchange{
    demo_mode: true  // No credentials needed!
}
```

## 📋 Where to Get API Keys

### BitGet
1. Log in to [BitGet](https://www.bitget.com/)
2. Go to: Profile → API Management
3. Create New API Key
4. **Important:** Enable only needed permissions (disable withdrawals for safety)
5. Save your API Key, Secret Key, and Passphrase securely

### ByBit
1. Log in to [ByBit](https://www.bybit.com/)
2. Go to: Account & Security → API Management
3. Create New API Key
4. **Important:** Set IP restrictions and minimal permissions
5. Save your API Key and Secret Key securely

## ⚠️ Security Reminders

- ✅ Never share your API keys
- ✅ Never commit credentials to Git
- ✅ Use minimal API permissions
- ✅ Enable IP whitelisting
- ✅ Test with demo mode first
- ✅ Rotate keys regularly

## 🆘 Troubleshooting

**"Failed to load credentials"**
→ Make sure environment variables are set OR credentials.json exists

**"Invalid credentials"**  
→ Replace "YOUR_" placeholders with real API keys

**"Permission denied"**
→ Run: `chmod 600 ~/.crypto_term/credentials.json`

## 📖 More Information

- Full guide: [SECURITY.md](SECURITY.md)
- Migration help: [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)
- What changed: [CHANGELOG.md](CHANGELOG.md)

---

**Ready? Start here:** `v run src/main.v`
