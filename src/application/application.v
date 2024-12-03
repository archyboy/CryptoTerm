module application

import exchanges.bitget
import userstuff
import os
import time
import config
import term
import sandbox
import themes

pub struct App {
pub mut:
	exchange bitget.Exchange
	user     userstuff.User
	config   config.Config
}

// pub fn test(mut text string) {
// 	text = 'New text!'
// 	println(text)
// }

pub fn (mut app App) run(autologin bool) ! {
	term.clear()
	term.set_terminal_title(app.config.app_name + ' ' + app.config.app_version + ' (' +
		app.exchange.name + ')')
	term_width, term_height := term.get_terminal_size()

	// for i := term_height;  i < 0; i-- {
	// 	term.set_cursor_position(x: term_width, y: term_height - (i - 10))
	// 	time.sleep(time.second / 10 )
	//
	// }

	// // app.exchange.demo_mode = demo_mode
	app.user.autologin.autologin = autologin

	app.user.login('') or {
		println('Could not run the login prompt because: ${err}')
		app.user.login('')!
	}

	// Gets local timestamp string
	// local_timestamp_str := time.now().unix()

	// Sets the right info based on App.mode and App.exchange
	match app.exchange.name {
		'bitget' {
			app.exchange = app.exchange.initialize()! // Initialize the exchange object for BitGet
		}
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
	os.execute('clear')
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
	menu['SA'] = 'ndbox'
	menu['AN'] = 'oucements'
	menu['W'] = 'allet'
	menu['LI'] = 've wallet'
	menu['O'] = 'wned coins'
	menu['M'] = 'arket'
	menu['N'] = 'ew coins'
	menu['MO'] = 'Manual Order'
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
		term_width, term_height := term.get_terminal_size()

		if choice == '' && choice != menu_key { // Looping as long as choice not in map
			// term.set_cursor_position(x: term_width % 1 + (0 + 5), y: term_height + (0 + 5))
			println('Welcome to ${app.config.app_name} ${app.config.app_version} ${term.cyan('Login time:')} ${term.cyan(time.now().str())}')

			mut i := 0
			for key, text in menu {
				i++
				// term.set_cursor_position(x: term_width % 1 + (i + 5), y: term_height + (i + 5))
				// time.sleep(time.second / 10)
				println(text)
			}
		} else {
			break
		}
		choice = os.input('Choose action ${app.user.username[0].ascii_str().to_upper()}${app.user.username[1..app.user.username.len]}: ') // Waiting for user input
		println('\n\n')
		term.erase_clear()
	}
	return choice.to_upper()
}

// Matching the users menu choice
pub fn (mut app App) mainpages() ! {
	// theme := themes.Funky

	match app.main_menu() {
		'SA' {
			println('${themes.Funky.warning.colorize('The Sandbox. Have fun, learn and experiment!')}\n')
			sb := sandbox.SandBox{}
			sb.function_optional_return()
		}
		'AN' {
			println('${term.underline(term.yellow('Last announcements'))}\n')
			app.show_announcement() or { println(err) }
		}
		'W' {
			println('${term.underline(term.yellow('All your assets accounts'))} (${term.bold(term.gray(app.exchange.name))})\n')
			app.show_assets() or { println(err) }
		}
		'LI' {
			println('${term.underline(term.yellow('Live wallet'))}\n')
			// livewallet.print_api_req_info(exchange)
			// livewallet.extras(exchange)
			app.live_wallet(mut app.exchange) or { println(err) }
		}
		'O' {
			println('${term.underline(term.yellow('Owned coins'))}\n')
		}
		'M' {
			println('${term.underline(term.yellow('Market today'))}\n')
			list_coins()
		}
		'N' {
			println('${term.underline(term.yellow('New coins'))}\n')
		}
		'MO' {
			println('${term.underline(term.yellow('Manual order'))}\n')
			app.manual_order()!
		}
		'B' {
			println('${term.underline(term.yellow('Buy coins'))}\n')
			app.buy_coins()!
		}
		'S' {
			println('${term.underline(term.yellow('Selling Spot'))}\n')
		}
		'A' {
			println('${term.underline(term.yellow('Advises & Suggestions'))}\n')
		}
		'R' {
			println('${term.underline(term.yellow('Robot AI'))}\n')
		}
		'C' {
			println('${term.underline(term.yellow('Config'))}\n')
			println(app)

			// goto start
		}
		'SW' {
			if app.exchange.demo_mode == false {
				app.exchange.demo_mode = true
				println('You switched to ${term.bright_red(term.bold('Demo Mode :('))}')
			} else {
				app.exchange.demo_mode = false
				println('You switched to ${term.bright_green(term.bold('Real Mode :)'))}')
			}
		}
		'SY' {
			println('Simulating a panic attack\n')
			print_backtrace()
		}
		'LO' {
			// app = App{} // Clearing all app data including userdata for logout
			app.user.autologin.autologin = false
			println('Logged out!')
			// app.user.login('Logged out')!
		}
		'Q' {
			println('\nExiting...Bye Bye!!\n')
			exit(0)
		}
		else {
			println('\nUnknown option\n')
		}
	}
	os.input('\nPress ENTER to continue\n').to_upper()
	app.run(app.user.autologin.autologin)!
}
