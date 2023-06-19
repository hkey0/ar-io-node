CREATE TABLE bundle_formats (
  id INTEGER PRIMARY KEY,
  format TEXT NOT NULL
);
CREATE TABLE wallets (
  address BLOB PRIMARY KEY,
  public_modulus BLOB
);
CREATE TABLE stable_data_items (
  -- Identity
  id BLOB NOT NULL,
  parent_id BLOB NOT NULL,
  root_transaction_id BLOB NOT NULL,
  height INTEGER NOT NULL,
  block_transaction_index INTEGER NOT NULL,
  signature BLOB NOT NULL,
  anchor BLOB NOT NULL,

  -- Ownership
  owner_address BLOB NOT NULL,
  target BLOB,

  -- Data
  data_offset INTEGER NOT NULL,
  data_size INTEGER NOT NULL,
  content_type TEXT,

  -- Metadata
  tag_count INTEGER NOT NULL,
  indexed_at INTEGER NOT NULL,
  PRIMARY KEY (id)
);
CREATE INDEX stable_data_items_height_block_transaction_index_id_idx ON stable_data_items (height, block_transaction_index, id);
CREATE INDEX stable_data_items_target_height_block_transaction_index_id_idx ON stable_data_items (target, height, block_transaction_index, id);
CREATE INDEX stable_data_items_owner_address_height_block_transaction_index_id_idx ON stable_data_items (owner_address, height, block_transaction_index, id);
CREATE INDEX stable_data_items_parent_id_height_block_transaction_index_id_idx ON stable_data_items (parent_id, height, block_transaction_index, id);
CREATE TABLE tag_names (
  hash BLOB PRIMARY KEY,
  name BLOB NOT NULL
);
CREATE TABLE tag_values (
  hash BLOB PRIMARY KEY,
  value BLOB NOT NULL
);
CREATE TABLE stable_data_item_tags (
  tag_name_hash BLOB NOT NULL,
  tag_value_hash BLOB NOT NULL,
  height INTEGER NOT NULL,
  block_transaction_index INTEGER NOT NULL,
  data_item_tag_index INTEGER NOT NULL,
  data_item_id BLOB NOT NULL,
  parent_id BLOB NOT NULL,
  root_transaction_id BLOB NOT NULL,
  PRIMARY KEY (tag_name_hash, tag_value_hash, height, block_transaction_index, data_item_id, data_item_tag_index)
);
CREATE TABLE new_data_items (
  -- Identity
  id BLOB NOT NULL,
  parent_id BLOB NOT NULL,
  root_transaction_id BLOB NOT NULL,
  height INTEGER,
  signature BLOB NOT NULL,
  anchor BLOB NOT NULL,

  -- Ownership
  owner_address BLOB NOT NULL,
  target BLOB,

  -- Data
  data_offset INTEGER NOT NULL,
  data_size INTEGER NOT NULL,
  content_type TEXT,

  -- Metadata
  tag_count INTEGER NOT NULL,
  indexed_at INTEGER NOT NULL,
  PRIMARY KEY (id)
);
CREATE INDEX new_data_items_parent_id_id_idx ON new_data_items (parent_id, id);
CREATE INDEX new_data_items_root_transaction_id_id_idx ON new_data_items (root_transaction_id, id);
CREATE INDEX new_data_items_target_id_idx ON new_data_items (target, id);
CREATE INDEX new_data_items_owner_address_id_idx ON new_data_items (owner_address, id);
CREATE INDEX new_data_items_height_indexed_at_idx ON new_data_items (height, indexed_at);
CREATE TABLE new_data_item_tags (
  tag_name_hash BLOB NOT NULL,
  tag_value_hash BLOB NOT NULL,
  root_transaction_id BLOB NOT NULL,
  data_item_id BLOB NOT NULL,
  data_item_tag_index INTEGER NOT NULL,
  height INTEGER,
  indexed_at INTEGER NOT NULL,
  PRIMARY KEY (tag_name_hash, tag_value_hash, root_transaction_id, data_item_id, data_item_tag_index)
);
CREATE INDEX new_data_item_tags_height_indexed_at_idx ON new_data_item_tags (height, indexed_at);
CREATE INDEX stable_data_item_tags_data_item_id_idx ON stable_data_item_tags (data_item_id);
CREATE INDEX new_data_item_tags_data_item_id_idx ON new_data_item_tags (data_item_id);
CREATE TABLE bundle_data_items (
  id BLOB NOT NULL,
  parent_id BLOB NOT NULL,
  parent_index INTEGER NOT NULL,
  filter_id INTEGER NOT NULL,
  root_transaction_id BLOB NOT NULL,
  first_indexed_at INTEGER NOT NULL,
  last_indexed_at INTEGER NOT NULL,
  PRIMARY KEY (id, parent_id, parent_index, filter_id)
);
CREATE INDEX bundle_data_items_filter_id_idx
  ON bundle_data_items (filter_id);
CREATE TABLE filters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  filter TEXT NOT NULL UNIQUE
);
CREATE INDEX filters_filter_idx ON filters (filter);
CREATE TABLE bundles (
  id BLOB PRIMARY KEY,
  format_id INTEGER NOT NULL,
  unbundle_filter_id INTEGER,
  index_filter_id INTEGER,
  data_item_count INTEGER,
  matched_data_item_count INTEGER,
  first_queued_at INTEGER,
  last_queued_at INTEGER,
  first_skipped_at INTEGER,
  last_skipped_at INTEGER,
  first_unbundled_at INTEGER,
  last_unbundled_at INTEGER,
  first_fully_indexed_at INTEGER,
  last_fully_indexed_at INTEGER
);
CREATE INDEX bundles_format_id_idx ON bundles (format_id);
