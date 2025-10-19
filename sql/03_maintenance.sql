-- Database Maintenance:

-- 1. Clean and update stats for all tables
VACUUM (VERBOSE, ANALYZE);

-- 2. Quick index & table bloat overview
SELECT 
    schemaname,
    relname AS index_name,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
    pg_size_pretty(pg_relation_size(relid)) AS table_size,
    ROUND(
        (pg_relation_size(indexrelid)::NUMERIC / NULLIF(pg_relation_size(relid), 0)) * 100, 
        2
    ) AS bloat_pct
FROM pg_stat_user_indexes
JOIN pg_index USING (indexrelid)
ORDER BY bloat_pct DESC;

-- 3. Optional: Deep cleanup of specific bloated table (exclusive lock)
VACUUM FULL VERBOSE hub_platform;
ANALYZE hub_platform;

-- 4. Optional: Reindex only large or bloated tables or databases
REINDEX TABLE link_game_platform;
REINDEX DATABASE postgres;