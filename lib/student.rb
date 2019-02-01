require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
   students = []
   sql = <<-SQL 
         SELECT * FROM students 
       SQL
   student_rows = DB[:conn].execute(sql)
   
   student_rows.each {|i| students << new_from_db(i)}
   students
  end

  def self.find_by_name(name)
    sql = <<-SQL 
         SELECT * FROM students WHERE students.name==? LIMIT 1
       SQL
   student_row = DB[:conn].execute(sql, name)
   new_from_db(student_row[0])
  end
  
  def self.all_students_in_grade_9
    students = []
    sql = <<-SQL 
         SELECT * FROM students WHERE students.grade==9
       SQL
   student_rows = DB[:conn].execute(sql)
   student_rows.each {|i| students << new_from_db(i)}
   students
  end
  
  def self.students_below_12th_grade
    students = []
    sql = <<-SQL 
         SELECT * FROM students WHERE students.grade<12
       SQL
   student_rows = DB[:conn].execute(sql)
   student_rows.each {|i| students << new_from_db(i)}
   students
  end
  
  def self.first_X_students_in_grade_10(x)
    students = []
    sql = <<-SQL 
         SELECT * FROM students WHERE students.grade==10 LIMIT ?
       SQL
   student_rows = DB[:conn].execute(sql, x)
   student_rows.each {|i| students << new_from_db(i)}
   students
  end
  
  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0]
  end
  
  def self.all_students_in_grade_X(x)
    students = []
    sql = <<-SQL 
         SELECT * FROM students WHERE students.grade==?
       SQL
   student_rows = DB[:conn].execute(sql, x)
   student_rows.each {|i| students << new_from_db(i)}
   students
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
