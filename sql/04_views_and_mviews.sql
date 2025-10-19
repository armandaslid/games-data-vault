-- Analytical and Materialized Views

-- Denormalized analytical view
CREATE OR REPLACE VIEW view_game_full AS
SELECT 
    g.game_hk,
    g.game_name,
    p.platform_name,
    d.developer_name,
    pb.publisher_name,
    det.year_of_release,
    det.genre,
    det.rating,
    s.global_sales,
    s.na_sales,
    s.eu_sales,
    s.jp_sales,
    s.other_sales,
    sc.critic_score,
    sc.user_score,
    g.load_date
FROM hub_game g
LEFT JOIN link_game_platform lgp ON g.game_hk = lgp.game_hk
LEFT JOIN hub_platform p ON lgp.platform_hk = p.platform_hk
LEFT JOIN link_game_developer lgd ON g.game_hk = lgd.game_hk
LEFT JOIN hub_developer d ON lgd.developer_hk = d.developer_hk
LEFT JOIN link_game_publisher lgpub ON g.game_hk = lgpub.game_hk
LEFT JOIN hub_publisher pb ON lgpub.publisher_hk = pb.publisher_hk
LEFT JOIN sat_game_details det ON g.game_hk = det.game_hk
LEFT JOIN sat_game_sales s ON g.game_hk = s.game_hk
LEFT JOIN sat_game_scores sc ON g.game_hk = sc.game_hk;


-- Materialized view for faster reporting
CREATE MATERIALIZED VIEW mview_sales_summary AS
WITH agg_sales AS (
    SELECT 
        game_hk,
        SUM(global_sales) AS total_sales
    FROM sat_game_sales
    GROUP BY game_hk
),
agg_scores AS (
    SELECT 
        game_hk,
        AVG(critic_score) AS avg_critic_score,
        AVG(user_score) AS avg_user_score
    FROM sat_game_scores
    GROUP BY game_hk
)
SELECT 
    d.developer_name,
    SUM(s.total_sales) AS total_sales,
    AVG(sc.avg_critic_score) AS avg_critic_score,
    AVG(sc.avg_user_score) AS avg_user_score,
    COUNT(DISTINCT g.game_hk) AS total_games
FROM hub_developer d
JOIN link_game_developer lgd ON d.developer_hk = lgd.developer_hk
JOIN hub_game g ON lgd.game_hk = g.game_hk
LEFT JOIN agg_sales s ON g.game_hk = s.game_hk
LEFT JOIN agg_scores sc ON g.game_hk = sc.game_hk
GROUP BY d.developer_name
ORDER BY total_sales DESC;


-- Refresh materialized view when new data is loaded
REFRESH MATERIALIZED VIEW mview_sales_summary;
