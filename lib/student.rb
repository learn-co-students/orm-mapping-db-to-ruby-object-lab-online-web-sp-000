require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class

    sql = <<-SQL
      SELECT * FROM students
    SQL
    students = DB[:conn].execute(sql)
    counter = 0
    while counter < students.length do
        self.new_from_db(students[counter])
        counter += 1
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL 
      SELECT students.id, students.name, students.grade 
      FROM students 
      WHERE students.name = name
    SQL
    student = DB[:conn].execute(sql)
    self.new_from_db(student.flatten)
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL 
      SELECT students.id, students.name, students.grade 
      FROM students 
      WHERE students.grade = 9
    SQL
    students = DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL 
      SELECT students.id, students.name, students.grade 
      FROM students 
      WHERE students.grade < 12
    SQL
    students = DB[:conn].execute(sql)
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