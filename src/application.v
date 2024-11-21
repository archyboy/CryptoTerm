module application

import exchanges.bybit
import userstuff
import os
import pages
import time
import config
import term

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

pub fn (mut app App) run(autologin bool) ! {
	term.clear()
	println('Welcome to ${app.config.app_name} ${app.config.app_version} ${term.cyan('Login time:')} ${term.cyan(time.now().str())}')
	// app.exchange.demo_mode = demo_mode
	app.user.autologin.autologin = autologin

	app.user.login('') or {
		println('Could not run the login prompt because: ${err}')
		app.user.login('')!
	}

	os.system('clear')
	// Gets local timestamp string
	// local_timestamp_str := time.now().unix()

	// Sets the right info based on App.mode and App.exchange
	match app.exchange.name {
		'bybit' {
			app.exchange = app.exchange.initialize()! // Initialize the exchange object for ByBit
		}
		'mexc' {
			app.exchange = app.exchange.initialize()! // Initialize the exchange object for Mexc
		}
		else {
			println('Unknown exchange')
		}
	}
	app.mainpages()!
}

// The main menu
pub fn (mut app App) main_menu() string {
	mut demomode_msg := ''
	if app.exchange.demo_mode {
		demomode_msg = term.gray(term.bold('(demo mode)'))
	}

	mut autologin_msg := ''
	app.user.autologin.autologin = true
	// println(app.user.autologin.autologin)
	if app.user.autologin.autologin {
		autologin_msg = term.gray(term.bold('(autologin)'))
	}

	println('${app.exchange.description} ${autologin_msg} ${demomode_msg}')
	// println(exchange.description)
	mut menu := map[string]string{}
	menu['W'] = 'allet'
	menu['O'] = 'wned coins'
	menu['M'] = 'arket'
	menu['N'] = 'ew coins'
	menu['B'] = 'uy'
	menu['S'] = 'ell'
	menu['A'] = 'dvises'
	menu['R'] = 'obot AI'
	menu['C'] = 'onfig'
	menu['SW'] = 'itch mode'
	menu['SY'] = 'ystem crash'
	menu['LO'] = 'og out'
	menu['Q'] = 'uit'

	for menu_key, menu_text in menu {
		menu[menu_key] = '(${term.yellow(menu_key)})${menu_text}'
	}

	mut choice := ''
	// Looping out the menu
	for menu_key, menu_text in menu {
		if choice == '' && choice != menu_key { // Looping as long as choice not in map
			// os.system('clear')
			for key, text in menu {
				println(text)
			}
		} else {
			break
		}
		choice = os.input('Choose action ${app.user.username[0].ascii_str().to_upper()}${app.user.username[1..app.user.username.len]}: ') // Waiting for user input
	}
	return choice.to_upper()
}

// Matching the users menu choice
pub fn (mut app App) mainpages() ! {
	term.clear()
	match app.main_menu() {
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
			pages.buy_coins(mut app.exchange)!
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
		'SY' {
			println('Simulating a panic attack')
			print_backtrace()
		}
		'LO' {
			// app = App{} // Clearing all app data including userdata for logout
			app.user.autologin.autologin = false
			println('Logged out!')
			// app.user.login('Logged out')!
		}
		'Q' {
			term_width, term_height := term.get_terminal_size()
			term.set_cursor_position(x: term_width / 2, y: term_height / 2)
			println('\nExiting...Bye Bye!!')
			exit(0)
		}
		else {
			println('\nUnknown option')
		}
	}
	os.input('\nPress ENTER to continue ').to_upper()
	app.run(app.user.autologin.autologin)!
}
