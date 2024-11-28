module application

import term
import json

pub struct AssetsOverview {
pub mut:
	accounts []Account @[json: data]
}

pub struct Account {
pub mut:
	account_type string @[json: accountType]
	usdt_balance string @[json: usdtBalance]
}

pub fn (mut app App) get_assets() !AssetsOverview {
	query_params := {
		'language': 'en_US'
	}

	resp := app.exchange.execute('GET', '/api/v2/account/all-account-balance', app.exchange.params_to_query_str(query_params),
		'')!
	// println(resp.body)
	assets := json.decode(AssetsOverview, resp.body) or {
		return error('Could not decode assets overview json')
	}
	return assets
}

pub fn (mut app App) show_assets() ! {
	assets := app.get_assets() or { return error('Could not get assets') }

	for key, account in assets.accounts {
		println('${term.white('Account: ')} ${term.bright_blue(term.bold(account.account_type))}')
		println('${term.white('Balance: ')} ${term.bright_yellow(term.bold(account.usdt_balance))}')
		println('${term.white('--------------------------')}')
	}
}
