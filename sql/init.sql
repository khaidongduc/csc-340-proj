

-- drop all existing tables
DROP TABLE IF EXISTS 
	subscribed, rented_apartment, apartment, 
    service, 
    tenant_vehicle, vehicle, 
    non_tenant, tenant, person,
    parking_slot, parking_lot,
    employee_phone, employee, manager, worker,
	building;

-- re-initialize the tables

CREATE TABLE IF NOT EXISTS parking_lot(
	parking_lot_no INTEGER NOT NULL,
    capacity INTEGER NOT NULL,
    
    PRIMARY KEY(parking_lot_no)
);

CREATE TABLE IF NOT EXISTS building(
	building_no INTEGER,
    build_date DATE NOT NULL,
    no_of_floor INTEGER NOT NULL,
    no_of_room INTEGER NOT NULL,
    allow_pets BINARY NOT NULL,
    address VARCHAR(500) NOT NULL,
    parking_lot_no INTEGER NOT NULL,
    
    PRIMARY KEY(building_no),
    FOREIGN KEY (parking_lot_no) REFERENCES parking_lot(parking_lot_no)
);

CREATE TABLE IF NOT EXISTS employee(
	ssn VARCHAR(20) NOT NULL,
    fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    mis VARCHAR(10) NOT NULL,
    sex VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    hourly_rate FLOAT NOT NULL,
    hire_date DATE NOT NULL,
	address VARCHAR(500) NOT NULL,
    
    PRIMARY KEY(ssn)
);

CREATE TABLE IF NOT EXISTS employee_phone(
	employee_ssn  VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(phone),
    FOREIGN KEY(employee_ssn) REFERENCES employee(ssn)
);

CREATE TABLE IF NOT EXISTS manager(
	employee_ssn  VARCHAR(20) NOT NULL,
    building_no INTEGER NOT NULL,
    
    PRIMARY KEY(employee_ssn),
    FOREIGN KEY(employee_ssn) REFERENCES employee(ssn),
    FOREIGN KEY(building_no) REFERENCES building(building_no)
);

CREATE TABLE IF NOT EXISTS worker(
	employee_ssn CHAR(9) NOT NULL,
    building_no INTEGER NOT NULL,
    type VARCHAR(20), 
    
    PRIMARY KEY(employee_ssn),
    FOREIGN KEY(employee_ssn) REFERENCES employee(ssn),
    FOREIGN KEY(building_no) REFERENCES building(building_no)
);

CREATE TABLE IF NOT EXISTS person(
	fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    mis VARCHAR(20) NOT NULL,
    sex VARCHAR(20) NOT NULL,
    dob DATE NOT NULL,
    email VARCHAR(20) NOT NULL,
	phone VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(phone)
);

CREATE TABLE IF NOT EXISTS tenant(
	person_phone VARCHAR(20) NOT NULL,
    ssn CHAR(9) NOT NULL,
    depended_tenant_phone VARCHAR(20),
    
    PRIMARY KEY(person_phone),
    FOREIGN KEY(person_phone) REFERENCES person(phone),
    FOREIGN KEY(depended_tenant_phone) REFERENCES tenant(person_phone)
);

CREATE TABLE IF NOT EXISTS non_tenant(
	person_phone VARCHAR(20) NOT NULL,
	address VARCHAR(500) NOT NULL,
	
    PRIMARY KEY(person_phone),
    FOREIGN KEY(person_phone) REFERENCES person(phone)
);

CREATE TABLE IF NOT EXISTS vehicle(
	license_plate VARCHAR(10) NOT NULL,
    type VARCHAR(20) NOT NULL,
    color VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(license_plate)
);

CREATE TABLE IF NOT EXISTS tenant_vehicle(
	vehicle_license_plate VARCHAR(10) NOT NULL,
	register_date DATE NOT NULL,
    tenant_phone VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(vehicle_license_plate),
    FOREIGN KEY(vehicle_license_plate) REFERENCES vehicle(license_plate),
    FOREIGN KEY(tenant_phone) REFERENCES tenant(person_phone)
);

CREATE TABLE IF NOT EXISTS parking_slot(
	parking_lot_no INTEGER NOT NULL,
    section VARCHAR(5) NOT NULL,
    slot_no INTEGER NOT NULL,
    type VARCHAR(20) NOT NULL,
    
    vehicle_license_plate VARCHAR(10),
    in_date DATE,
    in_time time,
	
    PRIMARY KEY(parking_lot_no, section, slot_no),
    FOREIGN KEY(parking_lot_no) REFERENCES parking_lot(parking_lot_no),
    FOREIGN KEY(vehicle_license_plate) REFERENCES vehicle(license_plate)
);

CREATE TABLE IF NOT EXISTS service(
	building_no INTEGER NOT NULL,
	name VARCHAR(20) NOT NULL,
    opentime time NOT NULL,
    closetime time NOT NULL,
    type VARCHAR(20) NOT NULL,
    operating_company VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(building_no, name),
    FOREIGN KEY(building_no) REFERENCES building(building_no)
);

CREATE TABLE IF NOT EXISTS apartment(
	building_no INTEGER NOT NULL, 
    floor INTEGER NOT NULL, 
    room_no INTEGER NOT NULL, 
    no_of_bedroom INTEGER NOT NULL, 
    no_of_bathroom INTEGER NOT NULL, 
    type VARCHAR(20) NOT NULL, 
    size FLOAT NOT NULL, 
    
    PRIMARY KEY(building_no, floor, room_no),
	FOREIGN KEY(building_no) REFERENCES building(building_no)
);

CREATE TABLE IF NOT EXISTS rented_apartment(
	building_no INTEGER NOT NULL, 
    floor INTEGER NOT NULL, 
    room_no INTEGER NOT NULL, 
    lease_start_date DATE NOT NULL, 
    lease_end_date DATE NOT NULL, 
    lease_signed_date DATE NOT NULL, 
    utilities_included BINARY NOT NULL, 
    monthly_rate FLOAT NOT NULL, 
    lease_tenant_phone VARCHAR(20) NOT NULL,
    lease_tenant_phone VARCHAR(20) NOT NULL,
    
	PRIMARY KEY(building_no, floor, room_no),
	FOREIGN KEY(building_no) REFERENCES building(building_no),
	FOREIGN KEY(lease_tenant_phone) REFERENCES tenant(person_phone)
);

CREATE TABLE IF NOT EXISTS subscribed(
	person_phone VARCHAR(20) NOT NULL,
	service_building_no INTEGER NOT NULL,
    service_name VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    type VARCHAR(20),
    
    PRIMARY KEY(person_phone, service_building_no, service_name),
    FOREIGN KEY(person_phone) REFERENCES person(phone),
    FOREIGN KEY(service_building_no, service_name) REFERENCES service(building_no, name)    
);

-- data population

INSERT INTO parking_lot(parking_lot_no, capacity)
VALUES
	(1, 5),
    (2, 5),
    (3, 5),
    (4, 5),
    (5, 5);

INSERT INTO building(building_no, build_date, no_of_floor, no_of_room, allow_pets, address, parking_lot_no)
VALUES
	(1, '2001-06-09', 2, 4, 1, "123 1st Street, Schenectady, NY, 12308-01", 1),
	(2, '2001-07-09', 3, 6, 0, "124 1st Street, Schenectady, NY, 12309-02", 2),
	(3, '2001-08-09', 2, 4, 1, "125 1st Street, Schenectady, NY, 12308-03", 3),
	(4, '2001-09-09', 1, 2, 0, "126 1st Street, Schenectady, NY, 12308-04", 4),
	(5, '2001-10-09', 3, 6, 1, "127 1st Street, Schenectady, NY, 12308-05", 5);

INSERT INTO employee(ssn, fname, lname, mis, sex, email, dob, hourly_rate, hire_date, address)
VALUES
	("680824963", "Ronald", "Power", "A", "Male", "powerr@land.co", "1990-10-10", 30, "2010-08-10", "123 2nd Street, Schenectady, NY, 12309-01"),
	("416155508", "Camille", "Hathaway", "D", "Female", "hathac@land.co", "1991-09-10", 20, "2010-08-10", "124 2nd Street, Schenectady, NY, 12309-02"),
    ("232105522", "Justina", "Sergeant", "B", "Female", "sergej@land.co", "1980-01-15", 50, "2007-01-10", "125 2nd Street, Schenectady, NY, 12309-01"),
    ("627389775", "Donald", "Blued", "MV", "Male", "blued@land.co", "2000-05-15", 30, "2018-01-15", "126 2nd Street, Schenectady, NY, 12309-02"),
    ("041865556", "Hung", "Trinh", "T", "Male", "trinhh@land.co", "2000-01-07", 10, "2018-08-10", "127 2nd Street, Schenectady, NY, 12309-03"),
    ("502823428", "Candace", "Mould", "LD", "Female", "mouldc@land.co", "1995-07-10", 25, "2005-09-10", "128 2nd Street, Schenectady, NY, 12309-04"),
    ("269019796", "Anastasia", "Marina", "MM", "Female", "marina@land.co", "1980-06-01", 60, "2000-08-10", "129 2nd Street, Schenectady, NY, 12309-05"),
    ("469232069", "Peyton", "Davies", "J", "Female", "daviep@land.co", "1998-06-07", 25, "2012-08-07", "130 2nd Street, Schenectady, NY, 12309-06"),
    ("545927795", "Toby", "Thompsett", "A", "Male", "thompst@land.co", "1997-10-10", 20, "2010-08-10", "131 2nd Street, Schenectady, NY, 12309-07"),
    ("262117281", "Jade", "Proudfoot", "M", "Male", "prounj@land.co", "1992-07-10", 40, "2012-08-10", "132 2nd Street, Schenectady, NY, 12309-08"),
    ("519707770", "Kara", "Oliverson", "IA", "Female", "olivek@land.co", "1980-01-10", 55, "1997-08-10", "133 2nd Street, Schenectady, NY, 12309-09"),
    ("417605992","Minerva", "Leon", "A", "Female", "leonm@land.co", "2001-10-10", 15, "2021-08-06", "134 3rd Street, Schenectady, NY, 12330");


INSERT INTO employee_phone(employee_ssn, phone)
VALUES
	("680824963", "5056320305"),
	("680824963", "5054203279"),
	("416155508", "8286704454"),
    ("232105522", "2075350426"),
    ("627389775", "2167774130"),
    ("041865556", "3019432887"),
    ("502823428", "2132533822"),
    ("269019796", "4128155323"),
    ("469232069", "5053773175"),
    ("545927795", "3513614564"),
    ("545927795", "2348735131"),
	("545927795", "5056441243"),
    ("262117281", "5056210175"),
    ("519707770", "2079191562"),
    ("417605992", "5057124167");
    
INSERT INTO manager(employee_ssn, building_no)
VALUES
	("269019796", 1),
    ("519707770", 2),
	("232105522", 3),
	("262117281", 4),
	("627389775", 5);
    
    
INSERT INTO worker(employee_ssn, building_no, type)
VALUES
	("680824963", 1, "Janitor"),
	("469232069", 2, "Security"),
	("502823428", 3, "Plumber"),
	("416155508", 4, "Plumber"),
	("545927795", 5, "Electrician"),
	("417605992", 2, "Security"),
	("041865556", 3, "Janitor");
 

INSERT INTO person(fname, lname, mis, sex, dob, email, phone)
VALUES
	("Shanon", "Workman", "A", "Female", "1990-09-09", "shanonw@gmail.com", "5055101519"),
    ("Gary", "Nelson", "B", "Male", "1995-05-09", "garyn@gmail.com", "6554382010"),
    ("Ismael", "Patterson", "C", "Male", "1999-02-02", "ismaelp@gmail.com", "5506112804"),
    ("Anna", "Gabrielsen", "D", "Female", "2000-01-09", "annag@gmail.com", "7714772096"),
    ("Michael", "Workman", "ED", "Male", "2002-01-01", "michaelw@gmail.com", "4515933138"),
    ("Pamela", "Cruz", "AS", "Female", "1996-03-03", "pamelac@gmail.com", "2156670742"),
    ("Andrew", "Obrien", "SW", "Male", "1989-09-10", "andrewo@gmail.com", "6669680591"),
    ("Cheryl", "Edwards", "KH", "Female", "1997-12-02", "cheryle@gmail.com", "6452451857"),
    ("Roberta", "Workman", "RG", "Female", "1990-09-09", "robertaw@gmail.com", "1185349029"),
    ("Shanon", "Fields", "QE", "Female", "1990-09-09", "shanonf@gmail.com", "6886941262"),
    ("Jon", "Workman", "P", "Male", "1990-09-09", "johnw@gmail.com", "2185579873"),
    ("Shanon", "Brown", "K", "Female", "1990-09-09", "shanonb@gmail.com", "3867410059"),
    ("Joshua", "Brown", "G", "Male", "1990-09-09", "joshuab@gmail.com", "9822078501"),
    ("Hart", "Workman", "W", "Male", "1990-09-09", "hartw@gmail.com", "9750383219");
    

INSERT INTO tenant(person_phone, ssn, depended_tenant_phone)
VALUES
	("5055101519", "519177808", NULL),
    ("4515933138", "449303642", "5055101519"),
    ("1185349029", "510318312", "5055101519"),
    ("2185579873", "041906822", "5055101519"),
    ("9750383219", "417312080", "5055101519"),
    ("9822078501", "503212684", NULL),
    ("7714772096", "520442597", "9822078501"),
    ("6886941262", "528937347", NULL),
    ("2156670742", "440360264", NULL);

INSERT INTO non_tenant(person_phone, address)
VALUES
	("3867410059", "123 3rd Street, Schenectady, NY, 12310-01"),
	("5506112804", "124 3rd Street, Schenectady, NY, 12310-02"),
	("6452451857", "125 3rd Street, Schenectady, NY, 12310-03"),
	("6554382010", "126 3rd Street, Schenectady, NY, 12310-04"),
	("6669680591", "127 3rd Street, Schenectady, NY, 12310-05");

INSERT INTO vehicle(license_plate, type, color)
VALUES
	("4TBW335", "car", "red"),
    ("5JZR350", "car", "blue"),
    ("6BFM827", "moped", "yellow"),
    ("7ZMU685", "car", "black"),
    ("EPP5277", "car", "white"),
	("LGP7277", "moped", "white"),
	("YZP2277", "car", "white"),
	("DUP5277", "car", "black"),
	("EOP9347", "moped", "purple");

INSERT INTO tenant_vehicle(vehicle_license_plate, register_date, tenant_phone)
VALUES
	("4TBW335", "2022-10-10", "5055101519"),
	("5JZR350", "2019-06-15", "5055101519"),
	("6BFM827", "2020-09-19", "5055101519"),
	("7ZMU685", "2020-12-09", "4515933138"),
	("EPP5277", "2019-11-29", "4515933138");
    
INSERT INTO parking_slot(parking_lot_no, section, slot_no, type, vehicle_license_plate, in_date, in_time)
VALUES
	(1, "A", 1, "car", "4TBW335", "2022-09-12", "12:30"),
    (1, "A", 2, "car", "5JZR350", "2022-09-12", "11:30"),
    (1, "A", 3, "car", "7ZMU685", "2022-08-12", "09:30"),
    (1, "B", 1, "moped", "6BFM827", "2015-10-12", "12:30"),
    (1, "B", 2, "moped", NULL, NULL, NULL),
    
    (2, "A", 1, "car", "EPP5277", "2022-09-12", "12:30"),
    (2, "A", 2, "car", NULL, NULL, NULL),
    (2, "A", 3, "car", NULL, NULL, NULL),
    (2, "B", 1, "moped", "LGP7277", "2022-09-12", "12:33"),
    (2, "B", 2, "moped", NULL, NULL, NULL),
    
    (3, "A", 1, "car", "YZP2277", "2022-09-12", "12:30"),
    (3, "A", 2, "car", "DUP5277", "2022-09-12", "12:33"),
    (3, "A", 3, "car", NULL, NULL, NULL),
    (3, "B", 1, "moped", NULL, NULL, NULL),
    (3, "B", 2, "moped", NULL, NULL, NULL),
    
    (4, "A", 1, "car", NULL, NULL, NULL),
    (4, "A", 2, "car", NULL, NULL, NULL),
    (4, "A", 3, "car", NULL, NULL, NULL),
    (4, "B", 1, "moped", "EOP9347", "2022-11-12", "12:30"),
    (4, "B", 2, "moped", NULL, NULL, NULL),
    
    (5, "A", 1, "car", NULL, NULL, NULL),
    (5, "A", 2, "car", NULL, NULL, NULL),
    (5, "A", 3, "car", NULL, NULL, NULL),
    (5, "B", 1, "moped", NULL, NULL, NULL),
    (5, "B", 2, "moped", NULL, NULL, NULL);

INSERT INTO service(building_no, name, opentime, closetime, type, operating_company)
VALUES
	(1, "Lunar Laundry", "7:00", "17:00", "laundry", "LunarCo"),
    (2, "Lunar Laundry", "7:00", "17:00", "laundry", "LunarCo"),
    (3, "Lunar Laundry", "7:00", "17:00", "laundry", "LunarCo"),
    (4, "Lunar Laundry", "7:00", "17:00", "laundry", "LunarCo"),
    (5, "Lunar Laundry", "7:00", "17:00", "laundry", "LunarCo"),
	(1, "Aquamate Swimming", "8:00", "22:00", "swimming", "AquaCo"),
    (2, "Fitness Gym", "7:00", "22:00", "gym", "FitnessCo");
    
INSERT INTO apartment(building_no, floor, room_no, no_of_bedroom, no_of_bathroom, type, size)
VALUES
	(1, 1, 1, 2, 3, "duplex", 100),
    (1, 1, 2, 2, 3, "duplex", 200),
    (1, 2, 1, 2, 3, "duplex", 150),
    (1, 2, 2, 2, 3, "duplex", 200),
    
	(2, 1, 1, 2, 3, "duplex", 200),
    (2, 1, 2, 2, 3, "duplex", 210),
    (2, 2, 1, 2, 3, "duplex", 250),
    (2, 2, 2, 2, 3, "duplex", 230),
	(2, 3, 1, 2, 3, "duplex", 210),
    (2, 3, 2, 2, 3, "duplex", 200),
    
    (3, 1, 1, 2, 3, "duplex", 110),
    (3, 1, 2, 2, 3, "duplex", 120),
    (3, 2, 1, 2, 3, "duplex", 120),
    (3, 2, 2, 2, 3, "duplex", 120),
    
    (4, 1, 1, 2, 3, "duplex", 120),
    (4, 1, 2, 2, 3, "duplex", 120),
    
	(5, 1, 1, 2, 3, "duplex", 110),
    (5, 1, 2, 2, 3, "duplex", 120),
    (5, 2, 1, 2, 3, "duplex", 130),
    (5, 2, 2, 2, 3, "duplex", 130),
	(5, 3, 1, 2, 3, "duplex", 110),
    (5, 3, 2, 2, 3, "duplex", 120);

INSERT INTO rented_apartment(building_no, floor, room_no,
		lease_start_date, lease_end_date, lease_signed_date, utilities_included, monthly_rate, lease_tenant_phone)
VALUES
	(1, 1, 1, "2020-09-12", "2030-09-12", "2020-08-11", 1, 800, "5055101519"),
	(2, 1, 1, "2020-09-12", "2030-09-12", "2020-08-11", 1, 800, "9822078501"),
    (2, 1, 2, "2020-09-12", "2030-09-12", "2020-08-11", 1, 800, "6886941262"),
    (3, 1, 1, "2020-09-12", "2030-09-12", "2020-08-11", 1, 800, "2156670742");

INSERT INTO subscribed(person_phone, service_building_no, service_name, start_date, end_date, type)
VALUES
	("5055101519", 1, "Lunar Laundry", "2021-09-09", "2022-12-30", "personal"),
    ("5055101519", 1, "Aquamate Swimming", "2021-09-09", "2023-02-28", "business"),
    ("5055101519", 2, "Fitness Gym", "2021-08-09", "2022-12-31", "personal"),
    ("3867410059", 2, "Lunar Laundry", "2021-09-09", "2022-12-30", "personal"),
	("5506112804", 2, "Fitness Gym", "2021-08-09", "2022-12-31", "business"),
	("6452451857", 3, "Lunar Laundry", "2021-09-09", "2022-12-30", "personal"),
	("6554382010", 4, "Lunar Laundry", "2021-09-09", "2022-12-30", "personal"),
	("6669680591", 5, "Lunar Laundry", "2021-08-09", "2023-02-28", "business");