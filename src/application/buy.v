module application

import os
import exchanges.bitget

pub fn (app App) buy_coins(mut exchange bitget.Exchange) ! {
	list_coins()
	// println(exchange)

	match os.input('Choose coin (R)eturn: ').to_upper() {
		'BTC' {
			params := {
				'category':  'linear'
				'symbol':    'BTCUSDT'
				'side':      'Buy'
				//"positionIdx": "0",
				'orderType': 'Limit'
				'qty':       '0.0001'
				'price':     '97000'
				//"timeInForce": "GTC",
			}

			println(params)

			println('Trading BitCoin')
			exchange.execute('GET'.to_upper(), '/v5/order/create', exchange.to_params_str(params)) or {
				println(err)
			}
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
