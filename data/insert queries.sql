INSERT INTO User (Id, FName, LName, Email, Password, Phone, Address)
VALUES ('user1', 'John', 'Doe', 'john.doe@example.com', 'password123', '1234567890', '123 Main St');

INSERT INTO WorkspaceStaff (Id, FName, LName, Name, Email, Password, Phone, Type)
VALUES ('staff1', 'Jane', 'Doe', 'Jane Doe', 'jane.doe@example.com', 'password123', '9876543210', 'Admin');

INSERT INTO Location (Id, Longitude, Latitude, City, Town, Country)
VALUES ('loc1', -73.935242, 40.730610, 'New York', 'Manhattan', 'USA');

INSERT INTO Workspace (Id, Name, Description, Address, CreatedDate, AvgRating, Type, LocationId)
VALUES ('ws1', 'Cozy Workspace', 'A cozy workspace in Manhattan', '456 Broadway', '2023-01-01', 4.5, 'Shared', 'loc1');

INSERT INTO Room (Id, Name, Type, Description, Capacity, AvailableCount, PricePerHour, RoomStatus, WorkspaceId)
VALUES ('room1', 'Conference Room', 'Meeting', 'A spacious conference room', 10, 5, 50.0, 'Available', 'ws1');

INSERT INTO Amenity (Id, Name, Type, Description, TotalCount, RoomId)
VALUES ('amenity1', 'Projector', 'Tech', 'High-quality projector', 2, 'room1');

INSERT INTO Images (ImageUrl, StaffId, WorkspaceId, RoomId, AmenityId)
VALUES ('https://example.com/workspace1.jpg', 'staff1', 'ws1', NULL, NULL);

INSERT INTO Images (ImageUrl, StaffId, WorkspaceId, RoomId, AmenityId)
VALUES ('https://example.com/room1.jpg', 'staff1', 'ws1', 'room1', NULL);

INSERT INTO Images (ImageUrl, StaffId, WorkspaceId, RoomId, AmenityId)
VALUES ('https://example.com/projector.jpg', 'staff1', 'ws1', NULL, 'amenity1');
