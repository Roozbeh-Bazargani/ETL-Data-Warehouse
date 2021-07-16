CREATE TABLE Person
(
	person_id INTEGER NOT NULL,
	last_name CHAR(20) NOT NULL,
	first_name CHAR(20),
	insert_date DATE NOT NULL,
	PRIMARY KEY (person_id)
);


CREATE TABLE Languageb
(
	languageb CHAR(20) NOT NULL,
	insert_date DATE NOT NULL,
	PRIMARY KEY (languageb)
);

CREATE TABLE Genre
(
	genre CHAR(20) NOT NULL,
	insert_date DATE NOT NULL,
	PRIMARY KEY (genre)
);

CREATE TABLE Book
(
	ISBN INTEGER NOT NULL,
	number_available INTEGER NOT NULL,
	title CHAR(40) NOT NULL,
	description CHAR(100),
	edition INTEGER,
	published_date DATE,
	publisher CHAR(40),
	main_author INTEGER NOT NULL,
	main_language CHAR(20) NOT NULL,
	main_genre CHAR(20) NOT NULL,
	insert_date DATE NOT NULL,
	PRIMARY KEY (ISBN),
	FOREIGN KEY (main_author) REFERENCES Person,
	FOREIGN KEY (main_language) REFERENCES Languageb,
	FOREIGN KEY (main_genre) REFERENCES GENRE
);

CREATE TABLE User_library
(
	user_id INTEGER NOT NULL,
	person_id INTEGER NOT NULL,
	birth_date DATE,
	register_date DATE,
	register_number INTEGER,
	telephone INTEGER,
	address CHAR(200),
	insert_date DATE NOT NULL,
	PRIMARY KEY (user_id),
	FOREIGN KEY (person_id) REFERENCES Person
);



CREATE TABLE Written_by
(
	written_id INTEGER NOT NULL,
	person_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE NOT NULL,
	PRIMARY KEY (written_id),
	FOREIGN KEY (person_id) REFERENCES Person,
	FOREIGN KEY (book_id) REFERENCES Book
);

CREATE TABLE Translated_by
(
	translated_id INTEGER NOT NULL,
	person_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE NOT NULL,
	PRIMARY KEY (translated_id),
	FOREIGN KEY (person_id) REFERENCES Person,
	FOREIGN KEY (book_id) REFERENCES Book
);


CREATE TABLE Language_book
(
	lb_id INTEGER NOT NULL,
	languageb CHAR(20) NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE NOT NULL,
	PRIMARY KEY (lb_id),
	FOREIGN KEY (languageb) REFERENCES Languageb,
	FOREIGN KEY (book_id) REFERENCES Book
);


CREATE TABLE Genre_book
(
	gb_id INTEGER NOT NULL,
	genre CHAR(20) NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE NOT NULL,
	PRIMARY KEY (gb_id),
	FOREIGN KEY (genre) REFERENCES Genre,
	FOREIGN KEY (book_id) REFERENCES Book
);

CREATE TABLE Borrowed
(
	borrowed_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	deadline DATE NOT NULL,
	number_books INTEGER NOT NULL,
	borrowed_date DATE,
	returned_date DATE,
	insert_date DATE NOT NULL,
	PRIMARY KEY (borrowed_id),
	FOREIGN KEY (user_id) REFERENCES User_library,
	FOREIGN KEY (book_id) REFERENCES Book
);


CREATE TYPE CHNG AS ENUM('update', 'delete');

CREATE TABLE Person_old
(
	person_id INTEGER NOT NULL,
	last_name CHAR(20) NOT NULL,
	first_name CHAR(20),
	insert_date DATE NOT NULL,
	change_date DATE NOT NULL,
	change CHNG NOT NULL,
	PRIMARY KEY (person_id, change_date)
);


CREATE TABLE Languageb_old
(
	languageb CHAR(20) NOT NULL,
	insert_date DATE NOT NULL,
	change_date DATE NOT NULL,
	change CHNG NOT NULL,
	PRIMARY KEY (languageb, change_date)
);

CREATE TABLE Genre_old
(
	genre CHAR(20) NOT NULL,
	insert_date DATE NOT NULL,
	change_date DATE NOT NULL,
	change CHNG NOT NULL,
	PRIMARY KEY (genre, change_date)
);

CREATE TABLE Book_old
(
	ISBN INTEGER NOT NULL,
	number_available INTEGER NOT NULL,
	title CHAR(40) NOT NULL,
	description CHAR(100),
	edition INTEGER,
	published_date DATE,
	publisher CHAR(40),
	main_author INTEGER NOT NULL,
	main_language CHAR(20) NOT NULL,
	main_genre CHAR(20) NOT NULL,
	insert_date DATE NOT NULL,
	change_date DATE NOT NULL,
	change CHNG NOT NULL,
	PRIMARY KEY (ISBN, change_date)
);

CREATE TABLE User_library_old
(
	user_id INTEGER NOT NULL,
	person_id INTEGER NOT NULL,
	birth_date DATE,
	register_date DATE,
	register_number INTEGER,
	telephone INTEGER,
	address CHAR(200),
	insert_date DATE NOT NULL,
	change_date DATE NOT NULL,
	change CHNG NOT NULL,
	PRIMARY KEY (user_id, change_date)
);



CREATE TABLE Written_by_old
(
	written_id INTEGER NOT NULL,
	person_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE NOT NULL,
	change_date DATE NOT NULL,
	change CHNG NOT NULL,
	PRIMARY KEY (written_id, change_date)
);

CREATE TABLE Translated_by_old
(
	translated_id INTEGER NOT NULL,
	person_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE NOT NULL,
	change_date DATE NOT NULL,
	change CHNG NOT NULL,
	PRIMARY KEY (translated_id, change_date)
);


CREATE TABLE Language_book_old
(
	lb_id INTEGER NOT NULL,
	languageb CHAR(20) NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE NOT NULL,
	change_date DATE NOT NULL,
	change CHNG NOT NULL,
	PRIMARY KEY (lb_id, change_date)
);


CREATE TABLE Genre_book_old
(
	gb_id INTEGER NOT NULL,
	genre CHAR(20) NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE NOT NULL,
	change_date DATE NOT NULL,
	change CHNG NOT NULL,
	PRIMARY KEY (gb_id, change_date)
);

CREATE TABLE Borrowed_old
(
	borrowed_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	deadline DATE NOT NULL,
	number_books INTEGER NOT NULL,
	borrowed_date DATE,
	returned_date DATE,
	insert_date DATE NOT NULL,
	change_date DATE NOT NULL,
	change CHNG NOT NULL,
	PRIMARY KEY (borrowed_id, change_date)
);




 CREATE FUNCTION person_history() RETURNS trigger AS $person_history$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO person_old(person_id, last_name, first_name, insert_date, change_date, change)
            VALUES(OLD.person_id, OLD.last_name, OLD.first_name, OLD.insert_date, CURRENT_DATE, 'update');
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO person_old(person_id, last_name, first_name, insert_date, change_date, change)
            VALUES(OLD.person_id, OLD.last_name, OLD.first_name, OLD.insert_date, CURRENT_DATE, 'delete');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
    $person_history$ LANGUAGE plpgsql;

    CREATE TRIGGER person_history AFTER UPDATE OR DELETE ON person
    FOR EACH ROW EXECUTE FUNCTION person_history();
     




 CREATE FUNCTION book_history() RETURNS trigger AS $book_history$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO book_old(isbn, number_available, title, description, edition, published_date, publisher, main_author, main_language, main_genre, insert_date, change_date, change)
            VALUES(OLD.isbn, OLD.number_available, OLD.title, OLD.description, OLD.edition, OLD.published_date, OLD.publisher, OLD.main_author, OLD.main_language, OLD.main_genre, OLD.insert_date, CURRENT_DATE, 'update');
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO book_old(isbn, number_available, title, description, edition, published_date, publisher, main_author, main_language, main_genre, insert_date, change_date, change)
            VALUES(OLD.isbn, OLD.number_available, OLD.title, OLD.description, OLD.edition, OLD.published_date, OLD.publisher, OLD.main_author, OLD.main_language, OLD.main_genre, OLD.insert_date, CURRENT_DATE, 'delete');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
    $book_history$ LANGUAGE plpgsql;

    CREATE TRIGGER book_history AFTER UPDATE OR DELETE ON book
    FOR EACH ROW EXECUTE FUNCTION book_history();
     




 CREATE FUNCTION languageb_history() RETURNS trigger AS $languageb_history$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO languageb_old(languageb, insert_date, change_date, change)
            VALUES(OLD.languageb, OLD.insert_date, CURRENT_DATE, 'update');
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO languageb_old(languageb, insert_date, change_date, change)
            VALUES(OLD.languageb, OLD.insert_date, CURRENT_DATE, 'delete');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
    $languageb_history$ LANGUAGE plpgsql;

    CREATE TRIGGER languageb_history AFTER UPDATE OR DELETE ON languageb
    FOR EACH ROW EXECUTE FUNCTION languageb_history();
     




 CREATE FUNCTION genre_history() RETURNS trigger AS $genre_history$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO genre_old(genre, insert_date, change_date, change)
            VALUES(OLD.genre, OLD.insert_date, CURRENT_DATE, 'update');
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO genre_old(genre, insert_date, change_date, change)
            VALUES(OLD.genre, OLD.insert_date, CURRENT_DATE, 'delete');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
    $genre_history$ LANGUAGE plpgsql;

    CREATE TRIGGER genre_history AFTER UPDATE OR DELETE ON genre
    FOR EACH ROW EXECUTE FUNCTION genre_history();
     




 CREATE FUNCTION user_library_history() RETURNS trigger AS $user_library_history$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO user_library_old(user_id, person_id, birth_date, register_date, register_number, telephone, address, insert_date, change_date, change)
            VALUES(OLD.user_id, OLD.person_id, OLD.birth_date, OLD.register_date, OLD.register_number, OLD.telephone, OLD.address, OLD.insert_date, CURRENT_DATE, 'update');
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO user_library_old(user_id, person_id, birth_date, register_date, register_number, telephone, address, insert_date, change_date, change)
            VALUES(OLD.user_id, OLD.person_id, OLD.birth_date, OLD.register_date, OLD.register_number, OLD.telephone, OLD.address, OLD.insert_date, CURRENT_DATE, 'delete');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
    $user_library_history$ LANGUAGE plpgsql;

    CREATE TRIGGER user_library_history AFTER UPDATE OR DELETE ON user_library
    FOR EACH ROW EXECUTE FUNCTION user_library_history();
     




 CREATE FUNCTION written_by_history() RETURNS trigger AS $written_by_history$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO written_by_old(written_id, person_id, book_id, insert_date, change_date, change)
            VALUES(OLD.written_id, OLD.person_id, OLD.book_id, OLD.insert_date, CURRENT_DATE, 'update');
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO written_by_old(written_id, person_id, book_id, insert_date, change_date, change)
            VALUES(OLD.written_id, OLD.person_id, OLD.book_id, OLD.insert_date, CURRENT_DATE, 'delete');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
    $written_by_history$ LANGUAGE plpgsql;

    CREATE TRIGGER written_by_history AFTER UPDATE OR DELETE ON written_by
    FOR EACH ROW EXECUTE FUNCTION written_by_history();
     




 CREATE FUNCTION translated_by_history() RETURNS trigger AS $translated_by_history$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO translated_by_old(translated_id, person_id, book_id, insert_date, change_date, change)
            VALUES(OLD.translated_id, OLD.person_id, OLD.book_id, OLD.insert_date, CURRENT_DATE, 'update');
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO translated_by_old(translated_id, person_id, book_id, insert_date, change_date, change)
            VALUES(OLD.translated_id, OLD.person_id, OLD.book_id, OLD.insert_date, CURRENT_DATE, 'delete');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
    $translated_by_history$ LANGUAGE plpgsql;

    CREATE TRIGGER translated_by_history AFTER UPDATE OR DELETE ON translated_by
    FOR EACH ROW EXECUTE FUNCTION translated_by_history();
     




 CREATE FUNCTION language_book_history() RETURNS trigger AS $language_book_history$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO language_book_old(lb_id, languageb, book_id, insert_date, change_date, change)
            VALUES(OLD.lb_id, OLD.languageb, OLD.book_id, OLD.insert_date, CURRENT_DATE, 'update');
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO language_book_old(lb_id, languageb, book_id, insert_date, change_date, change)
            VALUES(OLD.lb_id, OLD.languageb, OLD.book_id, OLD.insert_date, CURRENT_DATE, 'delete');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
    $language_book_history$ LANGUAGE plpgsql;

    CREATE TRIGGER language_book_history AFTER UPDATE OR DELETE ON language_book
    FOR EACH ROW EXECUTE FUNCTION language_book_history();
     




 CREATE FUNCTION genre_book_history() RETURNS trigger AS $genre_book_history$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO genre_book_old(gb_id, genre, book_id, insert_date, change_date, change)
            VALUES(OLD.gb_id, OLD.genre, OLD.book_id, OLD.insert_date, CURRENT_DATE, 'update');
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO genre_book_old(gb_id, genre, book_id, insert_date, change_date, change)
            VALUES(OLD.gb_id, OLD.genre, OLD.book_id, OLD.insert_date, CURRENT_DATE, 'delete');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
    $genre_book_history$ LANGUAGE plpgsql;

    CREATE TRIGGER genre_book_history AFTER UPDATE OR DELETE ON genre_book
    FOR EACH ROW EXECUTE FUNCTION genre_book_history();
     




 CREATE FUNCTION borrowed_history() RETURNS trigger AS $borrowed_history$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO borrowed_old(borrowed_id, user_id, book_id, deadline, number_books, borrowed_date, returned_date, insert_date, change_date, change)
            VALUES(OLD.borrowed_id, OLD.user_id, OLD.book_id, OLD.deadline, OLD.number_books, OLD.borrowed_date, OLD.returned_date, OLD.insert_date, CURRENT_DATE, 'update');
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO borrowed_old(borrowed_id, user_id, book_id, deadline, number_books, borrowed_date, returned_date, insert_date, change_date, change)
            VALUES(OLD.borrowed_id, OLD.user_id, OLD.book_id, OLD.deadline, OLD.number_books, OLD.borrowed_date, OLD.returned_date, OLD.insert_date, CURRENT_DATE, 'delete');
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
    $borrowed_history$ LANGUAGE plpgsql;

    CREATE TRIGGER borrowed_history AFTER UPDATE OR DELETE ON borrowed
    FOR EACH ROW EXECUTE FUNCTION borrowed_history();










