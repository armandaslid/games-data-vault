-- Create Indexes for the tables

-- First find sizes of all tables in schema
SELECT 
    table_name, 
    pg_size_pretty(pg_total_relation_size(quote_ident(table_name)::regclass)) AS total_size
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY pg_total_relation_size(quote_ident(table_name)::regclass) DESC;

--[Results]
/*
Table Name               | Total Size
-------------------------|------------
link_game_platform       | 3,936 kB
link_game_developer      | 3,312 kB
link_game_publisher      | 2,968 kB
hub_game                 | 2,320 kB
sat_game_sales           | 2,040 kB
sat_game_details         | 1,896 kB
hub_developer            | 1,584 kB
sat_game_scores          | 1,152 kB
hub_publisher            | 208 kB
hub_platform             | 24 kB
*/

-- Choose only 6 biggest tables to index

-- Hub Table
-- Index on game_name for quick lookups by name
CREATE INDEX idx_hub_game_name ON hub_game(game_name);

-- Link Tables 
-- Indexes on foreign keys for faster joins
CREATE INDEX idx_link_game_platform_game_hk ON link_game_platform(game_hk);
CREATE INDEX idx_link_game_platform_platform_hk ON link_game_platform(platform_hk);

CREATE INDEX idx_link_game_developer_game_hk ON link_game_developer(game_hk);
CREATE INDEX idx_link_game_developer_developer_hk ON link_game_developer(developer_hk);

CREATE INDEX idx_link_game_publisher_game_hk ON link_game_publisher(game_hk);
CREATE INDEX idx_link_game_publisher_publisher_hk ON link_game_publisher(publisher_hk);

-- Satellite Tables
-- Used for querying sales and details by game and load_date
CREATE INDEX idx_sat_game_sales_hk_date ON sat_game_sales(game_hk, load_date);
CREATE INDEX idx_sat_game_details_hk_date ON sat_game_details(game_hk, load_date);

-- Notes:
-- Only indexing the largest tables to balance read performance vs storage and write overhead.
-- Columns chosen for indexes are frequently used in joins or filtering.
