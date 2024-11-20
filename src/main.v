module main

import exchanges.bybit
import userstuff
import application

fn main() {
	mut user := userstuff.User{}
	mut exchange := bybit.Exchange{}

	mut app := application.App{
		exchange: exchange.initialize(true)!
		config:   application.Config{
			autologin: application.AutoLogin{}
		}
		user:     user.login('Welcome to CryptoTerm v.0.1') or {
			println('Could not run the login prompt because: ${err}')
			user.login('')!
		}
	}
	app.run() or { println('Obs...: ${err}') }
}
