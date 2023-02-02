module main

import time
import vxml

[heap]
struct FeedItem {
	url         string
	title       string
	description string
	content     string
	author      string
	pub_date    time.Time
}

fn get_feed_items_from_node(node &vxml.Node) []&FeedItem {
	items := get_rss_feed_items(node)

	if items.len > 0 {
		return items
	} else {
		return get_atom_feed_items(node)
	}
}

fn (r &FeedItem) preview() string {
	title := if r.title != '' { r.title } else { '...' }
	description := if r.description != '' { r.description } else { '...' }
	content := if r.content != '' { r.content } else { description }

	return 'URL: ${r.url}\n\n${title}\n\n${content}'
}

fn get_text_or_cdata(item &vxml.Node) string {
	content := if item.get_text() != '' {
		item.get_text()
	} else {
		item.get_cdata()
	}

	return decode_html_char_codes(content.trim_space())
}

fn get_tag_text_from_item(item &vxml.Node, tag_name string) ?string {
	link_el := item.get_element_by_tag_name(tag_name) or { return none }

	return get_text_or_cdata(link_el)
}
