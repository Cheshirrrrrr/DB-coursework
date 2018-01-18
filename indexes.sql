create index genreNameIndex on Genre(genreName) using HASH;
create index authorBookIndex on Book(authorId, bookName) using HASH;
create index authorIndex on Author(authorName) using HASH;
create index bookNameIndex on Book(bookName) using HASH;
create index bookIndex on Book(authorId, bookName, publisherId) using HASH;
