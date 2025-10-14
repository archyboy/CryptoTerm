module credentials

import os
import json

// Exchange credentials structure
pub struct ExchangeCredentials {
pub mut:
	api_key    string
	secret_key string
	passphrase string // For exchanges that require it (like BitGet)
}

// All credentials configuration
pub struct CredentialsConfig {
pub mut:
	bitget ExchangeCredentials
	bybit  ExchangeCredentials
}

// Load credentials from environment variables or secure config file
// Priority: Environment Variables > Config File > Empty (demo mode)
pub fn load_credentials(exchange_name string) !ExchangeCredentials {
	// Try loading from environment variables first
	creds := load_from_env(exchange_name) or {
		// Fallback to config file
		load_from_config(exchange_name) or {
			// If both fail, return empty credentials (demo mode)
			return ExchangeCredentials{}
		}
	}
	
	return creds
}

// Load credentials from environment variables
fn load_from_env(exchange_name string) !ExchangeCredentials {
	prefix := exchange_name.to_upper()
	
	api_key := os.getenv('${prefix}_API_KEY')
	secret_key := os.getenv('${prefix}_SECRET_KEY')
	passphrase := os.getenv('${prefix}_PASSPHRASE')
	
	// If no API key found, return error to try next method
	if api_key == '' {
		return error('No environment variables found for ${exchange_name}')
	}
	
	return ExchangeCredentials{
		api_key:    api_key
		secret_key: secret_key
		passphrase: passphrase
	}
}

// Load credentials from config file
fn load_from_config(exchange_name string) !ExchangeCredentials {
	config_path := get_credentials_file_path()
	
	if !os.exists(config_path) {
		return error('Credentials config file not found: ${config_path}')
	}
	
	// Read the config file
	config_content := os.read_file(config_path) or {
		return error('Failed to read credentials file: ${err}')
	}
	
	// Parse JSON
	config := json.decode(CredentialsConfig, config_content) or {
		return error('Failed to parse credentials file: ${err}')
	}
	
	// Return the appropriate exchange credentials
	return match exchange_name.to_lower() {
		'bitget' { config.bitget }
		'bybit' { config.bybit }
		else { error('Unknown exchange: ${exchange_name}') }
	}
}

// Get the path to the credentials file
pub fn get_credentials_file_path() string {
	home_dir := os.home_dir()
	return os.join_path(home_dir, '.crypto_term', 'credentials.json')
}

// Create example credentials file (for user reference only)
pub fn create_example_credentials_file() ! {
	example_config := CredentialsConfig{
		bitget: ExchangeCredentials{
			api_key:    'YOUR_BITGET_API_KEY_HERE'
			secret_key: 'YOUR_BITGET_SECRET_KEY_HERE'
			passphrase: 'YOUR_BITGET_PASSPHRASE_HERE'
		}
		bybit: ExchangeCredentials{
			api_key:    'YOUR_BYBIT_API_KEY_HERE'
			secret_key: 'YOUR_BYBIT_SECRET_KEY_HERE'
			passphrase: ''
		}
	}
	
	example_json := json.encode_pretty(example_config)
	example_path := get_credentials_file_path().replace('.json', '.example.json')
	
	// Ensure directory exists
	dir := os.dir(example_path)
	if !os.exists(dir) {
		os.mkdir_all(dir) or {
			return error('Failed to create directory: ${err}')
		}
	}
	
	// Write example file
	os.write_file(example_path, example_json) or {
		return error('Failed to write example file: ${err}')
	}
	
	println('Example credentials file created at: ${example_path}')
	println('Copy this file to credentials.json and add your real credentials.')
}

// Validate that credentials are not example/default values
pub fn (creds ExchangeCredentials) is_valid() bool {
	if creds.api_key == '' || creds.secret_key == '' {
		return false
	}
	
	// Check for example placeholders
	if creds.api_key.contains('YOUR_') || creds.api_key.contains('xxxx') {
		return false
	}
	
	if creds.secret_key.contains('YOUR_') || creds.secret_key.contains('xxxx') {
		return false
	}
	
	return true
}

// Set secure file permissions (Unix-like systems only)
pub fn set_secure_permissions(file_path string) ! {
	$if !windows {
		// Set file permissions to 0600 (read/write by owner only)
		os.chmod(file_path, 0o600) or {
			return error('Failed to set secure permissions: ${err}')
		}
	}
}
