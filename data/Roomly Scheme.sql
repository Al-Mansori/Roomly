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
    AmenitiesCount INT,
    AccessCode varchar(6),
    ReservationType VARCHAR(50)
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

CREATE TABLE Apply (
    StaffId VARCHAR(50),
    RoomId VARCHAR(50),
    OfferId VARCHAR(50)
);

CREATE TABLE WorkspaceSchedule (
	Day varchar(100),
    StartTime varchar(5),
    EndTime varchar(5),
    WorkspaceId VARCHAR(100)
);

CREATE TABLE CreditCard (
    CardNumber CHAR(16) primary key,
    CVV CHAR(3) NOT NULL, 
    EndDate varchar(7) NOT NULL,
    Balance DOUBLE
);

CREATE TABLE UserCards (
    CardNumber CHAR(16),
    UserId varchar(100),
    FOREIGN KEY (CardNumber) REFERENCES CreditCard(CardNumber),
    FOREIGN KEY (UserId) REFERENCES user(Id) on delete cascade
);

CREATE TABLE Recovery (
	RoomId varchar(100),
    RecoveryRoomId varchar(100),
    Reason varchar(100) default 'Maintenance'
);

CREATE TABLE RoomAvailability (
    RoomId VARCHAR(100) NOT NULL,
    Date DATE NOT NULL,
    Hour INT NOT NULL,
    AvailableSeats INT NOT NULL,
    RoomStatus VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    PRIMARY KEY (RoomId, Date, Hour)
);


-- Add foreign key constraints using ALTER TABLE
ALTER TABLE Workspace ADD CONSTRAINT fk_workspace_location FOREIGN KEY (LocationId) REFERENCES Location(Id);
ALTER TABLE Amenity ADD CONSTRAINT fk_amenity_room FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE Room ADD CONSTRAINT fk_room_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE WorkspaceAnalytics ADD CONSTRAINT fk_workspaceanalytics_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE WorkspacePlan ADD CONSTRAINT fk_workspaceplan_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE Preference ADD CONSTRAINT fk_preference_user FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE;
ALTER TABLE Payment ADD CONSTRAINT fk_payment_reservation FOREIGN KEY (ReservationId) REFERENCES Reservation(Id);
ALTER TABLE LoyaltyPoints ADD CONSTRAINT fk_loyaltypoints_user FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE;
ALTER TABLE Cancellation ADD CONSTRAINT fk_cancellation_user FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE;
ALTER TABLE Cancellation ADD CONSTRAINT fk_cancellation_reservation FOREIGN KEY (ReservationId) REFERENCES Reservation(Id);
ALTER TABLE Booking ADD CONSTRAINT fk_booking_user FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE;
ALTER TABLE Booking ADD CONSTRAINT fk_booking_reservation FOREIGN KEY (ReservationId) REFERENCES Reservation(Id);
ALTER TABLE Booking ADD CONSTRAINT fk_booking_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE Booking ADD CONSTRAINT fk_booking_room FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE UserRequesting ADD CONSTRAINT fk_userrequesting_user FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE;
ALTER TABLE UserRequesting ADD CONSTRAINT fk_userrequesting_request FOREIGN KEY (RequestId) REFERENCES Request(Id);
ALTER TABLE UserRequesting ADD CONSTRAINT fk_userrequesting_staff FOREIGN KEY (StaffId) REFERENCES WorkspaceStaff(Id);
ALTER TABLE SuspendedUsers ADD CONSTRAINT fk_suspendedusers_user FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE;
ALTER TABLE SuspendedUsers ADD CONSTRAINT fk_suspendedusers_staff FOREIGN KEY (StaffId) REFERENCES WorkspaceStaff(Id);
ALTER TABLE Review ADD CONSTRAINT fk_review_user FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE;
ALTER TABLE Review ADD CONSTRAINT fk_review_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE FavouriteWorkspaceRooms ADD CONSTRAINT fk_favouriteworkspacesrooms_user FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE;
ALTER TABLE FavouriteWorkspaceRooms ADD CONSTRAINT fk_favouriteworkspacesrooms_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE FavouriteWorkspaceRooms ADD CONSTRAINT fk_favouriteworkspacesrooms_room FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE WorkspaceSupervise ADD CONSTRAINT fk_workspacesupervise_staff FOREIGN KEY (StaffId) REFERENCES WorkspaceStaff(Id);
ALTER TABLE WorkspaceSupervise ADD CONSTRAINT fk_workspacesupervise_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE Images ADD CONSTRAINT fk_images_staff FOREIGN KEY (StaffId) REFERENCES WorkspaceStaff(Id);
ALTER TABLE Images ADD CONSTRAINT fk_images_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE Images ADD CONSTRAINT fk_images_room FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE Images ADD CONSTRAINT fk_images_amenity FOREIGN KEY (AmenityId) REFERENCES Amenity(Id);
ALTER TABLE Apply ADD CONSTRAINT fk_apply_staff FOREIGN KEY (StaffId) REFERENCES WorkspaceStaff(Id);
ALTER TABLE Apply ADD CONSTRAINT fk_apply_room FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE Apply ADD CONSTRAINT fk_apply_offer FOREIGN KEY (OfferId) REFERENCES Offers(Id);
ALTER TABLE WorkspaceSchedule ADD CONSTRAINT fk_workspaceschedule_workspace FOREIGN KEY (WorkspaceId) REFERENCES Workspace(Id);
ALTER TABLE UserCards ADD CONSTRAINT fk_usercards_cardnumber FOREIGN KEY (CardNumber) REFERENCES CreditCard(CardNumber);
ALTER TABLE UserCards ADD CONSTRAINT fk_usercards_user FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE;
ALTER TABLE Recovery ADD CONSTRAINT fk_recovery_room1 FOREIGN KEY (RoomId) REFERENCES Room(Id);
ALTER TABLE Recovery ADD CONSTRAINT fk_recovery_room2 FOREIGN KEY (RecoveryRoomId) REFERENCES Room(Id);
ALTER TABLE RoomAvailability ADD CONSTRAINT fk_roomavailability_room FOREIGN KEY (RoomId) REFERENCES Room(Id);