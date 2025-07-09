use asterisk;


/* -----  Vicidial Phone Codes ----- */

LOAD DATA INFILE '/var/lib/mysql_csvs/vici_phone_codes_2025-07-08.csv'
INTO TABLE `vicidial_phone_codes`
FIELDS TERMINATED BY ','
ENCLOSED BY '\''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/* -----  Vicidial Postal Codes ----- */

LOAD DATA INFILE '/var/lib/mysql_csvs/vici_postal_codes_2025-07-08.csv'
INTO TABLE `vicidial_postal_codes`
FIELDS TERMINATED BY ','
ENCLOSED BY '\''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
