# Migration Guide: Secure Credentials

## ⚠️ Important: Breaking Changes

Version 0.0.2 introduces **secure credential management** to fix critical security vulnerabilities. Hardcoded API credentials have been removed from the codebase.

## What Changed?

### Before (Insecure ❌)
```v
// Credentials were hardcoded directly in source code
exchange.credentials.api_key = 'hardcoded_value'
exchange.credentials.secret_key = 'hardcoded_value'
api_req.header.add_custom('ACCESS-PASSPHRASE', 'hardcoded_value')!
```

### After (Secure ✅)
```v
// Loaded from environment variables or secure config file
creds := credentials.load_credentials('bitget')!
exchange.credentials.api_key = creds.api_key
exchange.credentials.secret_key = creds.secret_key
exchange.credentials.passphrase = creds.passphrase
```

## How to Migrate

### Option 1: Environment Variables (Recommended)

Set environment variables before running the application:

```bash
# BitGet
export BITGET_API_KEY="your_actual_api_key"
export BITGET_SECRET_KEY="your_actual_secret_key"
export BITGET_PASSPHRASE="your_actual_passphrase"

# ByBit
export BYBIT_API_KEY="your_actual_api_key"
export BYBIT_SECRET_KEY="your_actual_secret_key"

# Run application
v run src/main.v
```

**Make it permanent** by adding to `~/.bashrc` or `~/.zshrc`:

```bash
# Add to ~/.bashrc or ~/.zshrc
echo 'export BITGET_API_KEY="your_api_key"' >> ~/.bashrc
echo 'export BITGET_SECRET_KEY="your_secret_key"' >> ~/.bashrc
echo 'export BITGET_PASSPHRASE="your_passphrase"' >> ~/.bashrc
source ~/.bashrc
```

### Option 2: Configuration File

1. **Use the setup script:**
   ```bash
   ./setup_credentials.sh
   ```

2. **Or manually create the file:**
   ```bash
   mkdir -p ~/.crypto_term
   cp credentials.example.json ~/.crypto_term/credentials.json
   ```

3. **Edit with your credentials:**
   ```bash
   nano ~/.crypto_term/credentials.json
   ```

4. **Set secure permissions:**
   ```bash
   chmod 600 ~/.crypto_term/credentials.json
   chmod 700 ~/.crypto_term
   ```

### Option 3: Demo Mode (Testing Only)

For testing without real credentials:

```v
// In src/main.v
mut exchange := bitget.Exchange{
    demo_mode: true  // No credentials needed
}
```

## File Changes

### New Files
- ✅ `src/credentials.v` - Secure credential management module
- ✅ `credentials.example.json` - Example configuration file
- ✅ `SECURITY.md` - Comprehensive security documentation
- ✅ `MIGRATION_GUIDE.md` - This file
- ✅ `setup_credentials.sh` - Interactive setup script

### Modified Files
- ✅ `exchanges/bitget/bitget.v` - Loads credentials securely
- ✅ `exchanges/bybit/bybit.v` - Loads credentials securely
- ✅ `.gitignore` - Prevents committing credentials
- ✅ `README.md` - Updated configuration instructions

## Credential Loading Priority

The application tries to load credentials in this order:

1. **Environment Variables** (highest priority)
   - `BITGET_API_KEY`, `BITGET_SECRET_KEY`, `BITGET_PASSPHRASE`
   - `BYBIT_API_KEY`, `BYBIT_SECRET_KEY`

2. **Configuration File**
   - `~/.crypto_term/credentials.json`

3. **Demo Mode** (fallback)
   - Empty credentials, no real API calls

## Troubleshooting

### Error: "Failed to load BitGet credentials"

**Cause:** No credentials found in environment or config file.

**Solution:**
1. Set environment variables (see Option 1 above)
2. Or create credentials file (see Option 2 above)
3. Or use demo mode for testing

### Error: "Invalid BitGet credentials"

**Cause:** Credentials contain placeholder values like "YOUR_" or "xxxx".

**Solution:** Replace example values with your real API credentials from the exchange.

### Error: "Failed to read credentials file"

**Cause:** Credentials file doesn't exist or has wrong permissions.

**Solution:**
```bash
# Check if file exists
ls -la ~/.crypto_term/credentials.json

# If not, create it
cp credentials.example.json ~/.crypto_term/credentials.json

# Set proper permissions
chmod 600 ~/.crypto_term/credentials.json
```

## Security Improvements

This migration fixes the following security vulnerabilities:

- ✅ **CRITICAL:** Removed hardcoded API keys from source code
- ✅ **CRITICAL:** Removed hardcoded API secrets from source code  
- ✅ **CRITICAL:** Removed hardcoded passphrase from source code
- ✅ **HIGH:** Added credential validation to reject example values
- ✅ **HIGH:** Added secure file permissions guidance
- ✅ **MEDIUM:** Added .gitignore rules to prevent credential commits
- ✅ **MEDIUM:** Added comprehensive security documentation

## Need Help?

- 📖 Read [SECURITY.md](SECURITY.md) for detailed security guidelines
- 🐛 Report issues on GitHub
- 💬 Ask questions in GitHub Discussions

## Rollback (Not Recommended)

If you need to rollback temporarily:

```bash
git checkout v0.0.1
```

**⚠️ Warning:** Old version has critical security vulnerabilities. Update as soon as possible.
