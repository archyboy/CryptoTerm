module application

import os
import exchanges.bitget
import fancystuff
import json
import term
import themes

pub fn (mut app App) buy_coins() ! {
	list_coins()

	println('What do you want to trade today? ${term.bright_bg_black('[ENTER]')} for defaults!')
	mut map_params := app.exchange.get_params_place_order()
	default_symbol := 'DOGEUSDT'

	mut symbol := os.input('Symbol ${term.gray('[${default_symbol}]:')}').to_upper()
	mut price := os.input('Price: ').to_upper()
	mut size := os.input('Quantity: ').to_upper()

	if symbol != '' {
		map_params['symbol'] = symbol
	} else {
		symbol = 'DOGEUSDT'
	}
	if price != '' {
		map_params['price'] = price
	} else {
		price = '0.10'
	}
	if size != '' {
		map_params['size'] = size
	} else {
		size = '50'
	}

	map_params['symbol'] = symbol
	map_params['price'] = price
	map_params['size'] = size

	order_fee_percent := 0.04
	order_cost := (price.f64() * size.f64())
	total_fee := ((order_cost * order_fee_percent) / 100)
	total_order_cost := order_cost + total_fee

	// println(map_params)
	println(term.clear())
	println(term.red(term.bold('You are about to place a ${map_params['productType']} order!! Double check details:')))
	println(term.white('Product: ' + map_params['productType'].to_upper()))
	println(term.white('Symbol: ' + map_params['symbol'].to_upper()))
	println(term.white('Margin Mode: ' + map_params['marginMode'].to_upper()))
	println(term.white('Order Type: ' + map_params['orderType'].to_upper()))
	// println(term.white('Force: ' + map_params["force"].to_upper()))
	// println(term.white('Client Order ID: ' + map_params["clientOid"].to_upper()))
	println(term.white('Side: ' + map_params['side'].to_upper()))
	println(term.white('Size: ' + map_params['size'].to_upper()))
	println(term.white('Price: ' + map_params['price'].to_upper()))
	println('')

	println(term.green('${map_params['side'].to_upper()} ${map_params['size']} ${map_params['symbol']} as a ${map_params['orderType'].to_upper()} order at ${map_params['price']} USTD each'))
	println('${term.bright_blue('\nTotal cost is ${term.bold(total_order_cost.str())}')} ${term.gray('(fee ${order_fee_percent.str()}% = ${total_fee.str()} usdt')}) ')
	for {
		match os.input('\nAre you 100% sure (Y/N)?').to_upper() {
			'Y' {
				sorted_map := fancystuff.sort_map_string_string(map_params) or {
					return error('\nSorry...Could not sort the map')
				}

				json_params := json.encode(sorted_map)
				// println(json_params)
				query_string := app.exchange.params_to_query_str(map_params)

				app.exchange.time_resp = app.exchange.execute('POST'.to_upper(), '/api/v2/mix/order/place-order',
					'', json_params) or {
					println(err)
					return
				}
				println('Response status message: ' + app.exchange.time_resp.status_msg.str())
				println('Response status code: ' + app.exchange.time_resp.status_code.str())

				if app.exchange.time_resp.status_code == 200
					&& app.exchange.time_resp.status_msg == 'OK' {
					println('Order filled successfully')
					println('${app.exchange.time_resp}')
					println(term.rapid_blink('\nGood luck with the ${map_params['productType']}'))
					term.reset('')
				} else {
					println('\nSorry..Could NOT fill the order because: ${app.exchange.time_resp}')
				}
			}
			'N' {
				println('\nOKAY!! No loosing money today :|)')
				break
			}
			else {
				continue
				// app.buy_coins()!
			}
		}
	}
}
