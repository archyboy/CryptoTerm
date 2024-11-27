module bitget

//-------------------------------- IMPORTS ----------------------------
import net.http
import json
import time
import crypto.sha256
import crypto.hmac
import term
import encoding.base64

//-------------------------------- STRUCTS --------------------------------
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
	code         string   @[json: code]
	msg          string   @[json: msg]
	request_time int      @[json: requestTime]
	data         TimeData @[json: data]
}

pub struct TimeData {
	server_time string @[json: serverTime]
}

//-------------------------------- METHODS -----------------------------------

pub fn (mut exchange Exchange) initialize() !Exchange {
	exchange.name = 'bitget'

	if exchange.demo_mode {
		exchange.description = 'Exchange is ${term.bold('BitGet Demo')}'
		exchange.request.url = ''
		exchange.credentials.api_key = ''
		exchange.credentials.secret_key = ''
	} else {
		exchange.description = 'Exchange is ${term.bold('BitGet')}'
		exchange.request.url = 'https://api.bitget.com'
		exchange.credentials.api_key = 'bg_24cde584f28c63dfefcba222ae122112'
		exchange.credentials.secret_key = 'f20503dd2829ad5eb5fdb0a4ee5cfcfc56ca0d1e1903dd05fa6803b9ae00c316'
	}
	return exchange
}

//-------------------------------- get_time_resp ----------------------------------

// Get time response object from server
pub fn (mut exchange Exchange) get_time_resp() !http.Response {
	time_resp := http.get('${exchange.request.url}/api/v2/public/time') or {
		return error('Could not GET time response')
	}
	return time_resp
}

//-------------------------------- execute() ---------------------------------------

// Execute the request to server
pub fn (mut exchange Exchange) execute(method string, endpoint string, params string) !http.Response {
	exchange.request.url = 'https://api.bitget.com'
	println(exchange.request.url)
	// exchange.request.endpoint = endpoint
	// exchange.request.params = params

	// println('PARAMS: ' + params)
	http_resp := exchange.get_time_resp()!
	// println(http_resp.body)

	time_resp := json.decode(TimeResponse, http_resp.body) or { return err }
	println(http_resp.body)

	params_for_signature_str := '${time_resp.data.server_time}${method}${endpoint}${params}'.trim(' ')
	println('Endpoint' + endpoint)
	println('\nPARAMS for signature: ' + params_for_signature_str + '\n')

	mut signature_array := []u8{}
	signature_array << hmac.new(exchange.credentials.secret_key.bytes(), params_for_signature_str.bytes(),
		sha256.sum, sha256.block_size)

	signature_base64_str := base64.encode(signature_array)

	println('Signature: ${signature_array}')
	println('Signature_base64_hash: ' + signature_base64_str)
	println('')

	mut api_req := http.new_request(http.Method.get, '${exchange.request.url}${endpoint}${params}',
		'')

	api_req.add_header(http.CommonHeader.accept, 'application/json')
	api_req.header.add_custom('ACCESS-KEY', exchange.credentials.api_key)!
	api_req.header.add_custom('ACCESS-SIGN', signature_base64_str.str())!
	api_req.header.add_custom('ACCESS-TIMESTAMP', time_resp.data.server_time.str())!
	api_req.header.add_custom('ACCESS-PASSPHRASE', 'xxxxxxxxx')!

	println(api_req)

	api_resp := api_req.do() or {
		return error('Could not execute request to API. Check your URL(endpoint/params etc )')
	}
	// println(api_resp)
	// println(time_resp.time)
	// println(exchange.request.url)
	// println(exchange.request.endpoint)
	// println(exchange.request.params)

	return api_resp
}

//-------------------------------- announcements() -------------------------------------

pub fn (mut exchange Exchange) announcements() ! {
	query_params := {
		'language': 'en_US'
	}
	mut api_resp := exchange.execute('POST'.to_upper(), '/api/v2/public/annoucements',
		exchange.to_params_str(query_params))!
	println(api_resp)
}
