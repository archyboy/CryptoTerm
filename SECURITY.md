# Security Guidelines for CryptoTerm

## 🔐 Credential Management

CryptoTerm uses a secure credential management system to protect your API keys and secrets. **Never hardcode credentials in source code.**

### Method 1: Environment Variables (Recommended)

Set environment variables before running the application:

```bash
# For BitGet
export BITGET_API_KEY="your_bitget_api_key"
export BITGET_SECRET_KEY="your_bitget_secret_key"
export BITGET_PASSPHRASE="your_bitget_passphrase"

# For ByBit
export BYBIT_API_KEY="your_bybit_api_key"
export BYBIT_SECRET_KEY="your_bybit_secret_key"

# Run the application
v run src/main.v
```

**Tip:** Add these to your `~/.bashrc` or `~/.zshrc` for persistence (but be aware of security implications).

### Method 2: Credentials Configuration File

1. **Copy the example file:**
   ```bash
   cp credentials.example.json ~/.crypto_term/credentials.json
   ```

2. **Edit the file with your real credentials:**
   ```bash
   nano ~/.crypto_term/credentials.json
   ```

3. **Set secure file permissions:**
   ```bash
   chmod 600 ~/.crypto_term/credentials.json
   ```

4. **File structure:**
   ```json
   {
     "bitget": {
       "api_key": "bg_xxxxxxxxxxxxxxxx",
       "secret_key": "xxxxxxxxxxxxxxxx",
       "passphrase": "YourPassphrase123"
     },
     "bybit": {
       "api_key": "xxxxxxxxxxxxxxxx",
       "secret_key": "bt_xxxxxxxxxxxxxxxx",
       "passphrase": ""
     }
   }
   ```

### Priority Order

The application loads credentials in this order:
1. **Environment Variables** (highest priority)
2. **Configuration File** (`~/.crypto_term/credentials.json`)
3. **Demo Mode** (empty credentials)

## 🔒 Security Best Practices

### API Key Security

1. **Use API Key Restrictions:**
   - Enable IP whitelisting on your exchange account
   - Limit API key permissions (disable withdrawals if not needed)
   - Set trading limits on your API keys

2. **Never Share Your Keys:**
   - Don't commit credentials to Git
   - Don't share credentials in chat/email/screenshots
   - Don't paste credentials in logs

3. **Rotate Keys Regularly:**
   - Change your API keys every 30-90 days
   - Immediately rotate keys if you suspect compromise
   - Use different keys for different applications

4. **Test with Demo Mode First:**
   ```v
   mut exchange := bitget.Exchange{
       demo_mode: true  // Test without real credentials
   }
   ```

### File Permissions

Always set secure permissions on sensitive files:

```bash
# Credentials file (read/write by owner only)
chmod 600 ~/.crypto_term/credentials.json

# Database directory
chmod 700 ~/.crypto_term/db/

# Database file
chmod 600 ~/.crypto_term/db/user.json
```

### What's Protected

✅ **Protected by .gitignore:**
- `credentials.json`
- `~/.crypto_term/credentials.json`
- `db/user.json`

⚠️ **You must still be careful not to:**
- Hardcode credentials in code
- Print credentials in debug statements
- Share your `.crypto_term` directory
- Commit local configuration files

## 🚨 What to Do If Credentials Are Compromised

1. **Immediately revoke the API keys** on the exchange website
2. **Generate new API keys** with restricted permissions
3. **Update your credentials** using one of the methods above
4. **Check your account activity** for unauthorized trades
5. **Enable 2FA** on your exchange account if not already enabled

## 📝 Credential Validation

The application automatically validates credentials:
- Checks if credentials are not empty
- Rejects example/placeholder values (containing "YOUR_" or "xxxx")
- Provides clear error messages if credentials are invalid

## 🛡️ Additional Security Measures

1. **Use 2FA** on your exchange accounts
2. **Enable withdrawal whitelist** on exchanges
3. **Start with small amounts** when testing live trading
4. **Monitor your account regularly** for suspicious activity
5. **Keep your system updated** and use antivirus software
6. **Use a dedicated machine** for trading if possible

## 📞 Reporting Security Issues

If you discover a security vulnerability in CryptoTerm, please:
1. **Do NOT** open a public issue
2. Email the maintainers directly
3. Provide detailed information about the vulnerability
4. Allow time for a fix before public disclosure

---

**Remember: Your API keys are like your bank password. Protect them accordingly!**
