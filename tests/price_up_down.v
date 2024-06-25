module main

fn main() {
	original_price := 10.33
	current_price := 69501.20

	percentage_change := ((current_price - original_price) / original_price) * 100.0

	if percentage_change > 0 {
		print('The price has gone UP by: ')
	} else if percentage_change < 0 {
		print('The price has gone DOWN by: ')
	} else {
		print('The price is the same: ')
	}
	print(percentage_change.str() + '%')
}
