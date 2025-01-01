-- Define the 'author' table
DEFINE TABLE author SCHEMAFULL;
DEFINE FIELD id ON TABLE author TYPE record<author>;
DEFINE FIELD name ON TABLE author TYPE string;
DEFINE FIELD bio ON TABLE author TYPE string;
DEFINE FIELD birth_date ON TABLE author TYPE datetime;
DEFINE FIELD time ON TABLE author TYPE object;
DEFINE FIELD time.created_at ON TABLE author TYPE datetime DEFAULT time::now();
DEFINE FIELD time.updated_at ON TABLE author TYPE datetime VALUE time::now();

-- Define the 'book' table
DEFINE TABLE book SCHEMAFULL;
DEFINE FIELD id ON TABLE book TYPE record<book>;
DEFINE FIELD title ON TABLE book TYPE string;
DEFINE FIELD summary ON TABLE book TYPE string;
DEFINE FIELD publication_date ON TABLE book TYPE datetime;
DEFINE FIELD price ON TABLE book TYPE number;
DEFINE FIELD currency ON TABLE book TYPE string;
DEFINE FIELD time ON TABLE book TYPE object;
DEFINE FIELD time.created_at ON TABLE book TYPE datetime DEFAULT time::now();
DEFINE FIELD time.updated_at ON TABLE book TYPE datetime VALUE time::now();

-- Define the 'genre' table
DEFINE TABLE genre SCHEMAFULL;
DEFINE FIELD id ON TABLE genre TYPE record<genre>;
DEFINE FIELD name ON TABLE genre TYPE string;
DEFINE FIELD description ON TABLE genre TYPE string;
DEFINE FIELD time ON TABLE genre TYPE object;
DEFINE FIELD time.created_at ON TABLE genre TYPE datetime DEFAULT time::now();
DEFINE FIELD time.updated_at ON TABLE genre TYPE datetime VALUE time::now();

-- Define the 'wrote' relation from 'author' to 'book'
DEFINE TABLE wrote TYPE RELATION FROM author TO book;
DEFINE FIELD id ON TABLE wrote TYPE record<wrote>;
DEFINE FIELD date_written ON TABLE wrote TYPE datetime;
DEFINE FIELD in ON TABLE wrote TYPE record<author>;
DEFINE FIELD out ON TABLE wrote TYPE record<book>;

-- Define the 'classified_as' relation from 'book' to 'genre'
DEFINE TABLE classified_as TYPE RELATION FROM book TO genre;
DEFINE FIELD id ON TABLE classified_as TYPE record<classified_as>;
DEFINE FIELD in ON TABLE classified_as TYPE record<book>;
DEFINE FIELD out ON TABLE classified_as TYPE record<genre>;