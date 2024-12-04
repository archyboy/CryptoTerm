module application

import os
import exchanges.bitget
import fancystuff
import json
import term
import themes

pub fn (mut app App) manual_order() ! {
	// list_coins()

	println('What do you want to trade today? ${term.bright_bg_black('[ENTER]')} for defaults!')
	mut map_params := app.exchange.get_params_place_order()

	mut default_product_type := 'USDT-FUTURES'
	mut default_trade_side := 'OPEN'
	mut default_symbol := 'DOGEUSDT'
	mut default_side := 'BUY'
	mut default_order_type := 'LIMIT'
	mut default_price := '0.10'
	mut default_size := '50'

	// if default_side == 'BUY' { default_price = '0.10' } else { default_price = '' }
	mut product_type := ''
	mut trade_side := ''
	mut order_type := ''
	mut side := ''
	mut symbol := ''
	mut price := ''
	mut size := ''

	product_type = os.input('Product type: ${term.gray('[${default_product_type}]:')}').to_upper()
	trade_side = os.input('Product side: ${term.gray('[${default_trade_side}]:')}').to_upper()
	side = os.input('Side: ${term.gray('[${default_side}]:')}').to_upper()
	order_type = os.input('Order type: ${term.gray('[${default_order_type}]:')}').to_upper()
	symbol = os.input('Symbol: ${term.gray('[${default_symbol}]:')}').to_upper()
	size = os.input('Quantity: ').to_upper()

	if product_type != '' {
		map_params['productType'] = product_type
	} else {
		product_type = default_product_type
	}
	if trade_side != '' {
		map_params['tradeSide'] = trade_side
	} else {
		trade_side = default_trade_side
	}
	if symbol != '' {
		map_params['symbol'] = symbol
	} else {
		symbol = default_symbol
	}
	if side != '' {
		map_params['side'] = side
	} else {
		side = default_side
	}
	if order_type != '' {
		map_params['orderType'] = order_type
	} else {
		order_type = default_order_type
	}
	if price != '' {
		map_params['price'] = price
	} else {
		price = default_price
	}
	if size != '' {
		map_params['size'] = size
	} else {
		size = '50'
	}

	if order_type == 'LIMIT' {
		price = os.input('Price: ').to_upper()
	} else {
		price = ''
	}

	map_params['orderType'] = order_type
	map_params['tradeSide'] = trade_side
	map_params['side'] = side
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
				// println('${app.exchange.time_resp}')
				println('\nGood luck with the ${map_params['productType']}')
				term.reset('')
			} else {
				println('\nSorry..Could NOT fill the order because: ${app.exchange.time_resp.body}')
			}
		}
		'N' {
			println('\nOKAY!! No loosing money today :|)')
			return
		}
		else {
			return
		}
	}
}
