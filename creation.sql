create database library;

create table Genre (
    genreId int not null,
    genreName varchar(30) not null,
    primary key(genreId)
);

create table Author (
    authorId int not null,
    authorName varchar(50) not null,
    primary key(authorId)
);

create table Publisher (
    publisherId int not null,
    publisherName varchar(30) not null,
    primary key(publisherId)
);

create table Visitor (
    visitorId int not null,
    visitorName varchar(50) not null,
    primary key(visitorId)
);

create table Room (
    roomId int not null,
    capacity int not null,
    primary key(roomId)
);

create table Cabinet (
    cabinetId int not null,
    roomId int not null,
    capacity int not null,
    primary key(cabinetId, roomId),
    foreign key(roomId) references Room(roomId) on delete cascade
);

create table Book (
    bookId int not null,
    bookName varchar(30) not null,
    authorId int not null,
    genreId int not null,
    cabinetId int not null,
    roomId int not null,
    publisherId int not null,
    primary key(bookId),
    foreign key (authorId) references Author(authorId) on delete cascade,
    foreign key (genreId) references Genre(genreId) on delete cascade,
    foreign key (cabinetId, roomId) references Cabinet(cabinetId, roomId) on delete cascade, 
    foreign key (publisherId) references Publishing (publisherId) on delete cascade
);

create table Publishing (
    publisherId int not null,
    bookId int not null,
    yearOfPublishing int not null,
    primary key (publisherId, bookId),
    foreign key (publisherId) references Publisher(publisherId) on delete cascade,
    foreign key (bookId) references Book(bookId) on delete cascade
);

create table ClientBook (
    bookId int not null,
    visitorId int not null,
    bookWasTaken timestamp not null,
    bookWasReturned timestamp not null,
    primary key (bookId, bookWasTaken, bookWasReturned),
    foreign key (bookId) references Book(bookId) on delete cascade,
    foreign key (visitorId) references Visitor(visitorId) on delete cascade
);

insert into Genre (genreId, genreName) values
    (1, "horror"),
    (2, "satire"),
    (3, "fiction");

insert into Author (authorId, authorName) values
    (1, "Chuck Palahniuk"),
    (2, "Stephen King"),
    (3, "Ken Kesey");

insert into Publisher (publisherId, publisherName) values
    (1, "AST"),
    (2, "Alternative"),
    (3, "Litera");

insert into Visitor (visitorId, visitorName) values
    (1, "Vasya Vasin"),
    (2, "Petr Petrov"),
    (3, "Ilya Iliin");

insert into Room (roomId, capacity) values
    (1, 5),
    (2, 2);

insert into Cabinet (cabinetId, roomId, capacity) values
    (1, 1, 20),
    (2, 1, 10),
    (1, 2, 5),
    (2, 2, 3);

insert into Book (bookId, bookName, authorId, genreId, cabinetId, roomId, publisherId, yearOfPublishing) values
    (1, "It", 2, 1, 1, 1, 1, 2015),
    (2, "Fight Club", 1, 3, 1, 2, 3, 2014),
    (3, "Fight Club", 1, 3, 2, 2, 3, 2013),
    (4, "Haunted", 1, 1, 2, 2, 3, 2015),
    (5, "Haunted", 1, 1, 2, 2, 3, 2013);

insert into Publishing (publisherId, bookId, yearOfPublishing) values
    (1, 1, 2015),
    (3, 2, 2014),
    (3, 3, 2013),
    (3, 4, 2015),
    (3, 5, 2013);

insert into ClientBook (bookId, visitorId, bookWasTaken, bookWasReturned) values
    (3, 1, '2018-01-02 11:02:47', '2018-01-03 11:02:47'),
    (5, 1, '2018-01-03 12:22:34', '2038-01-19 03:14:07'),
    (1, 2, '2018-01-11 18:48:44', '2038-01-19 03:14:07');
