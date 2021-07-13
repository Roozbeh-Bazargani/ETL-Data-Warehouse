CREATE TABLE Book
(
	book_id INTEGER NOT NULL,
	ISBN INTEGER NOT NULL,
	title CHAR(40) NOT NULL,
	description CHAR(100),
	edition INTEGER,
	published_date DATE,
	publisher CHAR(40),
	insert_date DATE,
	PRIMARY KEY (book_id),
	UNIQUE (title, ISBN)
);

CREATE TABLE Writer
(
	writer_id INTEGER NOT NULL,
	last_name CHAR(20) NOT NULL,
	first_name CHAR(20),
	insert_date DATE,
	PRIMARY KEY (writer_id)
);

CREATE TABLE Translator
(
	translator_id INTEGER NOT NULL,
	last_name CHAR(20) NOT NULL,
	first_name CHAR(20),
	insert_date DATE,
	PRIMARY KEY (translator_id)
);


CREATE TABLE Languageb
(
	languageb CHAR(20) NOT NULL,
	insert_date DATE,
	PRIMARY KEY (languageb)
);

CREATE TABLE Genre
(
	genre CHAR(20) NOT NULL,
	insert_date DATE,
	PRIMARY KEY (genre)
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
	insert_date DATE,
	PRIMARY KEY (user_id)
);

CREATE TABLE Written_by
(
	written_id INTEGER NOT NULL,
	writer_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE,
	PRIMARY KEY (written_id),
	FOREIGN KEY (writer_id) REFERENCES Writer,
	FOREIGN KEY (book_id) REFERENCES Book
);

CREATE TABLE Translated_by
(
	translated_id INTEGER NOT NULL,
	translator_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE,
	PRIMARY KEY (translated_id),
	FOREIGN KEY (translator_id) REFERENCES Translator,
	FOREIGN KEY (book_id) REFERENCES Book
);


CREATE TABLE Language_book
(
	lb_id INTEGER NOT NULL,
	languageb CHAR(20) NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE,
	PRIMARY KEY (lb_id),
	FOREIGN KEY (languageb) REFERENCES Languageb,
	FOREIGN KEY (book_id) REFERENCES Book
);


CREATE TABLE Genre_book
(
	gb_id INTEGER NOT NULL,
	genre CHAR(20) NOT NULL,
	book_id INTEGER NOT NULL,
	insert_date DATE,
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
	borrowed_date DATE,
	returned_date DATE,
	insert_date DATE,
	PRIMARY KEY (borrowed_id),
	FOREIGN KEY (user_id) REFERENCES User_library,
	FOREIGN KEY (book_id) REFERENCES Book
);





