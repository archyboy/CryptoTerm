module application

import net.http

pub fn (mut app App) get_assets() !http.Response {
	resp := app.exchange.execute('GET', '/api/v2/account/all-account-balance', '')!
	return resp
}

pub fn (mut app App) show_assets(resp http.Response) {
	println('Trading BitCoin')

	println(resp)
}
