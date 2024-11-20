module pages

import exchanges.bybit

pub fn buy_coins(exchange bybit.Exchange) {
	println(exchange)
}

pub fn list_coins() {
	mut coins := []string{}
	coins << 'BTC'
	coins << 'ETH'
	coins << 'DOGE'

	for text in coins {
		println(text)
	}
}
