require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    noob = Student.new 
    noob.id = row[0]
    noob.name = row[1]
    noob.grade = row[2]
    noob
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    
    sql = "SELECT * FROM students"
    rows = DB[:conn].execute(sql)
    rows.map{|row| self.new_from_db(row)}
  end
  
  def self.all_students_in_grade_9 
    sql = "SELECT * FROM students WHERE grade = 9"
    rows = DB[:conn].execute(sql)
    rows.map{|row| self.new_from_db(row)}
  end 
  
  def self.students_below_12th_grade 
    sql = "SELECT * FROM students WHERE grade < 12"
    rows = DB[:conn].execute(sql)
    rows.map{|row| self.new_from_db(row)}
  end 
  
  def self.first_student_in_grade_10
    sql = %{
      SELECT * FROM students 
      WHERE grade = 10 
      LIMIT 1
    }
    row = DB[:conn].execute(sql)[0]
    self.new_from_db(row)
  end 
  
  def self.first_X_students_in_grade_10(limit)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    rows = DB[:conn].execute(sql,limit)
    rows.map{|row| self.new_from_db(row)}
  end 
  
  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    rows = DB[:conn].execute(sql,grade)
    rows.map{|row| self.new_from_db(row)}
  end 

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    
    sql = %{ 
    SELECT * FROM students 
    WHERE name = ? LIMIT 1
    }
    
    row = DB[:conn].execute(sql, name)[0]
    noob = self.new_from_db(row)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
