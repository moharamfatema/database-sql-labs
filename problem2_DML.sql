INSERT into category VALUES 
(101,'Fantasy'),
(102,'Young Adult'),
(103,'Romance');

INSERT into publisher VALUES
(101,'Patrick Rothfuss','Wisconsin, US'),
(102,'Suzanne Collins','Connecticut, US'),
(103,'Baidaba','India');

INSERT into book VALUES
(101, 'The  name of the wind', 20, 101, 101),
(102, 'The Hunger Games', 30, 102, 102),
(103, 'Kalila Wa Dimna', 100, 103, 101);

insert into member (member_id, name, address)VALUES
(100,'Sally','Alexndria, Egypt'),
(101,'Maggie','Atlanta, US'),
(102,'Glenn','Soel, Korea');

INSERT into borrowing_book (member_id, book_id) VALUES
(100, 101),
(101, 103),
(102, 102);
