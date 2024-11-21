module pages

import exchanges.bybit
import os

pub fn buy_coins(mut exchange bybit.Exchange) ! {
	list_coins()
	println(exchange)

	match os.input('Choose coin (R)eturn: ').to_upper() {
		'BTC' {
			println('Trading BitCoin')
			exchange.execute('/v5/account/wallet-balance', 'accountType=UNIFIED&coin=USDT')!
		}
		'DOGE' {
			println('Trading DogeCoin')
		}
		'R' {
			return
		}
		else {
			println('Sorry.We dont have that coin!')
			buy_coins(mut exchange)!
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
