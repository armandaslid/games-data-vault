-- Create Data Vault 2.0 Tables (Run in DB Script or PostgreSQL CLI)

-- HUBS:

CREATE TABLE hub_game (
    game_hk CHAR(32) PRIMARY KEY,
    game_name VARCHAR(255) NOT NULL,
    load_date TIMESTAMP,
    record_source VARCHAR(50)
);

CREATE TABLE hub_platform (
    platform_hk CHAR(32) PRIMARY KEY,
    platform_name VARCHAR(255) NOT NULL,
    load_date TIMESTAMP,
    record_source VARCHAR(50)
);

CREATE TABLE hub_developer (
    developer_hk CHAR(32) PRIMARY KEY,
    developer_name VARCHAR(255) NOT NULL,
    load_date TIMESTAMP,
    record_source VARCHAR(50)
);

CREATE TABLE hub_publisher (
    publisher_hk CHAR(32) PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL,
    load_date TIMESTAMP,
    record_source VARCHAR(50)
);

-- LINKS:

CREATE TABLE link_game_platform (
    link_game_platform_hk CHAR(32) PRIMARY KEY,
    game_hk CHAR(32) NOT NULL,
    platform_hk CHAR(32) NOT NULL,
    load_date TIMESTAMP,
    record_source VARCHAR(50),
    CONSTRAINT fk_lgp_game FOREIGN KEY (game_hk)
        REFERENCES hub_game(game_hk)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_lgp_platform FOREIGN KEY (platform_hk)
        REFERENCES Hub_Platform(platform_hk)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE link_game_developer (
    link_game_developer_hk CHAR(32) PRIMARY KEY,
    game_hk CHAR(32) NOT NULL,
    developer_hk CHAR(32) NOT NULL,
    load_date TIMESTAMP,
    record_source VARCHAR(50),
    CONSTRAINT fk_lgd_game FOREIGN KEY (game_hk)
        REFERENCES hub_game(game_hk)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_lgd_developer FOREIGN KEY (developer_hk)
        REFERENCES Hub_Developer(developer_hk)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE link_game_publisher (
    link_game_publisher_hk CHAR(32) PRIMARY KEY,
    game_hk CHAR(32) NOT NULL,
    publisher_hk CHAR(32) NOT NULL,
    load_date TIMESTAMP,
    record_source VARCHAR(50),
    CONSTRAINT fk_lgp_game FOREIGN KEY (game_hk)
        REFERENCES hub_game(game_hk)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_lgp_publisher FOREIGN KEY (publisher_hk)
        REFERENCES Hub_Publisher(publisher_hk)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- SATELLITES:

CREATE TABLE sat_game_details (
    game_hk CHAR(32) NOT NULL,
    year_of_release SMALLINT,
    genre VARCHAR(100),
    rating VARCHAR(20),
    load_date TIMESTAMP,
    record_source VARCHAR(50),
    CONSTRAINT fk_sgd_game FOREIGN KEY (game_hk)
        REFERENCES hub_game(game_hk)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE sat_game_sales (
    game_hk CHAR(32) NOT NULL,
    na_sales DECIMAL(10,2),
    eu_sales DECIMAL(10,2),
    jp_sales DECIMAL(10,2),
    other_sales DECIMAL(10,2),
    global_sales DECIMAL(10,2),
    load_date TIMESTAMP,
    record_source VARCHAR(50),
    CONSTRAINT fk_sgs_game FOREIGN KEY (game_hk)
        REFERENCES hub_game(game_hk)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE sat_game_scores (
    game_hk CHAR(32) NOT NULL,
    critic_score DECIMAL(4,2),
    critic_count INT,
    user_score DECIMAL(4,2),
    user_count INT,
    load_date TIMESTAMP,
    record_source VARCHAR(50),
    CONSTRAINT fk_scs_game FOREIGN KEY (game_hk)
        REFERENCES hub_game(game_hk)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
