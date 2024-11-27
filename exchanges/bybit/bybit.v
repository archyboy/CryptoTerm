module bybit

import net.http
// import x.json2
import json
import time
import crypto.sha256
import crypto.hmac
import term

pub struct Exchange {
pub mut:
	name        string
	description string
	demo_mode   bool
	registered  bool
	time_resp   http.Response
	credentials User
	request     Request
}

pub struct User {
pub mut:
	api_key    string
	secret_key string
}

pub struct Request {
pub mut:
	url      string
	endpoint string
	params   string
	recv     int = 5000
}

pub struct TimeResponse {
	ret_code     int    @[json: retCode]
	ret_msg      string @[json: retMsg]
	result       Result
	ret_ext_info map[string]string @[json: retExtInfo]
	time         int               @[json: time]
}

pub struct Result {
	time_second string @[json: timeSecond]
	time_nano   string @[json: timeNano]
}

pub fn testbybit() {
}

pub fn (mut exchange Exchange) initialize() !Exchange {
	exchange.name = 'bybit'

	if exchange.demo_mode {
		exchange.description = 'Exchange is ${term.bold('ByBit')}'
		exchange.request.url = 'https://api-demo.bybit.com'
		exchange.credentials.api_key = '2SEsaFL9sBXpb2c1so'
		exchange.credentials.secret_key = 'PC4Ae3SVqX4kMhSTbqf2lgK8gAKjB0Y5wZLE'
	} else {
		exchange.description = 'Exchange is ByBit'
		exchange.request.url = 'https://api-testnet.bybit.com'
		exchange.credentials.api_key = 'tDl8uZJiHBvzrd5aWD'
		exchange.credentials.secret_key = 'dLgNISOkIB5plqQLtup7k0PvRT9mPm8YOJmu'
	}
	return exchange
}

// Get time response object from server
pub fn (mut exchange Exchange) get_time_resp() !http.Response {
	time_resp := http.get('${exchange.request.url}/v5/market/time') or {
		return error('Could not GET time response')
	}
	return time_resp
}

// Execute the request to server
pub fn (mut exchange Exchange) execute(endpoint string, params string) !http.Response {
	// exchange.request.endpoint = endpoint
	// exchange.request.params = params

	println('PARAMS: ' + params)
	http_resp := exchange.get_time_resp()!
	println(http_resp.body)

	time_resp := json.decode(TimeResponse, http_resp.body) or { return err }

	params_for_signature_str := '${time_resp.result.time_nano[0..13].str()}${exchange.credentials.api_key}${exchange.request.recv}${params}'

	println('PARAMS for signature: ' + params_for_signature_str)

	signature := hmac.new(exchange.credentials.secret_key.bytes(), params_for_signature_str.bytes(),
		sha256.sum, sha256.block_size).hex()

	println(signature)

	println(exchange.request.url)
	mut api_req := http.new_request(http.Method.get, '${exchange.request.url}${endpoint}${params}',
		'')

	println(api_req)

	api_req.add_header(http.CommonHeader.accept, 'application/json')
	api_req.header.add_custom('X-BAPI-API-KEY', exchange.credentials.api_key)!
	api_req.header.add_custom('X-BAPI-SIGN', signature.str())!
	api_req.header.add_custom('X-BAPI-SIGN-TYPE', '2')!
	api_req.header.add_custom('X-BAPI-TIMESTAMP', time_resp.time.str())!
	api_req.header.add_custom('X-BAPI-RECV-WINDOW', '${exchange.request.recv}')!

	api_resp := api_req.do() or {
		return error('Could not execute request to API. Check your URL(endpoint/params etc )')
	}

	println(api_resp)
	// println(time_resp.time)
	// println(exchange.request.url)
	// println(exchange.request.endpoint)
	// println(exchange.request.params)

	return api_resp
}

pub fn (exchange Exchange) to_params_str(params map[string]string) string {
	println(params)
	mut params_str := ''
	for params_key, params_value in params {
		params_str += '${params_key}=${params_value}&'
	}
	params_str = params_str.trim_right('&')

	return params_str
}
