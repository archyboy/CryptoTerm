module application

import os
import exchanges.bitget
import fancystuff
import json
import term

pub fn (app App) buy_coins(mut exchange bitget.Exchange) ! {
	// list_coins()

	println('What do you want to trade today?')
	mut map_params := app.exchange.get_params_place_order()
	default_symbol := 'DOGEUSDT'
	symbol := os.input('Symbol ${term.gray('[BTCUSDT]:')} ')
	price := os.input('Price: ')
	size := os.input('Quantity: ')
	map_params['symbol'] = symbol
	map_params['size'] = size
	map_params['price'] = price

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

	println(term.white('${map_params['size']} ${map_params['symbol']} at USTD: ${map_params['price']} each'))

	if os.input('Are you 100% sure (Y/N)?') == ('y') {
		sorted_map := fancystuff.sort_map_string_string(map_params) or {
			return error('Sorry...Could not sort the map')
		}

		json_params := json.encode(sorted_map)
		// println(json_params)
		query_string := app.exchange.params_to_query_str(map_params)

		resp := exchange.execute('POST'.to_upper(), '/api/v2/mix/order/place-order', '',
			json_params) or {
			println(err)
			return
		}
		println('Response status message: ' + resp.status_msg.str())
		println('Response status code: ' + resp.status_code.str())
		if resp.status_code == 200 && resp.status_msg == 'OK' {
			println(term.rapid_blink('Good luck with the ${map_params['productType']}'))
		} else {
			println('Sorry..Something went wrong. Could NOT fill the order!')
		}
	} else {
		println('OKAY!! No loosing money today :|)')
	}
	println(term.reset(''))
}

pub fn list_coins() {
	mut coins := []string{}
	coins << 'BTC'
	coins << 'ETH'
	coins << 'DOGE'
	coins << 'return'

	for text in coins {
		println(text)
	}
}
