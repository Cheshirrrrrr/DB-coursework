drop procedure if exists AllBooksByAuthor;
delimiter $$
create procedure AllBooksByAuthor(aId varchar(50))
begin
    select
        authorName
        bookName,
        genreName,
        cabinetId,
        roomId,
        publisherName,
        yearOfPublishing
    from
        Book natural join Author
            natural join Genre
            natural join Publisher
        where authorId = aId;
end;
$$
delimiter ;

drop procedure if exists AllBooksByGenre;
delimiter $$
create procedure AllBooksByGenre(gName varchar(50))
begin
    select 
        bookName,
        authorName,
        cabinetId,
        roomId,
        publisherName,
        yearOfPublishing
    from
        Book natural join Author
            natural join Genre
            natural join Publisher
        where genreName = gName;
end;
$$
delimiter ;


drop procedure if exists AllBooksByRoom;
delimiter $$
create procedure AllBooksByRoom(rId int)
begin
    select 
        bookName,
        authorName,
        genreName,
        cabinetId,
        publisherName,
        yearOfPublishing
    from
        Book natural join Author
            natural join Genre
            natural join Publisher
        where roomId = rId;
end;
$$
delimiter ;

drop procedure if exists AllBooksByClient;
delimiter $$
create procedure AllBooksByClient(cId int)
begin
    select 
        bookName,
        authorName,
        publisherName,
        yearOfPublishing,
        bookWasTaken,
        bookWasReturned
    from
        ClientBook natural join Book
            natural join Author
            natural join Publisher
        where visitorId = cId;
end;
$$
delimiter ;

drop procedure if exists AllBooksWithOtherGenre;
delimiter $$
create procedure AllBooksWithOtherGenre(gName varchar(50))
begin
    select 
        bookName,
        authorName,
        genreName
        cabinetId,
        roomId,
        publisherName,
        yearOfPublishing
    from
        Book natural join Author
            natural join Genre
            natural join Publisher
        where genreName != gName;
end;
$$
delimiter ;

drop procedure if exists NumberOfBooksOwnedByClients;
delimiter $$
create procedure NumberOfBooksOwnedByClients()
begin
    select 
        visitorName, count(*) as numberOfBooks
    from
        ClientBook natural join Visitor
        where bookWasReturned = '2038-01-19 03:14:07'
        group by visitorId;
end;
$$
delimiter ;

drop procedure if exists AllClientsWithOnlyGivenGenre;
delimiter $$
create procedure AllClientsWithOnlyGivenGenre(gName varchar(30))
begin
    select 
        visitorId, visitorName
    from
        (select * from ClientBook natural join Visitor) as t
        where not exists
            (select bookId from ClientBook
                                natural join Book
                                natural join Genre
            where visitorId = t.visitorId and
            bookWasReturned = '2038-01-19 03:14:07'
            genreName != gName);
end;
$$
delimiter ;

drop procedure if exists AuthorWithMaxBooks;
delimiter $$
create procedure AuthorWithMaxBooks()
begin
    select 
        authorName
    from
        NumberOfBooksByAuthor 
    where numberOfBooks = (select max(numberOfBooks) from NumberOfBooksByAuthor);
end;
$$
delimiter ;

drop procedure if exists GenreWithMinBooks;
delimiter $$
create procedure GenreWithMinBooks()
begin
    select 
        genreName
    from
        NumberOfBooksByGenre 
    where numberOfBooks = (select min(numberOfBooks) from NumberOfBooksByGenre);
end;
$$
delimiter ;

drop procedure if exists BooksByPublisherByAuthor;
delimiter $$
create procedure BooksByPublisherByAuthor(aId varchar(50))
begin
    select 
        authorName, publisherName, count(*) as numberOfBooks
    from
         Book natural join
         Author natural join
         Publisher
    where authorId = aId
    group by publisherId;
end;
$$
delimiter ;

drop procedure if exists AllPublishingsByBook;
delimiter $$
create procedure AllPublishingsByBook(bName varchar(30), aId varchar(50))
begin
    select 
        publisherName, yearOfPublishing
    from
         Book natural join
         Publisher
    where authorId = aId and bookName = bName;
end;
$$
delimiter ;


drop procedure if exists addClient;
delimiter $$
create procedure addClient(cName varchar(30))
begin
    declare lastId int;
    set lastId = (select max(visitorId) from Visitor);
    insert into Visitor (visitorId, visitorName) values
        (lastId + 1, cName);
end;$$
delimiter ;

drop procedure if exists addAuthor;
delimiter $$
create procedure addAuthor(aName varchar(30))
begin
    declare lastId int;
    set lastId = (select max(authorId) from Author);
    insert into Author (authorId, authorName) values
        (lastId + 1, aName);
end;$$
delimiter ;


