module main

import time

struct FeedItem {
	url         string
	title       string
	description string
	author      string
	pub_date    time.Time
}

fn (r &FeedItem) preview() string {
	title := if r.title != '' { r.title } else { '...' }
	description := if r.description != '' { r.description } else { '...' }

	return 'URL: ${r.url}\n\n${title}\n\n${description}'
}
