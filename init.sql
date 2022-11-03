BEGIN;

-- drop all existing tables
DROP TABLE IF EXISTS 
	subscribed, apartment, service, 
    tenant_vehicle, vehicle, 
    non_tenant, tenant, person,
    parking_slot, parking_lot,
    employee_phone, employee, manager, worker,
	building;

-- re-initialize the tables
CREATE TABLE IF NOT EXISTS building(
	building_number INTEGER,
    build_date DATE NOT NULL,
    purchased_date DATE NOT NULL,
    number_of_floor INTEGER NOT NULL,
    number_of_room INTEGER NOT NULL,
    allow_pets BINARY NOT NULL,
    address VARCHAR(500) NOT NULL,
    
    PRIMARY KEY(building_number)
);

CREATE TABLE IF NOT EXISTS employee(
	ssn CHAR(9) NOT NULL,
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
	employee_ssn  CHAR(9) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(employee_ssn, phone),
    FOREIGN KEY(employee_ssn) REFERENCES employee(ssn)
);

CREATE TABLE IF NOT EXISTS manager(
	employee_ssn  CHAR(9) NOT NULL,
    building_number INTEGER NOT NULL,
    
    PRIMARY KEY(employee_ssn),
    FOREIGN KEY(employee_ssn) REFERENCES employee(ssn),
    FOREIGN KEY(building_number) REFERENCES building(building_number)
);

CREATE TABLE IF NOT EXISTS worker(
	employee_ssn  CHAR(9) NOT NULL,
    building_number INTEGER NOT NULL,
    type VARCHAR(20), 
    
    PRIMARY KEY(employee_ssn),
    FOREIGN KEY(employee_ssn) REFERENCES employee(ssn),
    FOREIGN KEY(building_number) REFERENCES building(building_number)
);

CREATE TABLE IF NOT EXISTS parking_lot(
	parking_lot_number INTEGER NOT NULL,
    capacity INTEGER NOT NULL,
    
    PRIMARY KEY(parking_lot_number)
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
    ssn  CHAR(9) NOT NULL,
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
	parking_lot_number INTEGER NOT NULL,
    section VARCHAR(5) NOT NULL,
    slot_number INTEGER NOT NULL,
    type VARCHAR(20) NOT NULL,
    
    vehicle_license_plate VARCHAR(10) NOT NULL,
    in_date DATE NOT NULL,
    in_time time NOT NULL,
	
    PRIMARY KEY(parking_lot_number, section, slot_number),
    FOREIGN KEY(parking_lot_number) REFERENCES parking_lot(parking_lot_number),
    FOREIGN KEY(vehicle_license_plate) REFERENCES vehicle(license_plate)
);

CREATE TABLE IF NOT EXISTS service(
	building_number INTEGER NOT NULL,
	name VARCHAR(20) NOT NULL,
    opentime time NOT NULL,
    closetime time NOT NULL,
    type VARCHAR(20) NOT NULL,
    operating_company VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(building_number, name),
    FOREIGN KEY(building_number) REFERENCES building(building_number)
);

CREATE TABLE IF NOT EXISTS apartment(
	building_number INTEGER NOT NULL, 
    floor INTEGER NOT NULL, 
    room_number INTEGER NOT NULL, 
    number_of_bedroom INTEGER NOT NULL, 
    number_of_bathroom INTEGER NOT NULL, 
    type VARCHAR(20) NOT NULL, 
    size float NOT NULL,  
    lease_start_date DATE NOT NULL, 
    lease_end_date DATE NOT NULL, 
    lease_signed_date DATE NOT NULL, 
    utilities_included BINARY NOT NULL, 
    monthly_rate float NOT NULL, 
    lease_tenant_phone VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(building_number, floor, room_number),
	FOREIGN KEY(building_number) REFERENCES building(building_number),
    FOREIGN KEY(lease_tenant_phone) REFERENCES tenant(person_phone)
);

CREATE TABLE IF NOT EXISTS subscribed(
	person_phone VARCHAR(20) NOT NULL,
	service_building_number INTEGER NOT NULL,
    service_name VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    type VARCHAR(20),
    
    PRIMARY KEY(person_phone, service_building_number, service_name),
    FOREIGN KEY(person_phone) REFERENCES person(phone),
    FOREIGN KEY(service_building_number, service_name) REFERENCES service(building_number, name)    
);

-- data population


COMMIT;

