use roomly;

-- ALTER TABLE Bank
-- ADD PRIMARY KEY (CarNumber);
CREATE TABLE CreditCards (
    creditId CHAR(16) NOT NULL,
    userId varchar(255) NOT NULL,
    FOREIGN KEY (creditId) REFERENCES Bank(CarNumber),
    FOREIGN KEY (userId) REFERENCES user(Id)
);


INSERT INTO CreditCards (creditId, userId) VALUES
('1234567812345678', 'usr001'),
('2345678923456789', 'usr002'),
('3456789034567890', 'usr003');