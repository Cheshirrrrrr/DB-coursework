delimiter $$
create function returnBook(bName varchar(30), aName varchar(30), pName varchar(30)) returns boolean
begin
    declare bId int default -1;
    set bId = (select bookId from Book
                                    natural join Author
                                    natural join Publisher
                    where bookName = bName and authorName = aName and
                            publisherName = pName and
                            bookId in (select bookId from ClientBook));
    if bid = -1 then
        return False;
    else
        delete from ClientBook where bookId = bid;
    end if;
    return True;
end; $$
delimiter ;


drop function if exists takeBook;
delimiter $$
create function takeBook(cName varchar(30), bName varchar(30), aName varchar(30)) returns boolean
begin
    declare bId int default -1;
    declare cId int default -1;
    drop temporary table if exists PossibleBookIds;
    create temporary table PossibleBookIds (bookId int);
    insert into PossibleBookIds (bookId)
        (select bookId from Book
                                    natural join Author
                                    natural join Publisher
                    where bookName = bName and authorName = aName
                    and bookId not in
                            (select bookId from ClientBook));
    if (select count(*) from PossibleBookIds) = 0 then
        drop temporary table if exists PossibleBookIds;
        return false;
    end if;
    set bId = (select bookId from PossibleBookIds limit 1);
    set cId = (select visitorId from Visitor where visitorName = cName);
    if cId = -1 then
        drop temporary table if exists PossibleBookIds;
        return false;
    end if;
    insert into ClientBook (bookId, visitorId, bookWasTaken) values
        (bId, cId, now(), '2038-01-19 03:14:07');
    drop temporary table if exists PossibleBookIds;
    return True;
end; $$
delimiter ;


drop function if exists addGenre;
delimiter $$
create function addGenre(gName varchar(30)) returns boolean
begin
    declare lastId int;
    if gName in (select genreName from Genre) then
        return false;
    end if;
    set lastId = (select max(genreId) from Genre);
    insert into Genre (genreId, genreName) values
        (lastId + 1, gName);
    return true;
end;$$
delimiter ;


drop function if exists numberOfBooksAvailableForClient;
delimiter $$
create function numberOfBooksAvailableForClient(cId int) returns int
begin
    return 5 - (select count(*) from ClientBook where
                    visitorId = cId);
end;$$
delimiter ;


drop function if exists countBooksByAuthor;
delimiter $$
create function countBooksByAuthor(aId int) returns int
begin
    return (select count(distinct bookName) from
            Book where authorId = aId);
end;$$
delimiter ;
