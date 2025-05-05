from fastapi import FastAPI, HTTPException, Depends
import mysql.connector
from mysql.connector import Error
from pydantic import BaseModel
from typing import List, Optional
from datetime import date

app = FastAPI()

# Database connection
def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="task_manager"
        )
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        raise HTTPException(status_code=500, detail="Database connection error")

# Models
class UserCreate(BaseModel):
    username: str
    email: str

class User(UserCreate):
    user_id: int
    created_at: str

class TaskCreate(BaseModel):
    user_id: int
    title: str
    description: Optional[str] = None
    status: Optional[str] = "pending"
    priority: Optional[str] = "medium"
    due_date: Optional[date] = None

class Task(TaskCreate):
    task_id: int
    created_at: str

# CRUD Operations for Users
@app.post("/users/", response_model=User)
def create_user(user: UserCreate, db=Depends(get_db_connection)):
    cursor = db.cursor(dictionary=True)
    try:
        cursor.execute(
            "INSERT INTO users (username, email) VALUES (%s, %s)",
            (user.username, user.email)
        )
        db.commit()
        user_id = cursor.lastrowid
        cursor.execute("SELECT * FROM users WHERE user_id = %s", (user_id,))
        new_user = cursor.fetchone()
        return new_user
    except Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        db.close()

@app.get("/users/", response_model=List[User])
def read_users(db=Depends(get_db_connection)):
    cursor = db.cursor(dictionary=True)
    try:
        cursor.execute("SELECT * FROM users")
        users = cursor.fetchall()
        return users
    finally:
        cursor.close()
        db.close()

# CRUD Operations for Tasks
@app.post("/tasks/", response_model=Task)
def create_task(task: TaskCreate, db=Depends(get_db_connection)):
    cursor = db.cursor(dictionary=True)
    try:
        cursor.execute(
            """INSERT INTO tasks 
            (user_id, title, description, status, priority, due_date) 
            VALUES (%s, %s, %s, %s, %s, %s)""",
            (task.user_id, task.title, task.description, 
             task.status, task.priority, task.due_date)
        )
        db.commit()
        task_id = cursor.lastrowid
        cursor.execute("SELECT * FROM tasks WHERE task_id = %s", (task_id,))
        new_task = cursor.fetchone()
        return new_task
    except Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        db.close()

@app.get("/tasks/", response_model=List[Task])
def read_tasks(db=Depends(get_db_connection)):
    cursor = db.cursor(dictionary=True)
    try:
        cursor.execute("SELECT * FROM tasks")
        tasks = cursor.fetchall()
        return tasks
    finally:
        cursor.close()
        db.close()

@app.put("/tasks/{task_id}", response_model=Task)
def update_task(task_id: int, task: TaskCreate, db=Depends(get_db_connection)):
    cursor = db.cursor(dictionary=True)
    try:
        cursor.execute(
            """UPDATE tasks SET 
            user_id = %s, title = %s, description = %s, 
            status = %s, priority = %s, due_date = %s 
            WHERE task_id = %s""",
            (task.user_id, task.title, task.description, 
             task.status, task.priority, task.due_date, task_id)
        )
        db.commit()
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Task not found")
        cursor.execute("SELECT * FROM tasks WHERE task_id = %s", (task_id,))
        updated_task = cursor.fetchone()
        return updated_task
    except Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        db.close()

@app.delete("/tasks/{task_id}")
def delete_task(task_id: int, db=Depends(get_db_connection)):
    cursor = db.cursor()
    try:
        cursor.execute("DELETE FROM tasks WHERE task_id = %s", (task_id,))
        db.commit()
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Task not found")
        return {"message": "Task deleted successfully"}
    except Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        db.close()