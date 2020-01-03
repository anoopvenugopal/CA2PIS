SET foreign_key_checks = 0;

DROP TABLE IF EXISTS apartment_details;
DROP TABLE IF EXISTS user_details;
DROP TABLE IF EXISTS booking;
SET foreign_key_checks = 1;
CREATE TABLE user_details (username VARCHAR(255), password VARCHAR(255),
userid INT NOT NULL AUTO_INCREMENT,
name varchar(255),
address varchar(255),
phone_no varchar(255),
PRIMARY KEY(userid));

CREATE TABLE apartment_details (
apar_id int  NOT NULL AUTO_INCREMENT,
name VARCHAR(255),
image_url varchar(255),
image_t_url varchar(255),
bedrooms int NOT NULL,
floor_area int NOT NULL,
details varchar(255),
thermal_isolation boolean not null default 0,
PRIMARY KEY(apar_id));



create Table booking (
booking_id int  NOT NULL AUTO_INCREMENT,
userid int,
apar_id int,
FOREIGN KEY (userid) REFERENCES user_details(userid),
FOREIGN KEY (apar_id) REFERENCES apartment_details(apar_id),
PRIMARY KEY(booking_id));



