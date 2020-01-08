SET foreign_key_checks = 0;

DROP TABLE IF EXISTS apartment_details;
DROP TABLE IF EXISTS user_details;
DROP TABLE IF EXISTS booking;
SET foreign_key_checks = 1;
CREATE TABLE user_details (username VARCHAR(255), password VARCHAR(255),
userid INT NOT NULL AUTO_INCREMENT,
email varchar(255),
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
trans_id int not null default 0,
PRIMARY KEY(apar_id));



create Table booking (
booking_id int  NOT NULL AUTO_INCREMENT,
userid int,
apar_id int,
status boolean not null default 0,
FOREIGN KEY (userid) REFERENCES user_details(userid),
FOREIGN KEY (apar_id) REFERENCES apartment_details(apar_id),
PRIMARY KEY(booking_id));




insert into apartment_details (name,image_url,image_t_url,bedrooms,floor_area,details,price,thermal_isolation,trans_id) values ('flat_1','flat.jpeg','flat.jpeg',2,345,'good',175000,1,0);
insert into apartment_details (name,image_url,image_t_url,bedrooms,floor_area,details,price,thermal_isolation,trans_id) values ('flat_2','flat.jpeg','flat.jpeg',1,200,'good',258000,0,0);
insert into apartment_details (name,image_url,image_t_url,bedrooms,floor_area,details,price,thermal_isolation,trans_id) values ('flat_3','flat.jpeg','flat.jpeg',1,200,'bad',258000,0,0);
insert into apartment_details (name,image_url,image_t_url,bedrooms,floor_area,details,price,thermal_isolation,trans_id) values ('flat_4','flat.jpeg','flat.jpeg',1,200,'good',28000,0,0);
insert into apartment_details (name,image_url,image_t_url,bedrooms,floor_area,details,price,thermal_isolation,trans_id) values ('flat_5','flat.jpeg','flat.jpeg',1,200,'good',8000,0,0);

/*******Frequently bought flat***********/
select apd.name,
apd.image_url,
apd.image_t_url,
count(apd.apar_id) ,
sum(apd.price) from booking bk 
inner join apartment_details apd on apd.apar_id = bk.apar_id 
inner join user_details usr on usr.userid = bk.userid  
where bk.userid = 1 and bk.status = 1 group by apd.apar_id ,apd.name;  

/***expensive appartments bought**/
select apd.name,apd.image_url,apd.image_t_url,count(apd.apar_id) ,apd.price from booking bk inner join apartment_details apd on apd.apar_id = bk.apar_id inner join user_details usr on usr.userid = bk.userid  where bk.userid = 1 and bk.status = 1 group by apd.apar_id ,apd.name,apd.price order by apd.price;

/**current flats**/
select apd.apar_id,apd.name,apd.image_url,apd.image_t_url,apd.bedrooms,apd.floor_area,apd.thermal_isolation,apd.price,apd.details,bk.userid,bk.apar_id,bk.status from apartment_details apd inner join booking bk on bk.booking_id = apd.trans_id where bk.userid = 1 and bk.status = 1;

 






                          

