module bitget

pub fn (exchange Exchange) get_params_place_order_demo() map[string]string {
	place_order_params := {
		'symbol':                 'SETHSUSDT'
		'productType':            'susdt-futures'
		'marginMode':             'isolated'
		'marginCoin':             'SUSDT'
		'size':                   '1.5'
		'price':                  '3377'
		'side':                   'buy'
		'tradeSide':              'open'
		'orderType':              'limit'
		'force':                  'gtc'
		'clientOid':              '12121212122'
		'reduceOnly':             'NO'
		'presetStopSurplusPrice': '2300'
		'presetStopLossPrice':    '1800'
	}
	return place_order_params
}

pub fn (exchange Exchange) get_params_place_order() map[string]string {
	place_order_params := {
		'symbol':      'ETHUSDT'
		'productType': 'USDT-FUTURES'
		'marginMode':  'isolated'
		'marginCoin':  'USDT'
		'size':        '0.1'
		'price':       '2000'
		'side':        'sell'
		'tradeSide':   'open'
		'orderType':   'limit'
		'force':       'gtc'
		'clientOid':   '121211212122'
	}
	return place_order_params
}

pub fn (exchange Exchange) get_params_assets() map[string]string {
	assets_params := {
		'symbol':                 'SETHSUSDT'
		'productType':            'susdt-futures'
		'marginMode':             'isolated'
		'marginCoin':             'SUSDT'
		'size':                   '1.5'
		'price':                  '3377'
		'side':                   'buy'
		'tradeSide':              'open'
		'orderType':              'limit'
		'force':                  'gtc'
		'clientOid':              '12121212122'
		'reduceOnly':             'NO'
		'presetStopSurplusPrice': '2300'
		'presetStopLossPrice':    '1800'
	}
	return assets_params
}
