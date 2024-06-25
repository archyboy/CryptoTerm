module bybit

import net.http

pub struct App {
pub mut:
	exchange    string
	demo_mode   bool
	registered  bool
	time_resp   http.Response
	credentials Credentials
	request     Request
}

pub struct Credentials {
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

pub fn initialize(demo_mode bool) !App {
	// Initializing Credential object
	mut credentials := Credentials{}
	// Initializing Request object
	mut request := Request{}
	// Initializing App object
	mut app := App{
		exchange: 'bybit'
		// demo_mode: true
	}
	// println(app)
	// println('App demo mode: ${app.demo_mode}')
	// if app.demo_mode == false {
	//	println('Warning....Accounts with real assets in use. Be Cautious! (SW)itch mode?')	
	//} else {
	//	println("This is a DEMO account! It's safe to take risk!! (SW)itch mode?")
	//}

	request.endpoint = '/v5/account/wallet-balance'
	request.params = 'accountType=UNIFIED&coin=USDT'

	if demo_mode {
		request.url = 'https://api-demo.bybit.com'
		credentials.api_key = 'R0sYHvih669veiXRne'
		credentials.secret_key = 'rLr0eZM3ZMMPQfPnZTh7TPihJ6bf48ypRTmb'
	} else {
		request.url = 'https://api.bybit.com'
		credentials.api_key = 'Z6rCbRr3rE8xFuVzxa'
		credentials.secret_key = '7OFJvFglJ6hkHfOMRRmOHP1KkOzCq2YC3OqU'
	}
	app.request = request
	app.credentials = credentials

	return app
}
