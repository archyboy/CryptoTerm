module main

import exchanges.bybit
import userstuff
import application
import os
import term.ui
import strings
import config

fn test(comment string) ?string {
	if comment.len > 0 {
		os.flush()
		os.get_raw_line()
		os.stdin()
		return comment
	}
	return none
}

fn main() {
	// println(test('This is the comment!'))

	mut user := userstuff.User{}
	mut exchange := bybit.Exchange{}

	mut app := application.App{
		exchange: exchange.initialize(true)!
		config:   config.Config{
			app_name:    'CryptoTerm'
			app_version: '0.0.1'
		}
	}

	app.run(true, true) or { println('Obs...: ${err}') }
	// test('Some text')
}
