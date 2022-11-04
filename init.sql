

-- drop all existing tables
DROP TABLE IF EXISTS 
	subscribed, apartment, service, 
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
    hourly_rate float NOT NULL,
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
    
    vehicle_license_plate VARCHAR(10) NOT NULL,
    in_date DATE NOT NULL,
    in_time time NOT NULL,
	
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
    size float NOT NULL,  
    lease_start_date DATE NOT NULL, 
    lease_end_date DATE NOT NULL, 
    lease_signed_date DATE NOT NULL, 
    utilities_included BINARY NOT NULL, 
    monthly_rate float NOT NULL, 
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
	(1, 40),
    (2, 60),
    (3, 40),
    (4, 20),
    (5, 40);

INSERT INTO building(building_no, build_date, no_of_floor, no_of_room, allow_pets, address, parking_lot_no)
VALUES
	(1, '2001-06-09', 2, 4, 1, "123 1st Street, Schenectady, NY, 12308-01", 1),
	(2, '2001-07-09', 3, 6, 0, "124 1st Street, Schenectady, NY, 12309-02", 2),
	(3, '2001-08-09', 2, 4, 1, "125 1st Street, Schenectady, NY, 12308-03", 3),
	(4, '2001-09-09', 1, 2, 0, "126 1st Street, Schenectady, NY, 12308-04", 4),
	(5, '2001-10-09', 5, 5, 1, "127 1st Street, Schenectady, NY, 12308-05", 5);

INSERT INTO employee(ssn, fname, lname, mis, sex, email, dob, hourly_rate, hire_date, address)
VALUES
	("680824963", "Ronald", "Power", "A", "Male", "powerr@land.co", "1990-10-10", 30, "2010-08-10", "123 2nd Street, Schenectady, NY, 12309-01"),
	("416155508", "Camille", "Hathaway", "D", "Female", "hathac@land.co", "1991-09-10", 20, "2010-08-10", "124 2nd Street, Schenectady, NY, 12309-02"),
    ("232105522", "Justina", "Sergeant", "B", "Female", "sergej@land.co", "1980-01-15", 50, "2007-01-10", "125 2nd Street, Schenectady, NY, 12309-01"),
    ("627389775", "Don", "Blue", "MV", "Male", "blued@land.co", "2000-05-15", 30, "2018-01-15", "126 2nd Street, Schenectady, NY, 12309-02"),
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


