drop trigger if exists CabinetCapacityCheck;
delimiter $$
create trigger CabinetCapacityCheck
    before insert on Book
    for each row
begin
    if ((select count(*) from Book where
        cabinetId = NEW.cabinetId and roomId = NEW.roomId) >=
    (select capacity from Cabinet where
        cabinetId = NEW.cabinetId and roomId = NEW.roomId))
    then
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Error: cannot exceed capacity of a cabinet';
    end if;
end; $$
delimiter ;

drop trigger if exists RoomCapacityCheck;
delimiter $$
create trigger RoomCapacityCheck
    before insert on Cabinet
    for each row
begin
    if ((select count(*) from Cabinet where
        roomId = NEW.roomId) >=
    (select capacity from Room where
        roomId = NEW.roomId))
    then
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Error: cannot exceed capacity of a room';
    end if;
end; $$


drop trigger if exists CheckAvailabilityBeforeTakingBook;
delimiter $$
create trigger CheckAvailabilityBeforeTakingBook
    before insert on ClientBook
    for each row
begin
    if (NEW.bookId in
        (select bookId from AvailableBooks))
    then
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Error: cannot take book which is already taken';
    end if;
end; $$
delimiter ;

drop trigger if exists CheckCapacityBeforeTakingBook;
delimiter $$
create trigger CheckCapacityBeforeTakingBook
    before insert on ClientBook
    for each row
begin
    if (select count(*) from ClientBook where 
        visitorId = NEW.visitorId and bookWasReturned = '2038-01-19 03:14:07') = 5
    then
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Error: cannot take more than five books';
    end if;
end; $$
delimiter ;

drop trigger if exists DeleteFromPublishingAfterBooks;
delimiter $$
create trigger DeleteFromPublishingAfterBooks
    before delete on Book
    for each row
begin
    delete from Publishing where
        publisherId = OLD.publisherId and bookId = OLD.bookId;
end; $$
delimiter ;

