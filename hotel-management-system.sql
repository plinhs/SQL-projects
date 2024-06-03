-- Use this template for your se2222 project
-- Before submission be sure that your file is named like [your_ID].sql
-- You will get minus 20% of total score for each day after due date
-- Name: Pelin Duman	
-- ID:22070006014

-- 1. Create and use a schema for your project named SE2222_[your_ID]
CREATE SCHEMA SE2222_22070006014;
USE SE2222_22070006014;

-- 1. Definitions:

-- Guest table holds information about individual guests which are guest id, name, phone number and email address.
CREATE TABLE Guests(
guest_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
phone_number VARCHAR(15) UNIQUE NOT NULL,
email_address VARCHAR(255) UNIQUE
);

-- Rooms table holds room information which includes room number, bed type, price and if the room is available or not.
CREATE TABLE Rooms(
room_number INT PRIMARY KEY,
bed_type VARCHAR(50) NOT NULL,
price_per_night DECIMAL(10,2),
availability BOOLEAN NOT NULL
);

-- Reservations table holds reservation information including reservation id, guest id from "guests" table, 
-- room number from "rooms" table, checkin and checkout dates, and price in total.
CREATE TABLE Reservations(
reservation_id INT AUTO_INCREMENT PRIMARY KEY,
guest_id INT NOT NULL,
room_number INT,
checkin_date DATE NOT NULL,
checkout_date DATE NOT NULL,
total_price DECIMAL(10,2) NOT NULL,
CHECK (checkin_date < checkout_date),
FOREIGN KEY (guest_id) REFERENCES Guests(guest_id) ON DELETE CASCADE,
FOREIGN KEY (room_number) REFERENCES Rooms(room_number) ON DELETE SET NULL
);

-- Payments table holds payment information including payment id, reservation id from "reservations" table, 
-- guest id from "guests" table, payment method, date, saved card number information and amount of payment. 
CREATE TABLE Payments(
payment_id INT AUTO_INCREMENT PRIMARY KEY,
reservation_id INT NOT NULL,
guest_id INT NOT NULL,
payment_method VARCHAR(50) NOT NULL,
payment_date DATE NOT NULL,
amount DECIMAL(10,2) NOT NULL,
saved_card_info VARCHAR(100),
FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id) ON DELETE CASCADE,
FOREIGN KEY (guest_id) REFERENCES Guests(guest_id) ON DELETE CASCADE
);

-- Services table holds information about service which are type of service, reservation id from "reservations" table, 
-- guest id from "guests" table, place of service, and price of the service given. 
CREATE TABLE Services(
service_type VARCHAR(100) NOT NULL,
reservation_id INT NOT NULL,
guest_id INT NOT NULL,
specification_of_place VARCHAR(100) NOT NULL,
price DECIMAL(10,2) NOT NULL,
FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id) ON DELETE CASCADE,
FOREIGN KEY (guest_id) REFERENCES Guests(guest_id) ON DELETE CASCADE
);

-- Staff holds information about Staff which are id, phone number, position, shift schedule, department id and email address.
CREATE TABLE Staff(
staff_id INT AUTO_INCREMENT PRIMARY KEY,
phone_number VARCHAR(15) UNIQUE NOT NULL,
position VARCHAR(50) NOT NULL,
shift_schedule VARCHAR(100) NOT NULL,
department_id INT,
email_address VARCHAR(255) UNIQUE,
income DECIMAL(10,2) NOT NULL,
FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
);
ALTER TABLE Staff ADD name VARCHAR(100) NOT NULL;


-- Departments table hold department information including department id, name and manager id of given department.
CREATE TABLE Departments(
department_id INT AUTO_INCREMENT PRIMARY KEY,
department_name VARCHAR(50) NOT NULL
);

-- Feedbacks table holds feedback information including feedback id, guest id, room number, comment and date.
CREATE TABLE Feedbacks(
feedback_id INT AUTO_INCREMENT PRIMARY KEY,
guest_id INT NOT NULL,
room_number INT,
comment TEXT,
date DATE NOT NULL,
FOREIGN KEY (guest_id) REFERENCES Guests(guest_id) ON DELETE CASCADE,
FOREIGN KEY (room_number) REFERENCES Rooms(room_number) ON DELETE SET NULL
);


-- Assigned table holds information about which staff is assigned in which rooms, with staff_id and room_number.
CREATE TABLE Assigned(
staff_id INT NOT NULL,
room_number INT NOT NULL,
FOREIGN KEY (room_number) REFERENCES Rooms(room_number) ON DELETE CASCADE,
FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE,
PRIMARY KEY (staff_id,room_number)
);

-- Manages table holds information about which staff manages which reservations, with staff_id and reservation_id.
CREATE TABLE Manages(
reservation_id INT NOT NULL,
staff_id INT NOT NULL,
FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id) ON DELETE CASCADE,
FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE,
PRIMARY KEY (reservation_id,staff_id)
);

-- Provides table holds information about which staff provides which service, with staff_id and service_type.
CREATE TABLE Provides(
staff_id INT NOT NULL,
service_type VARCHAR(100) NOT NULL,
FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE,
PRIMARY KEY (staff_id,service_type)
);

-- Determines table holds information about which reservation ends up in which payment, with reservation_id and payment_id.
CREATE TABLE Determines(
reservation_id INT NOT NULL,
payment_id INT NOT NULL,
FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id) ON DELETE CASCADE,
FOREIGN KEY (payment_id) REFERENCES Payments(payment_id) ON DELETE CASCADE,
PRIMARY KEY (reservation_id,payment_id)
);


-- 2. Insertions(Data manipulation):

INSERT INTO Guests(name, phone_number, email_address) VALUES
("Dexter Morgan", "202-457-1234", "dexter@gmail.com"),
("Phoebe Buffay", "451-124-7894", "buffayphoebs@gmail.com"),
("Robert Langdon", "789-456-7845", "roblangdon@gmail.com"),
("Jim Hopper", "248-789-2540", "hophopjim@gmail.com"),
("Fred Stone", "254-852-4502", "flintstoneff@gmail.com");

INSERT INTO Rooms(room_number, bed_type, price_per_night, availability) VALUES
(101,"King", 200, true),
(102, "Queen", 150,false),
(103,"Double", 130, true),
(104, "Double", 130, false),
(106, "Queen", 150, true),
(107, "Double", 130, true);

ALTER TABLE Reservations AUTO_INCREMENT = 111;
INSERT INTO Reservations(guest_id, room_number, checkin_date, checkout_date, total_price) VALUES
(1, 101, "2024-05-03", "2024-05-06", 600),
(2, 102, "2024-05-04", "2024-05-09", 750),
(3, 103, "2024-05-01", "2024-05-08", 910),
(4, 107, "2024-05-21", "2024-05-25", 520),
(5,106,"2024-05-12","2024-05-14",300);


ALTER TABLE Payments AUTO_INCREMENT = 130;
INSERT INTO Payments(reservation_id,guest_id,payment_method, payment_date,amount,saved_card_info) VALUES
(111, 1, "online", "2024-05-06", 630, "1234-5678-9123-4567" ),
(112, 2, "cash", "2024-05-09", 810, null),
(113, 3, "credit card", "2024-05-08", 965.5,null),
(114, 4, "online","2024-05-21", 575.5, "5478-854-8965-5698"),
(115, 5, "cash", "2024-05-14", 300,null);

INSERT INTO Services(service_type,reservation_id,guest_id,specification_of_place,price) VALUES
("Room Service", 113, 3, "Room", 55.5),
("Sports", 111, 1, "Gym", 30),
("Massage", 112, 2, "Spa", 60),
("Room Service", 114, 4, "Room", 55.5);


ALTER TABLE Staff AUTO_INCREMENT = 150;
INSERT INTO Staff(phone_number,name, position,shift_schedule,department_id,email_address,income) VALUES 
("202-789-4578", "Martha Will", "Manager", "Day", 01, "willmartha@hotel.com", 5000),
("202-123-4254", "Will Stitch", "Guard", "Night", 02, "stitchwill@hotel.com", 4000),
("202-985-2367", "Lily Murry", "Receptionist", "Day", 03, "murrylily@hotel.com", 3800),
("202-751-1278", "Amanda Lee", "Waitress", "Day", 04, "leeamanda@hotel.com",3900),
("202-785-2567", "Mary Sue", "Masseuse", "Day", 05, "suemary@hotel.com", 3850);

ALTER TABLE Departments AUTO_INCREMENT = 01;
INSERT INTO Departments(department_name) VALUES 
("Housekeeping"),
("Security"),
("Front Desk"),
("Food and Beverage"),
("Spa");

INSERT INTO Feedbacks(guest_id,room_number,comment,date) VALUES
(3, 103, "Quite nice service, staff were very kind.", "2024-05-08"),
(2, 102, "It was nice, but could use some improvements", "2024-05-09");

INSERT INTO Provides(staff_id, service_type) VALUES
(162,"Room Service"),
(163, "Massage");

INSERT INTO Assigned VALUES (162,103), (162,107);

INSERT INTO Manages VALUES (112,156), (113,156) , (115,156);

INSERT INTO Determines VALUES (111, 130), (112,131), (113,132), (114,133), (115,134);

-- Queries

-- Joining guests table with payments table so that we can clearly see which guest payed how much.
SELECT g.name, p.amount
FROM guests g
JOIN payments p ON p.guest_id = g.guest_id;

--  Displaying number of each bed type with their total price, using group by statement.
SELECT bed_type,COUNT(*) as number_of_beds, SUM(price_per_night) as total_price
FROM rooms
GROUP BY bed_type;

-- Updating room availabilities according to newly added guests.
UPDATE Rooms 
SET availability = true
WHERE room_number IN (SELECT room_number
					  FROM reservations);
                      
-- Displaying guests who has payed more that average in total.
SELECT g.guest_id, g.name, p.amount
FROM guests g
JOIN payments p ON g.guest_id = p.guest_id
WHERE p.amount > (SELECT AVG(amount) FROM payments);
           
-- Applying 20% discount who checkedin in the first week of May (between 7th and 1st).
DELIMITER $$
CREATE TRIGGER ApplyDiscountFirstWeek
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT *
        FROM Reservations
        WHERE checkin_date BETWEEN "2024-05-01" AND "2024-05-07"
    ) THEN 
		SET NEW.amount = NEW.amount*0.8;
	END IF;
END $$
DELIMITER ;


-- Function which calculates total nights stayed of given guest
CREATE FUNCTION TotalNightsStayed(guest_id INT) 
RETURNS INT
READS SQL DATA
DETERMINISTIC
RETURN
	(SELECT SUM(DATEDIFF(checkout_date, checkin_date))
    FROM Reservations r
    WHERE r.guest_id = guest_id);
    
SELECT guest_id, name, TotalNightsStayed(guest_id)
FROM guests; 


-- Procedure which calculates total revenue between given dates
CREATE PROCEDURE CalculateTotalRevenue(startDate DATE,endDate DATE)
	SELECT SUM(total_price)as total_rev
    FROM reservations
    WHERE checkin_date >= startDate AND checkout_date <= endDate;
CALL CalculateTotalRevenue("2024-05-01","2024-05-31");

