-- Use the Roomly database
USE Roomly;

-- Insert data for Location table
INSERT INTO Location VALUES
('loc001', 31.2357, 30.0444, 'Cairo', 'Downtown', 'Egypt'),
('loc002', 31.2431, 30.0581, 'Cairo', 'Garden City', 'Egypt'),
('loc003', 31.2242, 30.0546, 'Cairo', 'Maadi', 'Egypt'),
('loc004', 31.2162, 30.0611, 'Cairo', 'New Cairo', 'Egypt'),
('loc005', 31.2233, 30.0370, 'Cairo', 'Dokki', 'Egypt'),
('loc006', 31.3522, 30.0858, 'Cairo', 'Heliopolis', 'Egypt'),
('loc007', 29.9187, 31.2004, 'Alexandria', 'Smouha', 'Egypt'),
('loc008', 29.9098, 31.1784, 'Alexandria', 'Downtown', 'Egypt'),
('loc009', 32.2994, 31.1293, 'Hurghada', 'Downtown', 'Egypt'),
('loc010', 34.3418, 28.7232, 'Sharm El Sheikh', 'Naama Bay', 'Egypt'),
('loc011', 30.8084, 29.0296, 'Luxor', 'Downtown', 'Egypt'),
('loc012', 31.1974, 29.9619, 'Cairo', '6th of October', 'Egypt'),
('loc013', 31.3435, 30.1101, 'Cairo', 'Nasr City', 'Egypt'),
('loc014', 32.7278, 25.7030, 'Aswan', 'Downtown', 'Egypt'),
('loc015', 31.2510, 30.0586, 'Cairo', 'Zamalek', 'Egypt');

-- Insert data for Workspace table
INSERT INTO Workspace VALUES
('ws001', 'The Greek Campus', 'Tech innovation hub located in the heart of Downtown Cairo', '28 Falaki St, Cairo', '2020-01-15', 4.6, 'Tech Hub', 'loc001'),
('ws002', 'AlMaqarr Coworking Space - Garden City', 'Elegant coworking space in Garden City', '17 Mahmoud Bassiouny St, Garden City', '2018-05-20', 4.5, 'Coworking', 'loc002'),
('ws003', 'The District Spaces', 'Modern workspace with premium amenities', '21 Road 13, Maadi', '2019-08-10', 4.7, 'Premium', 'loc003'),
('ws004', 'Cairo Hackerspace', 'Community-driven workspace for tech enthusiasts', '12 Street 272, New Cairo', '2017-03-25', 4.3, 'Tech Community', 'loc004'),
('ws005', 'Urban Station Egypt', 'Comfortable workspaces with an urban vibe', '7 Dokki St, Dokki', '2019-11-05', 4.4, 'Urban Style', 'loc005'),
('ws006', 'Seedspace Cairo', 'Global community for entrepreneurs', '8 El-Salam St, Heliopolis', '2020-02-28', 4.5, 'Entrepreneurial', 'loc006'),
('ws007', 'IceAlex', 'Innovation hub in Alexandria focusing on community projects', '52 El Horeya Road, Smouha', '2018-06-10', 4.2, 'Innovation Hub', 'loc007'),
('ws008', 'Indoors Alexandria', 'Creative workspace for digital nomads', '12 Victor Emanuel St, Downtown Alexandria', '2019-07-15', 4.3, 'Creative', 'loc008'),
('ws009', 'Red Sea Coworking', 'Beachside workspace for digital nomads', '23 Village Rd, Hurghada', '2021-01-05', 4.8, 'Tourist-Friendly', 'loc009'),
('ws010', 'Sharm Workspace', 'Resort-style workspace with sea views', '19 Peace Rd, Naama Bay', '2021-03-12', 4.9, 'Private Office', 'loc010'),
('ws011', 'Luxor Innovation Hub', 'Cultural and historical workspace', '14 Karnak Temple St, Luxor', '2020-10-22', 4.1, 'Cultural', 'loc011'),
('ws012', 'A4 Spaces - October', 'Modern workspace in 6th of October City', 'Mall of Egypt, 6th of October', '2019-12-10', 4.3, 'Mall-based', 'loc012'),
('ws013', 'The Workstation', 'Professional environment for startups and SMEs', '12 Makram Ebeid St, Nasr City', '2020-04-15', 4.5, 'Professional', 'loc013'),
('ws014', 'Nile Workspace Aswan', 'Riverside coworking space with Nile views', '9 Corniche El Nile, Aswan', '2021-02-20', 4.6, 'Scenic', 'loc014'),
('ws015', 'ZSpace', 'Boutique workspace in upscale Zamalek', '15 Taha Hussein St, Zamalek', '2019-09-18', 4.7, 'Boutique', 'loc015');

-- Insert data for WorkspaceStaff table
INSERT INTO WorkspaceStaff VALUES
('stf001', 'Ahmed', 'Ibrahim', 'Ahmed Ibrahim', 'ahmed.ibrahim@greekcampus.com', 'pass123', '+20100123456', 'Manager'),
('stf002', 'Laila', 'Mostafa', 'Laila Mostafa', 'laila.mostafa@almaqarr.com', 'pass234', '+20111234567', 'Receptionist'),
('stf003', 'Mohamed', 'Hassan', 'Mohamed Hassan', 'mohamed.hassan@district.com', 'pass345', '+20122345678', 'Manager'),
('stf004', 'Nour', 'Mahmoud', 'Nour Mahmoud', 'nour.mahmoud@cairohackerspace.com', 'pass456', '+20103456789', 'IT Support'),
('stf005', 'Omar', 'Samir', 'Omar Samir', 'omar.samir@urbanstation.com', 'pass567', '+20114567890', 'Manager'),
('stf006', 'Rania', 'Ahmed', 'Rania Ahmed', 'rania.ahmed@seedspace.com', 'pass678', '+20125678901', 'Event Coordinator'),
('stf007', 'Tarek', 'Zaki', 'Tarek Zaki', 'tarek.zaki@icealex.com', 'pass789', '+20106789012', 'Manager'),
('stf008', 'Yasmine', 'Adel', 'Yasmine Adel', 'yasmine.adel@indoors.com', 'pass890', '+20117890123', 'Community Manager'),
('stf009', 'Hassan', 'Medhat', 'Hassan Medhat', 'hassan.medhat@redseacoworking.com', 'pass901', '+20128901234', 'Manager'),
('stf010', 'Dina', 'Essam', 'Dina Essam', 'dina.essam@sharmworkspace.com', 'pass012', '+20109012345', 'Receptionist'),
('stf011', 'Karim', 'Fawzy', 'Karim Fawzy', 'karim.fawzy@luxorhub.com', 'pass123', '+20110123456', 'Manager'),
('stf012', 'Sara', 'Hany', 'Sara Hany', 'sara.hany@a4spaces.com', 'pass234', '+20121234567', 'Assistant Manager'),
('stf013', 'Amr', 'Khaled', 'Amr Khaled', 'amr.khaled@workstation.com', 'pass345', '+20102345678', 'Manager'),
('stf014', 'Heba', 'Nader', 'Heba Nader', 'heba.nader@nileworkspace.com', 'pass456', '+20113456789', 'Receptionist'),
('stf015', 'Sherif', 'Gamal', 'Sherif Gamal', 'sherif.gamal@zspace.com', 'pass567', '+20124567890', 'Manager');

-- Insert data for User table
INSERT INTO User VALUES
('usr001', 'Mahmoud', 'Ali', 'mahmoud.ali@example.com', 'user123', '+20100111222', 'Heliopolis, Cairo'),
('usr002', 'Fatma', 'Mohamed', 'fatma.mohamed@example.com', 'user234', '+20111222333', 'Maadi, Cairo'),
('usr003', 'Khaled', 'Ibrahim', 'khaled.ibrahim@example.com', 'user345', '+20122333444', 'Dokki, Cairo'),
('usr004', 'Amina', 'Hassan', 'amina.hassan@example.com', 'user456', '+20103444555', 'Smouha, Alexandria'),
('usr005', 'Mostafa', 'Youssef', 'mostafa.youssef@example.com', 'user567', '+20114555666', 'Downtown, Cairo'),
('usr006', 'Salma', 'Karim', 'salma.karim@example.com', 'user678', '+20125666777', 'New Cairo'),
('usr007', 'Youssef', 'Ahmed', 'youssef.ahmed@example.com', 'user789', '+20106777888', 'Nasr City, Cairo'),
('usr008', 'Nada', 'Salem', 'nada.salem@example.com', 'user890', '+20117888999', 'Downtown Alexandria'),
('usr009', 'Tamer', 'Hossam', 'tamer.hossam@example.com', 'user901', '+20128999000', 'Hurghada'),
('usr010', 'Mona', 'Tarek', 'mona.tarek@example.com', 'user012', '+20109000111', 'Sharm El Sheikh'),
('usr011', 'Hesham', 'Nabil', 'hesham.nabil@example.com', 'user123', '+20110111222', 'Luxor'),
('usr012', 'Rana', 'Essam', 'rana.essam@example.com', 'user234', '+20121222333', '6th of October, Cairo'),
('usr013', 'Amr', 'Magdy', 'amr.magdy@example.com', 'user345', '+20102333444', 'Nasr City, Cairo'),
('usr014', 'Dalia', 'Ihab', 'dalia.ihab@example.com', 'user456', '+20113444555', 'Aswan'),
('usr015', 'Mohamed', 'Samy', 'mohamed.samy@example.com', 'user567', '+20124555666', 'Zamalek, Cairo'),
('usr016', 'Hend', 'Omar', 'hend.omar@example.com', 'user678', '+20105666777', 'Garden City, Cairo'),
('usr017', 'Ayman', 'Sherif', 'ayman.sherif@example.com', 'user789', '+20116777888', 'Maadi, Cairo'),
('usr018', 'Noha', 'Mohsen', 'noha.mohsen@example.com', 'user890', '+20127888999', 'New Cairo'),
('usr019', 'Waleed', 'Hamdy', 'waleed.hamdy@example.com', 'user901', '+20108999000', 'Heliopolis, Cairo'),
('usr020', 'Ghada', 'Farouk', 'ghada.farouk@example.com', 'user012', '+20119000111', 'Smouha, Alexandria');

-- Insert data for Room table
INSERT INTO Room VALUES
('rm001', 'Innovation Lab', 'Conference Room', 'Large conference room with modern equipment', 30, 30, 200.00, 'Available', 'ws001'),
('rm002', 'Entrepreneurship Hub', 'Meeting Room', 'Medium-sized meeting room for team discussions', 12, 12, 150.00, 'Available', 'ws001'),
('rm003', 'Startup Corner', 'Open Space', 'Open workspace with multiple desks', 20, 15, 100.00, 'Available', 'ws001'),
('rm004', 'Garden View', 'Private Office', 'Quiet office with garden view', 6, 6, 180.00, 'Available', 'ws002'),
('rm005', 'Cairo Skyline', 'Conference Room', 'Large room with city views', 25, 25, 220.00, 'Available', 'ws002'),
('rm006', 'Creative Zone', 'Open Space', 'Open plan workspace for creatives', 15, 10, 120.00, 'Available', 'ws002'),
('rm007', 'Executive Suite', 'Private Office', 'Premium private office for executives', 4, 4, 250.00, 'Available', 'ws003'),
('rm008', 'Brainstorm Room', 'Meeting Room', 'Room designed for creative thinking', 10, 10, 160.00, 'Available', 'ws003'),
('rm009', 'Tech Hub', 'Open Space', 'Tech-focused open workspace', 18, 12, 110.00, 'Available', 'ws003'),
('rm010', 'Developer Den', 'Open Space', 'Workspace designed for developers', 20, 18, 100.00, 'Available', 'ws004'),
('rm011', 'Code Lab', 'Meeting Room', 'Specialized room for coding workshops', 15, 15, 170.00, 'Available', 'ws004'),
('rm012', 'Urban Loft', 'Open Space', 'Industrial style open workspace', 25, 20, 110.00, 'Available', 'ws005'),
('rm013', 'City View', 'Conference Room', 'Large conference room with city view', 28, 28, 210.00, 'Available', 'ws005'),
('rm014', 'Seed Lab', 'Meeting Room', 'Medium meeting room for startups', 10, 10, 150.00, 'Available', 'ws006'),
('rm015', 'Growth Studio', 'Private Office', 'Office for growing startups', 8, 8, 190.00, 'Available', 'ws006'),
('rm016', 'Alexandria Room', 'Conference Room', 'Large room with Mediterranean theme', 24, 24, 200.00, 'Available', 'ws007'),
('rm017', 'Innovation Space', 'Open Space', 'Open workspace for innovators', 20, 16, 100.00, 'Available', 'ws007'),
('rm018', 'Creative Studio', 'Meeting Room', 'Room designed for creative professionals', 12, 12, 160.00, 'Available', 'ws008'),
('rm019', 'Digital Nomad Zone', 'Open Space', 'Open area for digital nomads', 22, 18, 90.00, 'Available', 'ws008'),
('rm020', 'Sea View', 'Conference Room', 'Conference room with Red Sea views', 20, 20, 240.00, 'Available', 'ws009'),
('rm021', 'Beach Work', 'Open Space', 'Open workspace with coastal vibes', 18, 15, 120.00, 'Available', 'ws009'),
('rm022', 'Coral Meeting', 'Meeting Room', 'Meeting room with coral reef theme', 10, 10, 180.00, 'Available', 'ws010'),
('rm023', 'Resort Office', 'Private Office', 'Private office with resort atmosphere', 6, 6, 220.00, 'Available', 'ws010'),
('rm024', 'Pharaoh Room', 'Conference Room', 'Egyptian themed conference room', 22, 22, 210.00, 'Available', 'ws011'),
('rm025', 'Nile View', 'Open Space', 'Open workspace with historical themes', 16, 14, 110.00, 'Available', 'ws011'),
('rm026', 'October Suite', 'Private Office', 'Private office in October City', 5, 5, 170.00, 'Available', 'ws012'),
('rm027', 'Mall View', 'Conference Room', 'Conference room with mall view', 18, 18, 190.00, 'Available', 'ws012'),
('rm028', 'Professional Hub', 'Meeting Room', 'Business-focused meeting room', 14, 14, 160.00, 'Available', 'ws013'),
('rm029', 'Work Station', 'Open Space', 'Professional open workspace', 20, 16, 110.00, 'Available', 'ws013'),
('rm030', 'Riverside Room', 'Conference Room', 'Conference room with Nile views', 24, 24, 230.00, 'Available', 'ws014'),
('rm031', 'Nubian Office', 'Private Office', 'Private office with Nubian design', 6, 6, 200.00, 'Available', 'ws014'),
('rm032', 'Boutique Suite', 'Private Office', 'Upscale private office in Zamalek', 4, 4, 260.00, 'Available', 'ws015'),
('rm033', 'Island View', 'Conference Room', 'Conference room with island views', 20, 20, 240.00, 'Available', 'ws015'),
('rm034', 'Art Space', 'Open Space', 'Artistic open workspace', 15, 12, 130.00, 'Available', 'ws015');

-- Insert data for Amenity table
INSERT INTO Amenity VALUES
('am001', 'High-Speed WiFi', 'Technology', 'Fast internet connection for all users', 1, 'rm001'),
('am002', 'Smart TV', 'Technology', '65-inch 4K smart TV for presentations', 1, 'rm001'),
('am003', 'Whiteboard', 'Office Equipment', 'Large whiteboard for brainstorming', 1, 'rm001'),
('am004', 'Coffee Machine', 'Food & Beverage', 'Premium coffee maker', 1, 'rm002'),
('am005', 'Projector', 'Technology', 'HD projector for presentations', 1, 'rm002'),
('am006', 'Ergonomic Chairs', 'Furniture', 'Comfortable ergonomic office chairs', 20, 'rm003'),
('am007', 'Standing Desks', 'Furniture', 'Adjustable height desks', 5, 'rm003'),
('am008', 'Air Purifier', 'Environment', 'HEPA air purification system', 1, 'rm004'),
('am009', 'Private Bathroom', 'Facilities', 'En-suite bathroom', 1, 'rm004'),
('am010', 'Conference Phone', 'Technology', 'High-quality conferencing system', 1, 'rm005'),
('am011', 'Digital Whiteboard', 'Technology', 'Interactive digital whiteboard', 1, 'rm005'),
('am012', 'Lounge Area', 'Facilities', 'Comfortable seating area', 1, 'rm006'),
('am013', 'Printing Station', 'Office Equipment', 'Color printer and scanner', 1, 'rm006'),
('am014', 'Executive Desk', 'Furniture', 'Premium executive desk', 1, 'rm007'),
('am015', 'Private Phone Booth', 'Facilities', 'Soundproof booth for calls', 1, 'rm007'),
('am016', 'Idea Wall', 'Office Equipment', 'Wall-sized whiteboard for ideation', 1, 'rm008'),
('am017', 'Sound System', 'Technology', 'High-quality audio system', 1, 'rm008'),
('am018', 'Charging Stations', 'Technology', 'Multiple device charging stations', 5, 'rm009'),
('am019', 'Server Access', 'Technology', 'Direct server access for developers', 1, 'rm010'),
('am020', 'Multiple Monitors', 'Technology', 'Dual monitor setup for each desk', 10, 'rm010'),
('am021', 'Coding Boards', 'Office Equipment', 'Specialized boards for code review', 2, 'rm011'),
('am022', 'Urban Style Furniture', 'Furniture', 'Industrial design furniture', 15, 'rm012'),
('am023', 'Smart Board', 'Technology', 'Interactive smart board', 1, 'rm013'),
('am024', 'Video Conferencing', 'Technology', 'Advanced video conferencing setup', 1, 'rm014'),
('am025', 'Library Corner', 'Facilities', 'Small business library', 1, 'rm015'),
('am026', 'Mediterranean Decor', 'Design', 'Alexandria-inspired interior design', 1, 'rm016'),
('am027', 'Maker Space', 'Facilities', 'Tools and equipment for prototyping', 1, 'rm017'),
('am028', 'Art Supplies', 'Creative Tools', 'Various art supplies for creatives', 1, 'rm018'),
('am029', 'Hammocks', 'Furniture', 'Relaxing hammock area', 3, 'rm019'),
('am030', 'Sea View Windows', 'Design', 'Large windows with sea views', 4, 'rm020'),
('am031', 'Beach Access', 'Facilities', 'Direct access to the beach', 1, 'rm021'),
('am032', 'Reef Aquarium', 'Design', 'Live coral reef aquarium', 1, 'rm022'),
('am033', 'Resort Services', 'Services', 'Access to resort amenities', 1, 'rm023'),
('am034', 'Egyptian Art', 'Design', 'Ancient Egyptian inspired artwork', 5, 'rm024'),
('am035', 'Historical Books', 'Facilities', 'Collection of Egyptian history books', 1, 'rm025'),
('am036', 'Mall Access', 'Facilities', 'Direct access to shopping mall', 1, 'rm026'),
('am037', 'Shopping Discounts', 'Services', 'Special discounts at mall shops', 1, 'rm027'),
('am038', 'Business Services', 'Services', 'Professional business support services', 1, 'rm028'),
('am039', 'Ergonomic Workstations', 'Furniture', 'Fully adjustable workstations', 10, 'rm029'),
('am040', 'Nile View Balcony', 'Facilities', 'Private balcony with river views', 1, 'rm030'),
('am041', 'Nubian Design Elements', 'Design', 'Traditional Nubian decor', 1, 'rm031'),
('am042', 'Designer Furniture', 'Furniture', 'High-end designer furniture', 1, 'rm032'),
('am043', 'Art Collection', 'Design', 'Curated art pieces from local artists', 1, 'rm033'),
('am044', 'Creative Tools', 'Creative Equipment', 'Various tools for creative work', 1, 'rm034');

-- Insert data for Request table
INSERT INTO Request VALUES
('req001', 'Technical Support', '2023-01-10 09:30:00', '2023-01-10 11:45:00', 'Internet connection issues in Room 3', 'Resolved', 'Issue fixed by resetting the router'),
('req002', 'Room Booking', '2023-01-15 14:20:00', '2023-01-15 15:00:00', 'Need to book Innovation Lab for tomorrow', 'Approved', 'Room booked for requested time'),
('req003', 'Equipment Request', '2023-01-20 10:15:00', '2023-01-20 12:30:00', 'Additional whiteboard needed for meeting', 'Approved', 'Whiteboard provided'),
('req004', 'Maintenance', '2023-02-05 08:45:00', '2023-02-05 13:00:00', 'Air conditioning not working in Executive Suite', 'Resolved', 'AC fixed by maintenance team'),
('req005', 'Catering Request', '2023-02-10 11:30:00', '2023-02-10 12:15:00', 'Coffee and snacks for 10 people', 'Approved', 'Catering arranged for requested time'),
('req006', 'Technical Support', '2023-02-15 15:40:00', '2023-02-15 16:30:00', 'Projector not connecting to laptop', 'Resolved', 'Connection issue fixed'),
('req007', 'Room Change', '2023-03-01 09:00:00', '2023-03-01 10:00:00', 'Need to move from Creative Zone to Cairo Skyline', 'Approved', 'Room change approved'),
('req008', 'Extended Hours', '2023-03-10 18:00:00', '2023-03-10 18:30:00', 'Need to work until midnight', 'Denied', 'Building closes at 10 PM'),
('req009', 'Membership Upgrade', '2023-03-15 11:20:00', '2023-03-15 14:00:00', 'Want to upgrade from basic to premium', 'Approved', 'Membership upgraded'),
('req010', 'Event Space', '2023-04-05 10:00:00', '2023-04-05 13:30:00', 'Book Alexandria Room for networking event', 'Approved', 'Space reserved for the event');

-- Insert data for Offers table
INSERT INTO Offers VALUES
('off001', 'Summer Special', '20% off on all bookings during summer months', 20.0, '2023-06-01', '2023-08-31', 'Active'),
('off002', 'New Member Discount', '15% off for first-time users', 15.0, '2023-01-01', '2023-12-31', 'Active'),
('off003', 'Weekend Package', '25% off for weekend bookings', 25.0, '2023-02-01', '2023-12-31', 'Active'),
('off004', 'Monthly Subscription', '30% off for monthly subscriptions', 30.0, '2023-03-01', '2023-12-31', 'Active'),
('off005', 'Student Discount', '20% off for university students', 20.0, '2023-01-01', '2023-12-31', 'Active'),
('off006', 'Early Bird', '15% off for bookings before 9 AM', 15.0, '2023-04-01', '2023-12-31', 'Active'),
('off007', 'Night Owl', '20% off for bookings after 6 PM', 20.0, '2023-04-01', '2023-12-31', 'Active'),
('off008', 'Group Booking', '25% off for groups of 5 or more', 25.0, '2023-05-01', '2023-12-31', 'Active'),
('off009', 'Long-term Discount', '35% off for 6-month subscriptions', 35.0, '2023-01-01', '2023-12-31', 'Active'),
('off010', 'Holiday Special', '30% off during national holidays', 30.0, '2023-01-01', '2023-12-31', 'Active');

-- Insert data for Reservation table
INSERT INTO Reservation VALUES
('res001', '2023-01-05', '2023-01-10 09:00:00', '2023-01-10 13:00:00', 'Completed', 800.00, 3),
('res002', '2023-01-12', '2023-01-15 14:00:00', '2023-01-15 18:00:00', 'Completed', 600.00, 2),
('res003', '2023-01-18', '2023-01-20 10:00:00', '2023-01-20 15:00:00', 'Completed', 500.00, 1),
('res004', '2023-02-01', '2023-02-05 09:00:00', '2023-02-05 17:00:00', 'Completed', 2000.00, 2),
('res005', '2023-02-08', '2023-02-10 11:00:00', '2023-02-10 16:00:00', 'Completed', 750.00, 1),
('res006', '2023-02-12', '2023-02-15 15:00:00', '2023-02-15 18:00:00', 'Completed', 450.00, 1),
('res007', '2023-02-25', '2023-03-01 09:00:00', '2023-03-01 14:00:00', 'Completed', 1100.00, 0),
('res008', '2023-03-07', '2023-03-10 18:00:00', '2023-03-10 22:00:00', 'Cancelled', 480.00, 0),
('res009', '2023-03-12', '2023-03-15 10:00:00', '2023-03-15 18:00:00', 'Completed', 1600.00, 2),
('res010', '2023-04-01', '2023-04-05 09:00:00', '2023-04-05 17:00:00', 'Confirmed', 1600.00, 3),
('res011', '2023-04-10', '2023-04-15 10:00:00', '2023-04-15 15:00:00', 'Confirmed', 900.00, 1),
('res012', '2023-04-18', '2023-04-20 09:00:00', '2023-04-20 18:00:00', 'Confirmed', 1350.00, 2),
('res013', '2023-05-02', '2023-05-05 10:00:00', '2023-05-05 16:00:00', 'Confirmed', 1080.00, 1),
('res014', '2023-05-10', '2023-05-15 09:00:00', '2023-05-15 14:00:00', 'Confirmed', 750.00, 2),
('res015', '2023-05-20', '2023-05-25 13:00:00', '2023-05-25 18:00:00', 'Pending', 900.00, 1),
('res016', '2023-05-20', '2023-01-10 09:00:00', '2023-01-10 13:00:00', 'Completed', 800.00, 3),
('res017', '2023-05-21', '2023-01-10 09:00:00', '2023-01-10 13:00:00', 'Completed', 800.00, 3),
('res018', '2023-05-25', '2023-01-10 09:00:00', '2023-01-10 13:00:00', 'Completed', 800.00, 3),
('res019', '2023-06-07', '2023-01-10 09:00:00', '2023-01-10 13:00:00', 'Completed', 800.00, 3),
('res020', '2023-07-12', '2023-01-10 09:00:00', '2023-01-10 13:00:00', 'Completed', 800.00, 3),
('res021', '2023-08-14', '2023-01-10 09:00:00', '2023-01-10 13:00:00', 'CANCELLED', 800.00, 3);

-- Insert data for Payment table
INSERT INTO Payment VALUES
('pay001', '2023-01-05', 'Credit Card', 800.00, 'Completed', 'res001'),
('pay002', '2023-01-12', 'Debit Card', 600.00, 'Completed', 'res002'),
('pay003', '2023-01-18', 'Cash', 500.00, 'Completed', 'res003'),
('pay004', '2023-02-01', 'Bank Transfer', 2000.00, 'Completed', 'res004'),
('pay005', '2023-02-08', 'Credit Card', 750.00, 'Completed', 'res005'),
('pay006', '2023-02-12', 'Mobile Wallet', 450.00, 'Completed', 'res006'),
('pay007', '2023-02-25', 'Credit Card', 1100.00, 'Completed', 'res007'),
('pay008', '2023-03-07', 'Debit Card', 480.00, 'Refunded', 'res008'),
('pay009', '2023-03-12', 'Credit Card', 1600.00, 'Completed', 'res009'),
('pay010', '2023-04-01', 'Bank Transfer', 1600.00, 'Pending', 'res010'),
('pay011', '2023-04-10', 'Mobile Wallet', 900.00, 'Pending', 'res011'),
('pay012', '2023-04-18', 'Credit Card', 1350.00, 'Pending', 'res012'),
('pay013', '2023-05-02', 'Debit Card', 1080.00, 'Pending', 'res013'),
('pay014', '2023-05-10', 'Credit Card', 750.00, 'Pending', 'res014'),
('pay015', '2023-05-20', 'Cash', 900.00, 'Pending', 'res015');

-- Insert data for LoyaltyPoints table
INSERT INTO LoyaltyPoints VALUES
(500, 100, '2023-01-15 14:30:00', 'usr001'),
(350, 50, '2023-02-10 11:45:00', 'usr002'),
(600, 150, '2023-03-05 10:20:00', 'usr003'),
(200, 50, '2023-01-18 09:15:00', 'usr004'),
(750, 200, '2023-02-20 13:30:00', 'usr005'),
(300, 75, '2023-03-12 16:45:00', 'usr006'),
(450, 100, '2023-04-05 10:30:00', 'usr007'),
(250, 50, '2023-03-25 14:00:00', 'usr008'),
(800, 150, '2023-04-15 11:15:00', 'usr009'),
(400, 100, '2023-05-01 09:45:00', 'usr010');

-- Insert data for Cancellation table
INSERT INTO Cancellation VALUES
(48.00, '2023-03-09 15:30:00', 'usr008', 'res008'),
(48.00, '2023-08-14 15:30:00', 'usr001', 'res021');

-- Insert data for Booking table
INSERT INTO Booking VALUES
('usr001', 'res001', 'ws001', 'rm001'),
('usr002', 'res002', 'ws001', 'rm002'),
('usr003', 'res003', 'ws001', 'rm003'),
('usr004', 'res004', 'ws002', 'rm004'),
('usr005', 'res005', 'ws002', 'rm005'),
('usr006', 'res006', 'ws002', 'rm006'),
('usr007', 'res007', 'ws003', 'rm007'),
('usr008', 'res008', 'ws003', 'rm008'),
('usr009', 'res009', 'ws003', 'rm009'),
('usr010', 'res010', 'ws007', 'rm016'),
('usr011', 'res011', 'ws008', 'rm018'),
('usr012', 'res012', 'ws009', 'rm020'),
('usr013', 'res013', 'ws010', 'rm022'),
('usr014', 'res014', 'ws011', 'rm024'),
('usr015', 'res015', 'ws013', 'rm028'),
('usr001', 'res016', 'ws001', 'rm001'),
('usr001', 'res017', 'ws002', 'rm004'),
('usr001', 'res018', 'ws001', 'rm002'),
('usr001', 'res019', 'ws002', 'rm004'),
('usr001', 'res020', 'ws002', 'rm005'),
('usr001', 'res021', 'ws001', 'rm001');

-- Insert data for UserRequesting table
INSERT INTO UserRequesting VALUES
('usr001', 'req001', 'stf001'),
('usr002', 'req002', 'stf001'),
('usr003', 'req003', 'stf001'),
('usr004', 'req004', 'stf003'),
('usr005', 'req005', 'stf002'),
('usr006', 'req006', 'stf004'),
('usr007', 'req007', 'stf003'),
('usr008', 'req008', 'stf003'),
('usr009', 'req009', 'stf003'),
('usr010', 'req010', 'stf007');

-- Insert data for SuspendedUsers table
INSERT INTO SuspendedUsers VALUES
('usr016', 'stf001'),
('usr017', 'stf003');

-- Insert data for Review table
INSERT INTO Review VALUES
('rev001', 4.5, 'Great workspace with excellent facilities', '2023-01-12', 'usr001', 'ws001'),
('rev002', 4.8, 'Professional environment and helpful staff', '2023-01-16', 'usr002', 'ws001'),
('rev003', 4.3, 'Good location but wifi could be faster', '2023-01-22', 'usr003', 'ws001'),
('rev004', 4.7, 'Quiet and comfortable private office', '2023-02-06', 'usr004', 'ws002'),
('rev005', 4.5, 'Amazing views and great conference facilities', '2023-02-11', 'usr005', 'ws002'),
('rev006', 4.2, 'Nice open space but gets crowded sometimes', '2023-02-17', 'usr006', 'ws002'),
('rev007', 4.9, 'Executive suite is worth every penny', '2023-03-03', 'usr007', 'ws003'),
('rev008', 4.4, 'Good meeting room with all necessary tech', '2023-03-16', 'usr009', 'ws003'),
('rev009', 4.6, 'Amazing location with sea views', '2023-04-07', 'usr010', 'ws007'),
('rev010', 4.3, 'Creative atmosphere but limited parking', '2023-04-16', 'usr011', 'ws008'),
('rev011', 4.8, 'Beautiful seaside workspace', '2023-04-22', 'usr012', 'ws009'),
('rev012', 4.9, 'Luxury workspace with resort amenities', '2023-05-07', 'usr013', 'ws010'),
('rev013', 4.4, 'Unique cultural atmosphere', '2023-05-16', 'usr014', 'ws011'),
('rev014', 4.6, 'Professional environment with great services', '2023-05-26', 'usr015', 'ws013');

-- Insert data for FavouriteWorkspaces table
INSERT INTO FavouriteWorkspaceRooms VALUES
('usr001', 'ws001', 'rm001'),
('usr001', 'ws003', 'rm007'),
('usr002', 'ws001', 'rm002'),
('usr003', 'ws002', 'rm004'),
('usr004', 'ws002', 'rm005'),
('usr004', 'ws004', 'rm010'),
('usr005', 'ws003', 'rm008'),
('usr006', 'ws003', 'rm009'),
('usr006', 'ws005', 'rm012'),
('usr007', 'ws006', 'rm014'),
('usr008', 'ws007', 'rm016'),
('usr009', 'ws008', 'rm018'),
('usr010', 'ws009', 'rm020'),
('usr011', 'ws010', 'rm022'),
('usr012', 'ws011', 'rm024'),
('usr013', 'ws012', 'rm026'),
('usr014', 'ws013', 'rm028'),
('usr015', 'ws014', 'rm030'),
('usr015', 'ws015', 'rm032');

-- Insert data for WorkspaceSupervise table
INSERT INTO WorkspaceSupervise VALUES
('stf001', 'ws001'),
('stf002', 'ws002'),
('stf003', 'ws003'),
('stf004', 'ws004'),
('stf005', 'ws005'),
('stf006', 'ws006'),
('stf007', 'ws007'),
('stf008', 'ws008'),
('stf009', 'ws009'),
('stf010', 'ws010'),
('stf011', 'ws011'),
('stf012', 'ws012'),
('stf013', 'ws013'),
('stf014', 'ws014'),
('stf015', 'ws015');

-- Insert data for Images table
INSERT INTO Images VALUES
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws001', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws001', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws001', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws002', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws002', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws003', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws003', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws004', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws005', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws006', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws007', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws008', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws009', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws010', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws011', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws012', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws013', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws014', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, 'ws015', NULL, NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, 'rm001', NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, 'rm002', NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, 'rm005', NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, 'rm007', NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, 'rm010', NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, 'rm016', NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, 'rm020', NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, 'rm024', NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, 'rm030', NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, 'rm033', NULL),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, NULL, 'am001'),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, NULL, 'am002'),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, NULL, 'am007'),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, NULL, 'am011'),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, NULL, 'am026'),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, NULL, 'am030'),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, NULL, 'am034'),
('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s', NULL, NULL, NULL, 'am040');

-- Insert data for ApplyedOffers table
INSERT INTO ApplyedOffers VALUES
('stf001', 'rm001', 'off001'),
('stf001', 'rm002', 'off002'),
('stf001', 'rm003', 'off003'),
('stf002', 'rm004', 'off001'),
('stf002', 'rm005', 'off004'),
('stf003', 'rm007', 'off005'),
('stf004', 'rm010', 'off006'),
('stf005', 'rm012', 'off007'),
('stf006', 'rm014', 'off008'),
('stf007', 'rm016', 'off001'),
('stf008', 'rm018', 'off009'),
('stf009', 'rm020', 'off010'),
('stf010', 'rm022', 'off001'),
('stf011', 'rm024', 'off002'),
('stf012', 'rm026', 'off003'),
('stf013', 'rm028', 'off004'),
('stf014', 'rm030', 'off005'),
('stf015', 'rm032', 'off006');

-- Insert data for WorkspaceAnalytics table
INSERT INTO WorkspaceAnalytics VALUES
('ws001', '2023-01-31', 4.5, 5000.00, 25, 'Peak usage during morning hours'),
('ws001', '2023-02-28', 4.6, 5500.00, 28, 'Even distribution throughout the day'),
('ws001', '2023-03-31', 4.5, 4800.00, 22, 'Peak usage during afternoon'),
('ws002', '2023-01-31', 4.4, 4200.00, 20, 'Higher usage on weekdays'),
('ws002', '2023-02-28', 4.6, 4600.00, 23, 'Higher usage in morning hours'),
('ws002', '2023-03-31', 4.5, 4400.00, 21, 'Even distribution throughout the day'),
('ws003', '2023-01-31', 4.7, 6000.00, 18, 'Higher usage by executives'),
('ws003', '2023-02-28', 4.8, 6500.00, 20, 'Peak usage during business hours'),
('ws003', '2023-03-31', 4.7, 6200.00, 19, 'Consistent high-value bookings'),
('ws007', '2023-01-31', 4.2, 3500.00, 15, 'Higher usage by creatives'),
('ws007', '2023-02-28', 4.3, 3800.00, 16, 'Increased weekend usage'),
('ws007', '2023-03-31', 4.2, 3600.00, 15, 'Popular with local businesses'),
('ws009', '2023-01-31', 4.8, 7000.00, 22, 'Popular with tourists'),
('ws009', '2023-02-28', 4.8, 7200.00, 24, 'Peak season with higher rates'),
('ws009', '2023-03-31', 4.8, 7100.00, 23, 'Consistent demand throughout the month');

-- Insert data for WorkspacePlan table
INSERT INTO WorkspacePlan VALUES
('ws001', 36000.00, 3500.00),
('ws002', 38000.00, 3700.00),
('ws003', 45000.00, 4200.00),
('ws004', 32000.00, 3000.00),
('ws005', 34000.00, 3200.00),
('ws006', 35000.00, 3300.00),
('ws007', 30000.00, 2800.00),
('ws008', 31000.00, 2900.00),
('ws009', 48000.00, 4500.00),
('ws010', 50000.00, 4700.00),
('ws011', 33000.00, 3100.00),
('ws012', 35000.00, 3300.00),
('ws013', 36000.00, 3400.00),
('ws014', 40000.00, 3800.00),
('ws015', 46000.00, 4300.00);

-- Insert data for Preference table
INSERT INTO Preference VALUES
('50-200', 'Coworking', 'usr001'),
('500-1000', 'Private Office', 'usr002'),
('200-500', 'Meeting Room', 'usr003'),
('50-200', 'Open Space', 'usr004'),
('500-1000', 'Conference Room', 'usr005'),
('200-500', 'Coworking', 'usr006'),
('500-1000', 'Private Office', 'usr007'),
('50-200', 'Meeting Room', 'usr008'),
('500-1000', 'Conference Room', 'usr009'),
('200-500', 'Open Space', 'usr010'),
('50-200', 'Coworking', 'usr011'),
('500-1000', 'Private Office', 'usr012'),
('200-500', 'Meeting Room', 'usr013'),
('50-200', 'Open Space', 'usr014'),
('500-1000', 'Conference Room', 'usr015');