PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT,
    lname TEXT
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT,
    body TEXT,
    author_id INTEGER,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    question_id INTEGER,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER,
    user_id INTEGER,
    body TEXT,

    child_reply INTEGER,
    parent_reply INTEGER,
    
    FOREIGN KEY (parent_reply) REFERENCES replies(id),
    FOREIGN KEY (child_reply) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER,
    user_id INTEGER,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES replies(id)
);


INSERT INTO users (fname, lname)
VALUES ("Zaid", "Mansuri");

INSERT INTO questions (title, body, author_id)
VALUES ("Distance between sun and earth", "What is it?", (SELECT id FROM users WHERE fname = 'Zaid'));



