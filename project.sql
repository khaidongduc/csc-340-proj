begin;

-- drop all existing tables
drop table if exists 
	SUBSCRIBED, APARTMENT, SERVICE, 
    TENANT_VEHICLE, VEHICLE, 
    NON_TENANT, TENANT, PERSON,
    PARKING_SLOT, PARKING_LOT,
    EMPLOYEE_PHONE, EMPLOYEE, MANAGER, WORKER,
	BUILDING;

-- re-initialize the tables
create table if not exists BUILDING(
	Building_number integer auto_increment,
    Build_date date not null,
    Purchased_date date not null,
    Number_of_floor integer not null,
    Number_of_room integer not null,
    Allow_pets binary not null,
    Address varchar(500) not null,
    
    primary key(Building_number)
);

create table if not exists EMPLOYEE(
	SSN char(9) not null,
    Fname varchar(20) not null,
    Lname varchar(20) not null,
    MIs varchar(10) not null,
    Sex varchar(20) not null,
    Email varchar(50) not null,
    DoB date not null,
    Hourly_rate float not null,
    Hire_date date not null,
	Address varchar(500) not null,
    
    primary key(SSN)
);

create table if not exists EMPLOYEE_PHONE(
	Employee_SSN char(9) not null,
    phone nvarchar(20) not null,
    
    primary key(Employee_SSN, phone),
    foreign key(Employee_SSN) references EMPLOYEE(SSN)
);


create table if not exists MANAGER(
	Employee_SSN char(9) not null,
    Building_number INTEGER not null,
    
    primary key(Employee_SSN),
    foreign key(Employee_SSN) references EMPLOYEE(SSN),
    foreign key(Building_number) references BUILDING(Building_number)
);

create table if not exists WORKER(
	Employee_SSN char(9) not null,
    Building_number INTEGER not null,
    Type nvarchar(20), 
    
    primary key(Employee_SSN),
    foreign key(Employee_SSN) references EMPLOYEE(SSN),
    foreign key(Building_number) references BUILDING(Building_number)
);

create table if not exists PARKING_LOT(
	Parking_lot_number integer auto_increment not null,
    Capacity integer not null,
    
    primary key(Parking_lot_number)
);

create table if not exists PERSON(
	Fname varchar(20) not null,
    Lname varchar(20) not null,
    MIs varchar(20) not null,
    Sex varchar(20) not null,
    DoB date not null,
    Email varchar(20) not null,
	Phone varchar(20) not null,
    
    primary key(Phone)
);

create table if not exists TENANT(
	Person_phone varchar(20) not null,
    SSN char(9) not null,
    Depended_tenant_phone varchar(20),
    
    primary key(Person_phone),
    foreign key(Person_phone) references PERSON(Phone),
    foreign key(Depended_tenant_phone) references TENANT(Person_phone)
);

create table if not exists NON_TENANT(
	Person_phone varchar(20) not null,
	Address varchar(500) not null,
	
    primary key(Person_phone),
    foreign key(Person_phone) references PERSON(Phone)
);

create table if not exists VEHICLE(
	License_plate varchar(10) not null,
    Type varchar(20) not null,
    Color varchar(20) not null,
    
    primary key(License_plate)
);

create table if not exists TENANT_VEHICLE(
	Vehicle_license_plate varchar(10) not null,
	Register_date date not null,
    Tenant_phone varchar(20) not null,
    
    primary key(Vehicle_license_plate),
    foreign key(Vehicle_license_plate) references VEHICLE(License_plate),
    foreign key(Tenant_phone) references TENANT(Person_phone)
);

create table if not exists PARKING_SLOT(
	Parking_lot_number integer not null,
    Section varchar(5) not null,
    Slot_number integer not null,
    Type nvarchar(20) not null,
    
    Vehicle_license_plate varchar(10) not null,
    In_Date date not null,
    In_Time time not null,
	
    primary key(Parking_lot_number, Section, Slot_number),
    foreign key(Parking_lot_number) references PARKING_LOT(Parking_lot_number),
    foreign key(Vehicle_license_plate) references VEHICLE(License_plate)
);

create table if not exists SERVICE(
	Building_number integer not null,
	Name varchar(20) not null,
    OpenTime time not null,
    CloseTime time not null,
    Type varchar(20) not null,
    Operating_company varchar(20) not null,
    
    primary key(Building_number, Name),
    foreign key(Building_number) references BUILDING(Building_number)
);

create table if not exists APARTMENT(
	Building_number integer not null, 
    Floor integer not null, 
    Room_number integer not null, 
    number_of_bedroom integer not null, 
    number_of_bathroom integer not null, 
    Type varchar(20) not null, 
    Size float not null,  
    Lease_start_date date not null, 
    Lease_end_date date not null, 
    Lease_signed_date date not null, 
    Utilities_included binary not null, 
    Monthly_rate float not null, 
    Lease_tenant_phone varchar(20) not null,
    
    primary key(Building_number, Floor, Room_number),
	foreign key(Building_number) references BUILDING(Building_number),
    foreign key(Lease_tenant_phone) references TENANT(Person_phone)
);

create table if not exists SUBSCRIBED(
	Person_phone varchar(20) not null,
	Service_Building_number integer not null,
    Service_name varchar(20) not null,
    Start_date date not null,
    End_date date not null,
    Type varchar(20),
    
    primary key(Person_phone, Service_Building_number, Service_name),
    foreign key(Person_phone) references PERSON(Phone),
    foreign key(Service_Building_number, Service_name) references SERVICE(Building_number, Name)    
);

-- data population

COMMIT;

