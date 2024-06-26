module main

import os
import exchanges.bybit
import page.livewallet
import menus.mainmenu

fn main() {
	mut exchange := 'bybit'
	mut demo_mode := false

	// Testline for windows git commit

	// mut app := bybit.App{}
	unsafe {
		start:
		os.system('clear')
		// Initialize the app object for ByBit
		mut app := bybit.initialize(demo_mode)!

		// Sets the right info based on App.mode and App.exchange
		match exchange {
			'bybit' {
				if !app.registered {
					app = bybit.initialize(demo_mode)!
				}
				app.registered = true
				app.exchange = exchange
				app.demo_mode = demo_mode
			}
			'mybit' {
				// app = bybit.setup()!
				// app.exchange = exchange
			}
			else {
				println('Unknown exchange')
			}
		}

		// Matching the users menu choice
		match mainmenu.run() {
			'W' {
				// livewallet.print_api_req_info(app)
				// livewallet.extras(app)
				livewallet.run(mut app) or { println(err) }
			}
			'O' {
				println('\nOwned coins')
			}
			'M' {
				println('\nMarket today')
				println(app)
			}
			'N' {
				println('\nNew coins')
			}
			'B' {
				println('\nBuying Spot')
				list_coins()
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
		// Gets local timestamp string
		// local_timestamp_str := time.now().unix_milli().str()
		// local_time_str := time.now()
		// println('Local time: ${local_time_str} (${local_timestamp_str})')
	}
}
