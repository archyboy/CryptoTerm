module bitget

//-------------------------------- IMPORTS ----------------------------
import net.http
import json
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

// pub enum Methods {
// 	get = 'GET'
// 	post = 'POST'
// }

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

pub fn (mut exchange Exchange) execute(method string, endpoint string, query_string string, body string) !http.Response {
	// println('PARAMS: ' + params)
	// exchange.request.url = 'https://api.bitget.com'
	// println(exchange.request.url)
	// exchange.request.endpoint = endpoint
	// exchange.request.params = params

	// println('PARAMS: ' + params)
	http_resp := exchange.get_time_resp()!
	// println(http_resp.body)

	time_resp := json.decode(TimeResponse, http_resp.body) or { return err }
	// println(http_resp.body)

	mut params_for_signature_str := ''
	mut full_request_url := ''

	if query_string.len <= 0 {
		print('NO querystring:  ${query_string}')
		params_for_signature_str = (time_resp.data.server_time + method + endpoint + body).trim(' ')
		full_request_url = (exchange.request.url + endpoint).trim(' ')
	} else {
		print('YES querystring: ${query_string}')
		params_for_signature_str = (time_resp.data.server_time + method + endpoint + '?' +
			query_string).trim(' ')
		full_request_url = (exchange.request.url + endpoint + '?' + query_string).trim(' ')
	}

	// println('\nPARAMS for signature: ' + params_for_signature_str + '\n')

	//# _________________________________________________________________________________________________________________
	//# Making HMAC signature and pushing it into an []u8 array as bytes() and and base64 encodes it for the API server
	mut signature_array := []u8{}
	signature_array << hmac.new(exchange.credentials.secret_key.bytes(), params_for_signature_str.bytes(),
		sha256.sum, sha256.block_size)
	signature_base64_str := base64.encode(signature_array)

	// println('Signature: ${signature_array.str()}')
	// println('Signature_base64_hash: ' + signature_base64_str)

	// println('Full Request URL: ' + full_request_url)

	mut api_req := http.Request{}
	if method.to_upper() == 'GET' {
		println('Method: GET')
		api_req = http.new_request(http.Method.get, full_request_url, '')
	}
	if method.to_upper() == 'POST' {
		println('Method: POST')
		api_req = http.new_request(http.Method.post, full_request_url, body)
	}

	api_req.header.add_custom('Content-Type', 'application/json')!
	api_req.header.add_custom('ACCESS-KEY', exchange.credentials.api_key)!
	api_req.header.add_custom('ACCESS-SIGN', signature_base64_str.str())!
	api_req.header.add_custom('ACCESS-TIMESTAMP', time_resp.data.server_time.str())!
	api_req.header.add_custom('ACCESS-PASSPHRASE', 'RabbaGast78')!

	// println(api_req)

	api_resp := api_req.do() or {
		return error('Could not execute request to API. Check your URL(endpoint/params etc )')
	}
	// println(api_resp)

	return api_resp
}
