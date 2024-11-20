module application

import exchanges.bybit
import userstuff
import os
import pages
import menus
import time
import config

pub struct App {
pub mut:
	exchange bybit.Exchange
	user     userstuff.User
	config   config.Config
}

// pub fn test(mut text string) {
// 	text = 'New text!'
// 	println(text)
// }

pub fn (mut app App) run(autologin bool, demo_mode bool) ! {
	app.exchange.demo_mode = demo_mode
	app.user.autologin.autologin = autologin
	app.user.login('') or {
		println('Could not run the login prompt because: ${err}')
		app.user.login('')!
	}

	os.system('clear')
	// Gets local timestamp string
	local_timestamp_str := time.now().unix()
	local_time_str := time.now()
	println(time.unix(local_timestamp_str))
	println('Welcome to ${app.config.app_name} ${app.config.app_version} (Login time: ${local_time_str})')

	// Sets the right info based on App.mode and App.exchange
	match app.exchange.name {
		'bybit' {
			app.exchange = app.exchange.initialize(demo_mode)! // Initialize the exchange object for ByBit
		}
		'mexc' {
			app.exchange = app.exchange.initialize(demo_mode)! // Initialize the exchange object for Mexc
		}
		else {
			println('Unknown exchange')
		}
	}
	app.mainpages()!
}

// Matching the users menu choice

pub fn (mut app App) mainpages() ! {
	match menus.main_menu(app.user) {
		'W' {
			// livewallet.print_api_req_info(exchange)
			// livewallet.extras(exchange)
			pages.live_wallet(mut app.exchange) or { println(err) }
		}
		'O' {
			println('\nOwned coins')
		}
		'M' {
			println('\nMarket today')
			println(app.exchange)
		}
		'N' {
			println('\nNew coins')
		}
		'B' {
			println('\nBuying')
			pages.buy_coins(app.exchange)
		}
		'S' {
			println('\nSelling Spot')
		}
		'A' {
			println('\nAdvises & Suggestions')
		}
		'R' {
			println('\nRobot AI')
		}
		'C' {
			println('Config')
			println(app)

			// goto start
		}
		'SW' {
			if app.exchange.demo_mode == false {
				app.exchange.demo_mode = true
			} else {
				app.exchange.demo_mode = false
			}
		}
		'SC' {
			panic('Big error!! System crash!')
		}
		'LO' {
			// app = App{} // Clearing all app data including userdata for logout
			app.user.autologin.autologin = false
			// app.user.login('Logged out')!
			app.run(app.user.autologin.autologin, app.exchange.demo_mode)!
		}
		'Q' {
			println('\nExiting...Bye Bye!!')
			exit(0)
		}
		else {
			println('\nUnknown option')
		}
	}
	os.input('\nPress ENTER to continue ').to_upper()
	app.mainpages()!
}
