 CREATE DATABASE Roomly;

-- DROP DATABASE Roomly;

USE Roomly;

-- Create all tables without foreign keys
CREATE TABLE User (
    Id VARCHAR(100) PRIMARY KEY,
    FName VARCHAR(255),
    LName VARCHAR(255),
    Email VARCHAR(255) UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Phone VARCHAR(15),
    Address varchar(100)
);

CREATE TABLE Workspace (
    Id VARCHAR(100) PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Address VARCHAR(255),
    CreatedDate DATE,
    AvgRating DOUBLE,
    Type VARCHAR(100),
    PaymentType varchar(100),
    LocationId VARCHAR(100)
);

CREATE TABLE WorkspaceStaff (
    Id VARCHAR(100) PRIMARY KEY,
    FName VARCHAR(255) NOT NULL,
    LName VARCHAR(255) NOT NULL,
    Name VARCHAR(255),
    Email VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Phone VARCHAR(15),
    Type VARCHAR(100)
);

CREATE TABLE Request (
    Id VARCHAR(100) PRIMARY KEY,
    RequestType VARCHAR(255),
    RequestDate DATETIME,
    ResponseDate DATETIME,
    Details TEXT,
    Status VARCHAR(50),
    RequestResponse TEXT
);

CREATE TABLE Offers (
    Id VARCHAR(100) PRIMARY KEY,
    OfferTitle VARCHAR(255),
    Description TEXT,
    DiscountPercentage DOUBLE,
    ValidFrom DATE,
    ValidTo DATE,
    Status VARCHAR(50)
);

CREATE TABLE Amenity (
    Id VARCHAR(100) PRIMARY KEY,
    Name VARCHAR(255),
    Type VARCHAR(255),
    Description TEXT,
    TotalCount INT,
    RoomId VARCHAR(100)
);

CREATE TABLE Room (
    Id VARCHAR(100) PRIMARY KEY,
    Name VARCHAR(100),
    Type VARCHAR(255),
    Description TEXT,
    Capacity INT,
    AvailableCount INT,
    PricePerHour DOUBLE,
    RoomStatus VARCHAR(50),
    WorkspaceId VARCHAR(100)
);

CREATE TABLE WorkspaceAnalytics (
    WorkspaceId VARCHAR(100),
    `Date` DATE,
    AverageRating DOUBLE,
    TotalRevenue DOUBLE,
    TotalBookings INT,
    UsagePatterns TEXT
);

CREATE TABLE WorkspacePlan (
    WorkspaceId VARCHAR(100),
    DailyPrice Double,
    YearPrice DOUBLE,
    MonthPrice DOUBLE
);

CREATE TABLE Location (
    Id VARCHAR(100) PRIMARY KEY,
    Longitude DOUBLE,
    Latitude DOUBLE,
    City VARCHAR(255),
    Town VARCHAR(255),
    Country VARCHAR(255)
);

CREATE TABLE Preference (
    BudgetPreference VARCHAR(255),
    WorkspaceTypePreference VARCHAR(255),
    UserId VARCHAR(100)
);

CREATE TABLE Reservation (
    Id VARCHAR(100) PRIMARY KEY,
    BookingDate DATE,
    StartTime DATETIME,
    EndTime DATETIME,
    Status VARCHAR(50),
    TotalCost DOUBLE,
    AmenitiesCount INT
);

CREATE TABLE Payment (
    Id VARCHAR(100) PRIMARY KEY,
    PaymentDate DATE,
    PaymentMethod VARCHAR(255),
    Amount DOUBLE,
    Status VARCHAR(50),
    ReservationId VARCHAR(100)
);

CREATE TABLE LoyaltyPoints (
    TotalPoints INT,
    LastAddedPoint INT,
    LastUpdatedDate DATETIME,
    UserId VARCHAR(100)
);

CREATE TABLE Cancellation (
    Fees DOUBLE,
    CancellationDate DATETIME,
    UserId VARCHAR(100),
    ReservationId VARCHAR(100)
);

CREATE TABLE Booking (
    UserId VARCHAR(100),
    ReservationId VARCHAR(100),
    WorkspaceId VARCHAR(100),
    RoomId VARCHAR(100)
);

CREATE TABLE UserRequesting (
    UserId VARCHAR(100),
    RequestId VARCHAR(100),
    StaffId VARCHAR(100)
);

CREATE TABLE SuspendedUsers (
    UserId VARCHAR(100),
    StaffId VARCHAR(100)
);

CREATE TABLE Review (
    Id VARCHAR(100) PRIMARY KEY,
    Rating DOUBLE,
    Comment TEXT,
    ReviewDate DATE,
    UserId VARCHAR(100),
    WorkspaceId VARCHAR(100)
);

CREATE TABLE FavouriteWorkspaceRooms (
    UserId VARCHAR(100),
    WorkspaceId VARCHAR(100),
    RoomId VARCHAR(100)
);

CREATE TABLE WorkspaceSupervise (
    StaffId VARCHAR(100),
    WorkspaceId VARCHAR(100)
);

CREATE TABLE Images (
    ImageUrl VARCHAR(255) ,
    StaffId VARCHAR(100),
    WorkspaceId VARCHAR(100),
    RoomId VARCHAR(100) null,
    AmenityId VARCHAR(100) null 
);

CREATE TABLE ApplyedOffers (
    StaffId VARCHAR(50),
    RoomId VARCHAR(50),
    OfferId VARCHAR(50)
);

CREATE TABLE WorkspaceSchedule (
	Day varchar(100),
    StartTime time,
    EndTime time,
    WorkspaceId VARCHAR(100)
);

-- Add foreign key constraints using ALTER TABLE
ALTER TABLE Workspace ADD CONSTRAINT fk_workspace_location FOREIGN KEY (LocationId) REFERENCES Location(Id);
ALTER TABLE Amenity ADD CONSTRAINT fk_amenity_room FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE Room ADD CONSTRAINT fk_room_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE WorkspaceAnalytics ADD CONSTRAINT fk_workspaceanalytics_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE WorkspacePlan ADD CONSTRAINT fk_workspaceplan_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE Preference ADD CONSTRAINT fk_preference_user FOREIGN KEY (UserId) REFERENCES User(Id);
ALTER TABLE Payment ADD CONSTRAINT fk_payment_reservation FOREIGN KEY (ReservationId) REFERENCES Reservation(Id);
ALTER TABLE LoyaltyPoints ADD CONSTRAINT fk_loyaltypoints_user FOREIGN KEY (UserId) REFERENCES User(Id);
ALTER TABLE Cancellation ADD CONSTRAINT fk_cancellation_user FOREIGN KEY (UserId) REFERENCES User(Id);
ALTER TABLE Cancellation ADD CONSTRAINT fk_cancellation_reservation FOREIGN KEY (ReservationId) REFERENCES Reservation(Id);
ALTER TABLE Booking ADD CONSTRAINT fk_booking_user FOREIGN KEY (UserId) REFERENCES User(Id);
ALTER TABLE Booking ADD CONSTRAINT fk_booking_reservation FOREIGN KEY (ReservationId) REFERENCES Reservation(Id);
ALTER TABLE Booking ADD CONSTRAINT fk_booking_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE Booking ADD CONSTRAINT fk_booking_room FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE UserRequesting ADD CONSTRAINT fk_userrequesting_user FOREIGN KEY (UserId) REFERENCES User(Id);
ALTER TABLE UserRequesting ADD CONSTRAINT fk_userrequesting_request FOREIGN KEY (RequestId) REFERENCES Request(Id);
ALTER TABLE UserRequesting ADD CONSTRAINT fk_userrequesting_staff FOREIGN KEY (StaffId) REFERENCES WorkspaceStaff(Id);
ALTER TABLE SuspendedUsers ADD CONSTRAINT fk_suspendedusers_user FOREIGN KEY (UserId) REFERENCES User(Id);
ALTER TABLE SuspendedUsers ADD CONSTRAINT fk_suspendedusers_staff FOREIGN KEY (StaffId) REFERENCES WorkspaceStaff(Id);
ALTER TABLE Review ADD CONSTRAINT fk_review_user FOREIGN KEY (UserId) REFERENCES User(Id);
ALTER TABLE Review ADD CONSTRAINT fk_review_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE FavouriteWorkspaceRooms ADD CONSTRAINT fk_favouriteworkspacesrooms_user FOREIGN KEY (UserId) REFERENCES User(Id);
ALTER TABLE FavouriteWorkspaceRooms ADD CONSTRAINT fk_favouriteworkspacesrooms_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE FavouriteWorkspaceRooms ADD CONSTRAINT fk_favouriteworkspacesrooms_room FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE WorkspaceSupervise ADD CONSTRAINT fk_workspacesupervise_staff FOREIGN KEY (StaffId) REFERENCES WorkspaceStaff(Id);
ALTER TABLE WorkspaceSupervise ADD CONSTRAINT fk_workspacesupervise_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE Images ADD CONSTRAINT fk_images_staff FOREIGN KEY (StaffId) REFERENCES WorkspaceStaff(Id);
ALTER TABLE Images ADD CONSTRAINT fk_images_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE Images ADD CONSTRAINT fk_images_room FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE Images ADD CONSTRAINT fk_images_amenity FOREIGN KEY (AmenityId) REFERENCES Amenity(Id);
ALTER TABLE ApplyedOffers ADD CONSTRAINT fk_applyedoffers_staff FOREIGN KEY (StaffId) REFERENCES WorkspaceStaff(Id);
ALTER TABLE ApplyedOffers ADD CONSTRAINT fk_applyedoffers_room FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE ApplyedOffers ADD CONSTRAINT fk_applyedoffers_offer FOREIGN KEY (OfferId) REFERENCES Offers(Id);
ALTER TABLE WorkspaceSchedule ADD CONSTRAINT fk_workspaceschedule_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
