# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### 🔒 Security Fixes (CRITICAL)

#### Fixed Hardcoded API Credentials Vulnerability
- **Severity:** CRITICAL
- **CVE:** Pending
- **Impact:** Hardcoded API credentials exposed in source code could allow unauthorized access to exchange accounts

**What was fixed:**
- Removed all hardcoded API keys from `exchanges/bitget/bitget.v`
- Removed all hardcoded API secrets from `exchanges/bybit/bybit.v`
- Removed hardcoded passphrase from BitGet exchange module
- Implemented secure credential management system

**Breaking Changes:**
- API credentials must now be provided via environment variables or config file
- Applications will fail to start in live mode without proper credentials
- Demo mode still works without credentials

### Added

- **Secure Credential Management System** (`src/credentials.v`)
  - Load credentials from environment variables (priority 1)
  - Load credentials from secure config file (priority 2)
  - Fallback to demo mode (priority 3)
  - Credential validation to reject example/placeholder values
  - Support for per-exchange configuration

- **New Configuration Files**
  - `credentials.example.json` - Example credentials template
  - `SECURITY.md` - Comprehensive security documentation
  - `MIGRATION_GUIDE.md` - Guide for updating to secure credentials
  - `CHANGELOG.md` - This changelog
  - `setup_credentials.sh` - Interactive setup script

- **Enhanced Security Features**
  - Credential validation checks
  - File permission guidance
  - Git ignore rules for credentials
  - Multiple secure configuration methods

### Changed

- **BitGet Exchange Module** (`exchanges/bitget/bitget.v`)
  - Now loads credentials from secure sources
  - Added `passphrase` field to `User` struct
  - Uses dynamic passphrase instead of hardcoded value
  - Improved error messages for credential issues

- **ByBit Exchange Module** (`exchanges/bybit/bybit.v`)
  - Now loads credentials from secure sources
  - Improved error messages for credential issues
  - Better demo mode handling

- **Documentation** (`README.md`)
  - Added secure credential configuration instructions
  - Updated security considerations section
  - Added links to security documentation
  - Improved setup instructions

- **Git Configuration** (`.gitignore`)
  - Added rules to prevent committing credentials
  - Prevents `credentials.json` from being tracked
  - Protects `~/.crypto_term/credentials.json`

### Security

- **FIXED:** CVE-TBD - Hardcoded API credentials in source code
- **FIXED:** CVE-TBD - Hardcoded passphrase in source code
- **IMPROVED:** Credential storage and management
- **IMPROVED:** Security documentation and guidelines
- **IMPROVED:** Protection against accidental credential commits

### Migration Required

Users must migrate to the new credential system:

1. **Environment Variables:**
   ```bash
   export BITGET_API_KEY="your_key"
   export BITGET_SECRET_KEY="your_secret"
   export BITGET_PASSPHRASE="your_passphrase"
   ```

2. **Configuration File:**
   ```bash
   cp credentials.example.json ~/.crypto_term/credentials.json
   # Edit with real credentials
   chmod 600 ~/.crypto_term/credentials.json
   ```

3. **Demo Mode** (no credentials needed):
   ```v
   mut exchange := bitget.Exchange{ demo_mode: true }
   ```

See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for detailed instructions.

---

## [0.0.1] - 2024-XX-XX

### Added
- Initial release
- BitGet exchange integration
- ByBit exchange integration
- User authentication system
- Live wallet tracking
- Market data display
- Manual order placement
- Buy/sell operations
- Demo mode support
- Terminal-based UI

### Security Issues (Now Fixed)
- ❌ Hardcoded API credentials (CRITICAL)
- ❌ Hardcoded passphrase (CRITICAL)
- ❌ Plaintext password storage (CRITICAL - still pending fix)
- ❌ Default credentials (CRITICAL - still pending fix)
- ❌ No input validation (HIGH - still pending fix)

---

## Security Disclosure

For security issues, please see our security policy in [SECURITY.md](SECURITY.md).

**Do not** open public issues for security vulnerabilities.

---

[Unreleased]: https://github.com/archyboy/CryptoTerm/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/archyboy/CryptoTerm/releases/tag/v0.0.1
