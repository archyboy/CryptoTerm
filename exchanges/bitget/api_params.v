module bitget

import maps
import os.notify
import sokol.f
import v.reflection

// pub fn (exchange Exchange) get_params_place_order_demo() map[string]string {
// 	place_order_params := {
// 		'symbol':                 'SETHSUSDT'
// 		'productType':            'susdt-futures'
// 		'marginMode':             'isolated'
// 		'marginCoin':             'SUSDT'
// 		'size':                   '0.1'
// 		'price':                  '3377'
// 		'side':                   'buy'
// 		'tradeSide':              'open'
// 		'orderType':              'limit'
// 		'force':                  'gtc'
// 		'clientOid':              '12121212122'
// 		'reduceOnly':             'NO'
// 		'presetStopSurplusPrice': '2300'
// 		'presetStopLossPrice':    '1800'
// 	}
// 	return place_order_params
// }

pub fn (exchange Exchange) get_params_place_order() map[string]string {
	place_order_params := {
		'symbol':      'DOGEUSDT'
		'productType': 'USDT-FUTURES'
		'marginMode':  'isolated'
		'marginCoin':  'USDT'
		'size':        '1.00'
		'price':       '0.20'
		'side':        'buy'
		'tradeSide':   'open'
		'orderType':   'limit'
		//'force':       'gtc'
		//'clientOid':   '9542042255'
	}
	return place_order_params
}

pub fn (exchange Exchange) get_params_assets() ?map[string]string {
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
	if assets_params['symbol'] != 'SETHSUSDT' {
		return none
	}
	return assets_params
}
