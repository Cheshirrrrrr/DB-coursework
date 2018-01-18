create view BooksWithAuthors as (
    select distinct bookName, authorName from
    Book natural join Author
);

create view BooksWithGenres as (
    select distinct bookName, authorName, genreName from
    Book natural join Author natural join Genre
);

create view AllInfoAboutBooks as (
    select bookName,
            authorName,
            genreName,
            publisherName,
            yearOfPublishing,
            roomId,
            cabinetId
    from
    Book natural join Author natural join Genre
        natural join Publisher
);

create view TakenBooks as (
    select bookName, authorName, cabinetId, roomId from
    Book natural join ClientBook natural join Author
    where bookWasReturned = '2038-01-19 03:14:07'
);

create view AvailableBooks as (
    select bookName, authorName, cabinetId, roomId from
    Book natural join Author
    where bookId not in
        (select bookId from ClientBook
            where bookWasReturned = '2038-01-19 03:14:07')
);

create view NumberOfBooksByAuthor as (
    select 
        authorName, count(*) as numberOfBooks
    from
        Book natural join Author
    group by authorId;
);


create view NumberOfBooksByGenre as (
    select 
        genreName, count(*) as numberOfBooks
    from
        Book natural join Genre
    group by genreId;
);
