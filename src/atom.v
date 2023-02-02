module main

import vxml

fn create_feed_item_from_atom_node(node &vxml.Node) &FeedItem {
	title := get_tag_text_from_item(node, 'title') or { '' }
	url := get_tag_text_from_item(node, 'link') or { '' }
	description := get_tag_text_from_item(node, 'summary') or { '' }
	content := get_tag_text_from_item(node, 'content') or { '' }

	return &FeedItem{
		title: title
		url: url
		description: prepare_text(description)
		content: prepare_text(content)
	}
}

fn get_atom_feed_items(root &vxml.Node) []&FeedItem {
	items := root.get_elements_by_tag_name('entry')

	return items.map(create_feed_item_from_atom_node(it))
}
