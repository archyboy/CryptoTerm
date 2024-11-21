module pages

import exchanges.bybit
import time
import net.http
import x.json2
import crypto.sha256
import crypto.hmac
import disco07.colorize
import strconv

pub fn live_wallet(mut exchange bybit.Exchange) !bool {
	exchange.execute('/v5/account/wallet-balance', 'accountType=UNIFIED&coin=USDT')!

	// println(exchange)
	// println(exchange.credentials.api_key)
	mut last_wallet_total_balance := 0.0000
	mut total_profit_and_loss := 0.0000

	for last_wallet_total_balance >= 0.0000 {
		exchange.time_resp = http.get('${exchange.request.url}/v5/market/time') or {
			error('Could not GET time')
			exit(0)
		}
		// println(exchange.time_resp)
		server_time := json2.raw_decode(exchange.time_resp.body) or {
			println(err)
			exit(0)
		}

		server_time_map := server_time.as_map()
		// println(server_time_map)

		server_timestamp_str := server_time_map['time'].str()
		// println(server_timestamp_str)

		params_for_signature_str := '${server_timestamp_str}${exchange.credentials.api_key}5000${exchange.request.params}'
		// println(params_for_signature_str)

		signature := hmac.new(exchange.credentials.secret_key.bytes(), params_for_signature_str.bytes(),
			sha256.sum, sha256.block_size).hex()

		mut api_req := http.new_request(http.Method.get, '${exchange.request.url}${exchange.request.endpoint}?${exchange.request.params}',
			'')
		api_req.add_header(http.CommonHeader.accept, 'application/json')
		api_req.header.add_custom('X-BAPI-API-KEY', exchange.credentials.api_key)!
		api_req.header.add_custom('X-BAPI-SIGN', signature.str())!
		api_req.header.add_custom('X-BAPI-SIGN-TYPE', '2')!
		api_req.header.add_custom('X-BAPI-TIMESTAMP', server_timestamp_str)!
		api_req.header.add_custom('X-BAPI-RECV-WINDOW', '5000')!

		api_resp := api_req.do() or {
			return error('Could not execute request to API. Check your URL(endpoint/params etc )')
		}

		// println(api_req)
		// println(api_resp)
		// api_resp_body := api_resp.body

		if api_resp.body != '' {
			body_any := json2.raw_decode(api_resp.body) or {
				error('Could not decode JSON fra API')
				exit(0)
			}
			// println(body_any)
			body_map := body_any.as_map()
			body_map_result := body_map['result'].as_map()
			body_map_result_list := body_map_result['list'].as_map()
			body_map_result_list_0 := body_map_result_list['0'].as_map()

			wallet_total_balance := body_map_result_list_0['totalEquity'].f64()

			if last_wallet_total_balance > 0.0000 {
				println('')
				if wallet_total_balance > last_wallet_total_balance {
					total_profit_and_loss += (wallet_total_balance - last_wallet_total_balance)
					print(colorize.color('<green>UP    <stop>'))
					print('+${strconv.f64_to_str_lnd1(wallet_total_balance - last_wallet_total_balance,
						8)} =${colorize.color('<green>')} ${strconv.f64_to_str_lnd1(wallet_total_balance,
						4)} ${colorize.color('<stop>')}')
				} else if wallet_total_balance < last_wallet_total_balance {
					total_profit_and_loss -= (last_wallet_total_balance - wallet_total_balance)
					print(colorize.color('<red>DOWN  <stop>'))
					print('-${strconv.f64_to_str_lnd1(last_wallet_total_balance - wallet_total_balance,
						8)} =${colorize.color('<red>')} ${strconv.f64_to_str_lnd1(wallet_total_balance,
						4)} ${colorize.color('<stop>')}')
				} else {
					print(colorize.color('<blue>EQUAL <stop>'))
					print('=${strconv.f64_to_str_lnd1(wallet_total_balance - last_wallet_total_balance,
						8)} =${colorize.color('<blue>')} ${strconv.f64_to_str_lnd1(last_wallet_total_balance,
						4)} ${colorize.color('<stop>')}')
				}
				print('(P&L: ${strconv.f64_to_str_lnd1(total_profit_and_loss, 2)} USD)')
			} else {
				wallet_total_balance_str := strconv.f64_to_str_lnd1(wallet_total_balance,
					4)
				println(colorize.color('<yellow>'))
				println('\nWallet Balance: \e[1m${wallet_total_balance_str} USD \e[0m')
				println(colorize.color('<stop>'))
			}
			last_wallet_total_balance = wallet_total_balance
			time.sleep(time.second * 1)
		}
	}
	return true
}

pub fn print_api_req_info(a bybit.Exchange) {
	// println(os.execute(command).output)
	println('Demo mode: ${a.demo_mode.str()}')
	println('Api-Key: ${a.credentials.api_key}')
	println('URL: ${a.request.url}')
	println('Endpoint: ${a.request.endpoint}')
	println('Params: ${a.request.params}')
}

pub fn extras(x bybit.Exchange) {
	println(x)
}
