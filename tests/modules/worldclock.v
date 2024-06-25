module worldclock

import time

fn get_world_time(city string) string {
	match city {
		'new york' {
			return time.now().add_seconds(3600).format().str()
		}
		'london' {
			return time.now().add_seconds(3600).format().str()
		}
		'tokyo' {
			return time.now().add_seconds(32400).format().str()
		}
		else {
			return 'City not found'
		}
	}
}
