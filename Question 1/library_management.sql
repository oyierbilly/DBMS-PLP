-- Create database
CREATE DATABASE IF NOT EXISTS library_management;
USE library_management;

-- Members table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    join_date DATE NOT NULL,
    membership_status ENUM('active', 'expired', 'suspended') DEFAULT 'active',
    CHECK (email LIKE '%@%.%')
);

-- Books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publisher VARCHAR(100),
    publication_year INT,
    genre VARCHAR(50),
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    CHECK (available_copies <= total_copies),
    CHECK (publication_year BETWEEN 1500 AND YEAR(CURRENT_DATE))
);

-- Loans table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('active', 'returned', 'overdue') DEFAULT 'active',
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON UPDATE CASCADE,
    CHECK (due_date > loan_date),
    CHECK (return_date IS NULL OR return_date >= loan_date)
);

-- Fines table
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issue_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    payment_date DATE,
    status ENUM('unpaid', 'paid') DEFAULT 'unpaid',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON UPDATE CASCADE,
    CHECK (amount > 0),
    CHECK (payment_date IS NULL OR payment_date >= issue_date)
);

-- Authors table (for many-to-many relationship with books)
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    bio TEXT
);

-- Book-Author junction table (M-M relationship)
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Insert sample data
INSERT INTO members (first_name, last_name, email, phone, join_date, membership_status) VALUES
('Billy', 'Oyier', 'oyierbilly01@gmail.com', '0757578814', '2025-01-15', 'active'),
('Isaac', 'Isachaar', 'isaac@egail.com', '0720701719', '2025-01-01', 'active'),
('Jacob', 'Mumia', 'mumia.j@email.com', NULL, '2025-01-30', 'expired');

INSERT INTO books (isbn, title, author, publisher, publication_year, genre, total_copies, available_copies) VALUES
('978-0061120084', 'To Kill a Mockingbird', 'Harper Lee', 'J. B. Lippincott & Co.', 1960, 'Fiction', 5, 3),
('978-0451524935', '1984', 'George Orwell', 'Secker & Warburg', 1949, 'Dystopian', 3, 1),
('978-0743273565', 'The Great Gatsby', 'F. Scott Fitzgerald', 'Charles Scribner''s Sons', 1925, 'Classic', 2, 2);

INSERT INTO authors (name, bio) VALUES
('Harper Lee', 'American novelist famous for To Kill a Mockingbird'),
('George Orwell', 'English novelist and essayist'),
('F. Scott Fitzgerald', 'American novelist and short story writer');

INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), (2, 2), (3, 3);

INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date, status) VALUES
(1, 1, '2023-01-20', '2025-02-20', NULL, 'active'),
(2, 2, '2023-02-15', '2025-03-15', '2023-03-10', 'returned');

INSERT INTO fines (loan_id, amount, issue_date, payment_date, status) VALUES
(2, 5.00, '2025-03-11', NULL, 'unpaid');