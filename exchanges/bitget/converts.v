module bitget

pub fn (exchange Exchange) to_params_str(params map[string]string) string {
	// println(params)
	mut params_str := ''
	for params_key, params_value in params {
		params_str += '${params_key}=${params_value}&'
	}
	params_str = params_str.trim_right('&')

	return params_str
}
