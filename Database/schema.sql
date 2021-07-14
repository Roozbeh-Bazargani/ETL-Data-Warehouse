CREATE TABLE Author
(
	author_id INTEGER NOT NULL,
	last_name CHAR(20) NOT NULL,
	first_name CHAR(20),
	PRIMARY KEY (author_id)
);

CREATE TABLE Translator
(
	translator_id INTEGER NOT NULL,
	last_name CHAR(20) NOT NULL,
	first_name CHAR(20),
	PRIMARY KEY (translator_id)
);


CREATE TABLE Languageb
(
	languageb CHAR(20) NOT NULL,
	PRIMARY KEY (languageb)
);

CREATE TABLE Genre
(
	genre CHAR(20) NOT NULL,
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
	PRIMARY KEY (ISBN),
	FOREIGN KEY (main_author) REFERENCES Author,
	FOREIGN KEY (main_language) REFERENCES Languageb,
	FOREIGN KEY (main_genre) REFERENCES GENRE
);

CREATE TABLE User_library
(
	user_id INTEGER NOT NULL,
	last_name CHAR(40) NOT NULL,
	first_name CHAR(40),
	birth_date DATE,
	register_date DATE,
	register_number INTEGER,
	telephone INTEGER,
	address CHAR(200),
	PRIMARY KEY (user_id)
);

CREATE TABLE Written_by
(
	written_id INTEGER NOT NULL,
	author_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	PRIMARY KEY (written_id),
	FOREIGN KEY (author_id) REFERENCES Author,
	FOREIGN KEY (book_id) REFERENCES Book
);

CREATE TABLE Translated_by
(
	translated_id INTEGER NOT NULL,
	translator_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	PRIMARY KEY (translated_id),
	FOREIGN KEY (translator_id) REFERENCES Translator,
	FOREIGN KEY (book_id) REFERENCES Book
);


CREATE TABLE Language_book
(
	lb_id INTEGER NOT NULL,
	languageb CHAR(20) NOT NULL,
	book_id INTEGER NOT NULL,
	PRIMARY KEY (lb_id),
	FOREIGN KEY (languageb) REFERENCES Languageb,
	FOREIGN KEY (book_id) REFERENCES Book
);


CREATE TABLE Genre_book
(
	gb_id INTEGER NOT NULL,
	genre CHAR(20) NOT NULL,
	book_id INTEGER NOT NULL,
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
	PRIMARY KEY (borrowed_id),
	FOREIGN KEY (user_id) REFERENCES User_library,
	FOREIGN KEY (book_id) REFERENCES Book
);




CREATE FUNCTION borrow_book() RETURNS trigger AS $borrow_book$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
			IF (NEW.number_books > (SELECT number_available
								   FROM Book
								   WHERE NEW.book_id=ISBN)) THEN
				RETURN OLD;
			ELSE
				UPDATE Book
				SET number_available = number_available - NEW.number_books
				WHERE ISBN = NEW.book_id;
			END IF;
		ELSEIF (TG_OP = 'UPDATE') THEN
			IF (OLD.returned_date IS NULL AND NEW.returned_date IS NOT NULL) THEN
				UPDATE Book
				SET number_available = number_available + OLD.number_books
				WHERE ISBN = OLD.book_id;
			END IF;
        END IF;
        RETURN NEW; -- result is ignored since this is an AFTER trigger
    END;
$borrow_book$ LANGUAGE plpgsql;

CREATE TRIGGER borrow_book BEFORE INSERT OR UPDATE ON Borrowed
    FOR EACH ROW EXECUTE FUNCTION borrow_book();
	
	
	
	
CREATE FUNCTION borrow_book_a() RETURNS trigger AS $borrow_book_a$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            UPDATE Book
			SET number_available = number_available + OLD.number_books
			WHERE ISBN = OLD.book_id;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$borrow_book_a$ LANGUAGE plpgsql;

CREATE TRIGGER borrow_book_a AFTER DELETE ON Borrowed
    FOR EACH ROW EXECUTE FUNCTION borrow_book_a();