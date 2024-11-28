module application

import os
import exchanges.bitget
import json
import fancystuff

pub fn (app App) buy_coins(mut exchange bitget.Exchange) ! {
	list_coins()
	// println(exchange)

	match os.input('Choose coin (R)eturn: ').to_upper() {
		'BTC' {
			println('Trading BitCoin')

			mut map_params := app.exchange.get_params_place_order()
			size := os.input('Quantity: ')
			map_params['size'] = size
			println('Only ${map_params['size']} units.. Okkkiiieeey!!')
			// println(map_params)

			if os.input('Sure you wanna trade for ${map_params['size']} (Y/N)?') == ('y') {
				sorted_map := fancystuff.sort_map_string_string(map_params) or {
					return error('Sorry...Could not sort the map')
				}

				json_params := json.encode(sorted_map)
				// println(json_params)

				query_string := app.exchange.params_to_query_str(map_params)

				resp := exchange.execute('POST'.to_upper(), '/api/v2/mix/order/place-order',
					'', json_params) or {
					println(err)
					return
				}
				println(resp)
			} else {
				println('OKAY!! No loosing money today :|)')
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
