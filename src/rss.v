module main

import vxml

fn get_tag_text_from_item(item &vxml.Node, tag_name string) ?string {
	link_el := item.get_element_by_tag_name(tag_name) or { return none }

	return get_text_or_cdata(link_el)
}

fn get_text_or_cdata(item &vxml.Node) string {
	content := if item.get_text() != '' {
		item.get_text()
	} else {
		item.get_cdata()
	}

	return decode_html_char_codes(content.trim_space())
}
