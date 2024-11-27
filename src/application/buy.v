module application

import os
import exchanges.bitget
import json

pub fn (app App) buy_coins(mut exchange bitget.Exchange) ! {
	list_coins()
	// println(exchange)

	match os.input('Choose coin (R)eturn: ').to_upper() {
		'BTC' {
			params := exchange.get_params_place_order()

			println(params)

			println('Trading BitCoin')
			resp := exchange.execute('POST'.to_upper(), '/api/v2/mix/order/place-order',
				json.encode(params)) or {
				println(err)
				return
			}
			println(resp)
		}
		'DOGE' {
			println('Trading DogeCoin')
		}
		'R' {
			return
		}
		else {
			println('Sorry.We dont have that coin!')
			app.buy_coins(mut exchange)!
		}
	}
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
