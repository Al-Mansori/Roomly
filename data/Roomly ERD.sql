CREATE DATABASE Roomly;

-- DROP DATABASE Roomly; 

USE ROOMLY;

-- Table Definitions
CREATE TABLE `User` (
  `UserId` INT PRIMARY KEY AUTO_INCREMENT,
  `Name` VARCHAR(100),
  `FName` VARCHAR(50),
  `LName` VARCHAR(50),
  `Email` VARCHAR(255) UNIQUE,
  `Password` VARCHAR(255),
  `Location` VARCHAR(100),
  `Phone` VARCHAR(20),
  `RewardsPoints` INT DEFAULT 0
);

CREATE TABLE `LoyaltyPoints` (
  `PointsId` INT PRIMARY KEY AUTO_INCREMENT,
  `Points` INT DEFAULT 0,
  `startDate` DATE,
  `expiryDate` DATE,
  `UserId` INT
);

CREATE TABLE `Preference` (
  `PreferenceId` INT PRIMARY KEY AUTO_INCREMENT,
  `BudgetPreference` VARCHAR(100),
  `LanguagePreference` VARCHAR(50),
  `WorkspaceTypePreference` VARCHAR(100),
  `UserId` INT
);

CREATE TABLE `WorkspaceStaff` (
  `StaffId` INT PRIMARY KEY AUTO_INCREMENT,
  `Name` VARCHAR(100),
  `FName` VARCHAR(50),
  `LName` VARCHAR(50),
  `Email` VARCHAR(255) UNIQUE,
  `Password` VARCHAR(255),
  `Location` VARCHAR(100),
  `Phone` VARCHAR(20)
);

CREATE TABLE `Workspace` (
  `WorkspaceId` INT PRIMARY KEY AUTO_INCREMENT,
  `Name` VARCHAR(100),
  `Description` TEXT,
  `Longitude` DECIMAL(10,6),
  `Latitude` DECIMAL(10,6),
  `Type` VARCHAR(50),
  `Location` VARCHAR(100),
  `CreateDate` DATE DEFAULT (CURRENT_DATE),
  `AvgRating` DECIMAL(3,2) DEFAULT 0.00
);

CREATE TABLE `WorkspaceImages` (
  `ImageId` INT PRIMARY KEY AUTO_INCREMENT,
  `WorkspaceId` INT,
  `StaffId` INT,
  `ImageURL` VARCHAR(255),
  `UploadDate` DATE DEFAULT (CURRENT_DATE),
  `Description` TEXT
);

CREATE TABLE `Offer` (
  `OfferId` INT PRIMARY KEY AUTO_INCREMENT,
  `OfferTitle` VARCHAR(100),
  `DiscountPercentage` DECIMAL(5,2),
  `ValidFrom` DATE,
  `ValidTo` DATE,
  `Status` VARCHAR(20) DEFAULT 'Active',
  `Description` TEXT,
  `MaxRedemptions` INT,
  `RoomId` INT,
  `StaffId` INT
);

CREATE TABLE `WorkspaceAnalytics` (
  `AnalyticsId` INT PRIMARY KEY AUTO_INCREMENT,
  `WorkspaceId` INT,
  `TotalBookings` INT DEFAULT 0,
  `TotalRevenue` DECIMAL(12,2) DEFAULT 0.00,
  `AverageRating` DECIMAL(3,2) DEFAULT 0.00,
  `UsagePattern` JSON
);

CREATE TABLE `Room` (
  `RoomId` INT PRIMARY KEY AUTO_INCREMENT,
  `WorkspaceId` INT,
  `Type` VARCHAR(50),
  `Description` TEXT,
  `Capacity` INT,
  `RoomStatus` VARCHAR(20) DEFAULT 'Available',
  `PricePerHour` DECIMAL(8,2)
);

CREATE TABLE `WorkspacePlan` (
  `PlanId` INT PRIMARY KEY AUTO_INCREMENT,
  `WorkspaceId` INT,
  `DayPrice` DECIMAL(8,2),
  `MonthPrice` DECIMAL(8,2),
  `YearPrice` DECIMAL(10,2)
);

CREATE TABLE `RoomImages` (
  `ImageId` INT PRIMARY KEY AUTO_INCREMENT,
  `RoomId` INT,
  `ImageURL` VARCHAR(255),
  `UploadDate` DATE DEFAULT (CURRENT_DATE),
  `Description` TEXT
);

CREATE TABLE `Amenities` (
  `AmenityId` INT PRIMARY KEY AUTO_INCREMENT,
  `AmenityName` VARCHAR(100),
  `TotalCount` INT,
  `AvailableCount` INT,
  `Type` VARCHAR(50),
  `Description` TEXT,
  `RoomId` INT
);

CREATE TABLE `AmenityImages` (
  `ImageId` INT PRIMARY KEY AUTO_INCREMENT,
  `AmenityId` INT,
  `ImageURL` VARCHAR(255),
  `UploadDate` DATE DEFAULT (CURRENT_DATE),
  `Description` TEXT
);

CREATE TABLE `Reservation` (
  `BookingId` INT PRIMARY KEY AUTO_INCREMENT,
  `UserId` INT,
  `RoomId` INT,
  `WorkspaceId` INT,
  `BookingDate` DATE DEFAULT (CURRENT_DATE),
  `BookingStatus` VARCHAR(20) DEFAULT 'Pending',
  `StartTime` DATETIME,
  `EndTime` DATETIME,
  `TotalCost` DECIMAL(10,2),
  `PaymentStatus` BOOLEAN DEFAULT FALSE
);

CREATE TABLE `Payment` (
  `PaymentId` INT PRIMARY KEY AUTO_INCREMENT,
  `PaymentDate` DATE DEFAULT (CURRENT_DATE),
  `PaymentMethod` VARCHAR(50),
  `PaymentStatus` BOOLEAN DEFAULT FALSE,
  `Amount` DECIMAL(10,2),
  `UserId` INT
);

CREATE TABLE `Invoice` (
  `InvoiceId` INT PRIMARY KEY AUTO_INCREMENT,
  `PaymentId` INT,
  `BookingId` INT,
  `InvoiceDate` DATE DEFAULT (CURRENT_DATE),
  `Amount` DECIMAL(10,2)
);

CREATE TABLE `Review` (
  `ReviewId` INT PRIMARY KEY AUTO_INCREMENT,
  `UserId` INT,
  `WorkspaceId` INT,
  `Rating` DECIMAL(2,1),
  `Comments` TEXT,
  `ReviewDate` DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE `Request` (
  `RequestId` INT PRIMARY KEY AUTO_INCREMENT,
  `UserId` INT,
  `StaffId` INT,
  `Details` TEXT,
  `Status` VARCHAR(20) DEFAULT 'Open',
  `RequestType` VARCHAR(50),
  `RequestDate` DATE DEFAULT (CURRENT_DATE),
  `ResponseDate` DATE
);

CREATE TABLE `Cancellation` (
  `CancellationId` INT PRIMARY KEY AUTO_INCREMENT,
  `UserId` INT,
  `BookingId` INT,
  `CancellationDate` DATE DEFAULT (CURRENT_DATE),
  `Fees` DECIMAL(8,2)
);

-- Foreign Key Constraints
ALTER TABLE `LoyaltyPoints` ADD FOREIGN KEY (`UserId`) REFERENCES `User` (`UserId`);
ALTER TABLE `Preference` ADD FOREIGN KEY (`UserId`) REFERENCES `User` (`UserId`);
ALTER TABLE `WorkspaceImages` ADD FOREIGN KEY (`WorkspaceId`) REFERENCES `Workspace` (`WorkspaceId`);
ALTER TABLE `WorkspaceImages` ADD FOREIGN KEY (`StaffId`) REFERENCES `WorkspaceStaff` (`StaffId`);
ALTER TABLE `Offer` ADD FOREIGN KEY (`RoomId`) REFERENCES `Room` (`RoomId`);
ALTER TABLE `Offer` ADD FOREIGN KEY (`StaffId`) REFERENCES `WorkspaceStaff` (`StaffId`);
ALTER TABLE `WorkspaceAnalytics` ADD FOREIGN KEY (`WorkspaceId`) REFERENCES `Workspace` (`WorkspaceId`);
ALTER TABLE `Room` ADD FOREIGN KEY (`WorkspaceId`) REFERENCES `Workspace` (`WorkspaceId`);
ALTER TABLE `WorkspacePlan` ADD FOREIGN KEY (`WorkspaceId`) REFERENCES `Workspace` (`WorkspaceId`);
ALTER TABLE `RoomImages` ADD FOREIGN KEY (`RoomId`) REFERENCES `Room` (`RoomId`);
ALTER TABLE `Amenities` ADD FOREIGN KEY (`RoomId`) REFERENCES `Room` (`RoomId`);
ALTER TABLE `AmenityImages` ADD FOREIGN KEY (`AmenityId`) REFERENCES `Amenities` (`AmenityId`);
ALTER TABLE `Reservation` ADD FOREIGN KEY (`UserId`) REFERENCES `User` (`UserId`);
ALTER TABLE `Reservation` ADD FOREIGN KEY (`RoomId`) REFERENCES `Room` (`RoomId`);
ALTER TABLE `Reservation` ADD FOREIGN KEY (`WorkspaceId`) REFERENCES `Workspace` (`WorkspaceId`);
ALTER TABLE `Payment` ADD FOREIGN KEY (`UserId`) REFERENCES `User` (`UserId`);
ALTER TABLE `Invoice` ADD FOREIGN KEY (`PaymentId`) REFERENCES `Payment` (`PaymentId`);
ALTER TABLE `Invoice` ADD FOREIGN KEY (`BookingId`) REFERENCES `Reservation` (`BookingId`);
ALTER TABLE `Review` ADD FOREIGN KEY (`UserId`) REFERENCES `User` (`UserId`);
ALTER TABLE `Review` ADD FOREIGN KEY (`WorkspaceId`) REFERENCES `Workspace` (`WorkspaceId`);
ALTER TABLE `Request` ADD FOREIGN KEY (`UserId`) REFERENCES `User` (`UserId`);
ALTER TABLE `Request` ADD FOREIGN KEY (`StaffId`) REFERENCES `WorkspaceStaff` (`StaffId`);
ALTER TABLE `Cancellation` ADD FOREIGN KEY (`UserId`) REFERENCES `User` (`UserId`);
ALTER TABLE `Cancellation` ADD FOREIGN KEY (`BookingId`) REFERENCES `Reservation` (`BookingId`);


-- Insert Some Data 
INSERT INTO `Workspace` (
  `Name`, `Description`, `Longitude`, `Latitude`, `Type`, `Location`, `CreateDate`, `AvgRating`) VALUES
('TechHub Central', 'Modern coworking space with high-speed internet and meeting rooms', -74.006015, 40.712776, 'Coworking Space', 
 'New York', '2023-01-15', 4.75),
('CreativeSpace Downtown', 'Artistic workspace with photography studio and maker labs', -118.243683, 34.052235, 'Creative Studio', 
 'Los Angeles', '2022-11-01', 4.85),
('Innovation Station', 'Tech-focused workspace with VR lab and prototyping equipment', -122.419418, 37.774929, 'Tech Hub', 
 'San Francisco', '2023-03-10', 4.90);