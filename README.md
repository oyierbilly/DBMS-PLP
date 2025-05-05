# DATABASE MANAGEMENT SYSTEMS POWER LEARN PROJECT ASSIGNMENT
This is a DBMS assignment that involed building a complete Database Management System and creating a Simple CRUD API Using MySQL and Python. The project is 
divided into two sections which are Question 1 and Question 2.

## Question 1
In this section, I designed a Library Management Database System. This SQL database is designed for managing a library system, including books, members,
loans, fines, and authors. It supports:
- ✔ Book inventory tracking (availability, copies)
- ✔ Member management (registration, status)
- ✔ Loan & return operations
- ✔ Fine calculation for overdue books
- ✔ Author-book relationships (many-to-many)

## Database Schema
### Tables
The Database has 6 tables each with a description organized as:
1. members - Library members (users)
2. books - Book inventory with availability
3. loans	Active/returned book loans
4. fines	Overdue fines
5. authors	Book authors
6. book_authors	Many-to-many book-author linking

## Table Relationships

![library_management erd](https://github.com/user-attachments/assets/cc2ae3a2-fb98-428d-85a7-25f379323967)

⚙️ Key Features
✅ Constraints & Validation
1. CHECK for valid email formats.
2. CHECK for logical dates (e.g., due_date > loan_date)
3. ENUM for statuses (active, expired, overdue)

✅ Referential Integrity
1. FOREIGN KEY with ON UPDATE CASCADE
2. ON DELETE CASCADE for dependent records

✅ Sample Data
Pre-populated with:
- 3 members
- 3 books
- 3 authors
- 2 loan records

## 🚀Setup
1. Run the SQL script in MySQL:
   ```sql
     mysql -u root -p < library_management.sql
     ```

2. Verify tables:
    ```sql
     SHOW TABLES;
     SELECT * FROM books;
     ```

3. You can then proceed to query the tables.

## QUESTION 2
For this section I ceated a simple CRUD API using the following technologies:
- FastAPI (Python web framework)
- MySQL (Database)
- Pydantic (Data validation)

## Features
- User management (Create/Read)
- Task operations (Create/Read/Update/Delete)
- Task status tracking (pending/in_progress/completed)
- Priority levels (low/medium/high)

## Setup
Prerequisites
- Python 3.7+
- MySQL Server
- pip package manager

## Installation
1. Clone the repository
2. Install dependencies:
   ```bash
     pip install fastapi mysql-connector-python uvicorn
     ```
3. Set up MySQL database:
     ```bash
     mysql -u root -p < task_manager.sql
     ```
4. Start the API server
   ```bash
     uvicorn main:app --reload
     ```

## API Endpoints
### Users
- POST /users/ - Create new user
- GET /users/ - List all users

### Tasks
- POST /tasks/ - Create new task
- GET /tasks/ - List all tasks
- PUT /tasks/{task_id} - Update task
- DELETE /tasks/{task_id} - Delete task



