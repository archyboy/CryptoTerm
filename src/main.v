module main

import sandbox
import exchanges.bitget
import userstuff
import application
import os
import config
import exchanges.bybit

fn main() {
	// println(test('This is the comment!'))

	mut user := userstuff.User{}
	// user.autologin.autologin = true

	// mut exchange := bybit.Exchange{
	// 	demo_mode: false
	// }

	mut exchange := bitget.Exchange{
		demo_mode: false
	}

	mut app := application.App{
		exchange: exchange.initialize()!
		config:   config.Config{
			app_name:    'CryptoTerm'
			app_version: '0.0.1'
		}
	}

	app.run(true) or { println('Obs...: ${err}') }
	// test('Some text')
}
