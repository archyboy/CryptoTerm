module main

// Exchange modules to import
import exchanges.bitget
import exchanges.bybit

// Main system imports
import config
import application
import userstuff

// Vlib libraries imports	
import os



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
}
