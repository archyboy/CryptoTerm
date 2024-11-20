module application

import exchanges.bybit
import userstuff
import os
import pages
import menus
import time

pub struct App {
pub mut:
	exchange bybit.Exchange
	config   Config
	user     userstuff.User
}

pub struct Config {
pub mut:
	autologin AutoLogin
}

pub struct AutoLogin {
pub mut:
	autologin        bool   = true
	username_default string = 'archy'
	password_default string = 'xzxz'
}

pub fn (mut app App) run() ! {
	mut demo_mode := true
	app.exchange.demo_mode = demo_mode

	start:
	unsafe {
		os.system('clear')
		// Gets local timestamp string
		local_timestamp_str := time.now().unix_milli().str()
		local_time_str := time.now()
		println('Local time: ${local_time_str} (${local_timestamp_str})')

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

		// Matching the users menu choice

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
				if demo_mode == false {
					demo_mode = true
				} else {
					demo_mode = false
				}
				goto start
			}
			'SC' {
				return error('Big error!! System crash!')
			}
			'LO' {
				app = App{} // Clearing all app data including userdata for logout
				app.user.login('Logged out: ${app.str()}')!
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
		goto start
	}
}
