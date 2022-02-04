----------------------------------------------------------------
--
----------------------------------------------------------------
-- The following SQL statements were written by the IT Service for creating the database.
-- You're not allowed to make any changes or add any SQL statements in the following section.
----------------------------------------------------------------
DROP TABLE IF EXISTS ParkingPermit;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS PermitType;

-- Users = {UID, Name, Email}
CREATE TABLE Users (
  UID int PRIMARY KEY,
  Name varchar(255),
  Email varchar(255)
);

-- PermitType = {PID, TypeOfPermit, Fee, Description}
CREATE TABLE PermitType (
  PID int PRIMARY KEY,
  TypeOfPermit varchar(255),
  Fee int,
  Description text
);

-- ParkingPermit = {PermitTypeID, UserID, IssueDate, ExpiryDate, VehicleRegNo, IsActive}
CREATE TABLE ParkingPermit (
  PermitTypeID int,
  UserID int,
  IssueDate date,
  ExpiryDate date,
  VehicleRegNo varchar(10),
  IsActive boolean,
  PRIMARY KEY(PermitTypeID, UserID)
);

----------------------------------------------------------------
--Please enter your answers to Q1.1-Q1.6 of Question 1 in the following section
----------------------------------------------------------------

-- Your answer to Q1.1
ALTER TABLE ParkingPermit
ADD CONSTRAINT chk_date CHECK (ExpiryDate >= IssueDate),
ALTER COLUMN IssueDate SET DEFAULT now();

-- Your answer to Q1.2
ALTER TABLE ParkingPermit
ADD FOREIGN KEY(UserID) REFERENCES Users(UID),
ADD FOREIGN KEY(PermitTypeID) REFERENCES PermitType(PID);

-- Your answer to Q1.3
CREATE UNIQUE INDEX ON ParkingPermit(VehicleRegNo) WHERE IsActive;


-- Your answer to Q1.4
ALTER TABLE PermitType
ALTER COLUMN Fee TYPE decimal(8,2),
ADD CONSTRAINT positive_fee CHECK (Fee >= 0 AND Fee <= 100000 );

-- Your answer to Q1.5
ALTER TABLE Users 
ADD COLUMN PhoneNumber numeric(10), 
ADD CONSTRAINT lenchk CHECK (length(PhoneNumber::text) = 10);

-- Your answer to Q1.6
UPDATE PermitType
SET Fee = 0.9 * Fee WHERE TypeOfPermit = 'Pay As You Go';

----------------------------------------------------------------
-- End of your answers
----------------------------------------------------------------
-- Do not make any changes to the following SQL statements
----------------------------------------------------------------
\d Users;
SELECT * from Users;
\d PermitType;
SELECT * from PermitType;
\d ParkingPermit;
SELECT * from ParkingPermit;

