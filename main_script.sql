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
price float,
thermal_isolation boolean not null default 0,
status boolean not null default 0,
PRIMARY KEY(apar_id));



create Table booking (
booking_id int  NOT NULL AUTO_INCREMENT,
userid int,
apar_id int,
FOREIGN KEY (userid) REFERENCES user_details(userid),
FOREIGN KEY (apar_id) REFERENCES apartment_details(apar_id),
PRIMARY KEY(booking_id));



insert into user_details(username,password) values('1','1');
insert into apartment_details (name,image_url,bedrooms,floor_area,details,thermal_isolation,status) values ('flat1','flat.jpg',2,345,'good',1,0),
('flat2','flat.jpg',2,345,'good',1,0);
insert into booking (userid,apar_id) values (1,1);





                            /*****************Query to get by user**********************/
select 
apd.apar_id,
apd.name,
apd.image_url,
apd.image_t_url,
apd.bedrooms,
apd.floor_area,
apd.thermal_isolation,
apd.price,
apd.details,
case when CURDATE()  between bk.fromdate and bk.todate 
then 'BOOKED' 
else 'BOOK'  end 
from apartment_details apd 
left join  booking bk on apd.apar_id = bk.apar_id 
left join user_details usd on usd.userid = bk.userid;


	                  /*****************Query to get by appartment**********************/
select 
apd.apar_id,
apd.name,
apd.image_url,
apd.image_t_url,
apd.bedrooms,
apd.floor_area,
apd.thermal_isolation,
apd.price,
apd.details,
case when CURDATE() <= bk.todate 
then 'BOOKED' 
else 'BOOK'  end 
from apartment_details apd 
left join  booking bk on apd.apar_id = bk.apar_id 
where apd.bedrooms = 2 and apd.floor_area = 345 and apd.thermal_isolation =1

/*********/






