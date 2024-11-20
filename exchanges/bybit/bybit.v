module bybit

import net.http

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
}

pub fn (mut exchange Exchange) initialize(demo_mode bool) !Exchange {
	exchange.name = 'bybit'

	if demo_mode {
		exchange.description = 'Exchange is ByBit (Demo Mode)'
		exchange.request.url = 'https://api-demo.bybit.com'
		exchange.credentials.api_key = '2SEsaFL9sBXpb2c1so'
		exchange.credentials.secret_key = 'PC4Ae3SVqX4kMhSTbqf2lgK8gAKjB0Y5wZLE'
	} else {
		exchange.description = 'Exchange is ByBit'
		exchange.request.url = 'https://api.bybit.com'
		exchange.credentials.api_key = 'tDl8uZJiHBvzrd5aWD'
		exchange.credentials.secret_key = 'dLgNISOkIB5plqQLtup7k0PvRT9mPm8YOJmu'
	}
	return exchange
}

pub fn (mut exchange Exchange) execute(endpoint string, params string) string {
	exchange.request.endpoint = endpoint
	exchange.request.params = params

	result := 'Json '
	return result
}
