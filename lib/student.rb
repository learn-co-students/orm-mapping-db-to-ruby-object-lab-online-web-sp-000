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
    result = DB[:conn].execute(sql)
    array = result.map do | row |
      self.new_from_db(row)
    end
    array #should be an array of student instances
  end

  def self.all_students_in_grade_9
    sql = <<-SQL 
    SELECT * FROM students WHERE grade = 9
    SQL
    result = DB[:conn].execute(sql)
    array = result.map do | row |
      self.new_from_db(row)
    end
    array
  end

  def self.students_below_12th_grade
    sql = <<-SQL 
    SELECT * FROM students WHERE grade < 12
    SQL
    result = DB[:conn].execute(sql)
    array = result.map do | row |
      self.new_from_db(row)
    end
    array
  end 

  def self.first_X_students_in_grade_10(limit)
    sql = <<-SQL 
    SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL
    result = DB[:conn].execute(sql, limit)
    array = result.map do | row |
      self.new_from_db(row)
    end
    array
  end 

  def self.first_student_in_grade_10
    sql = <<-SQL 
    SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL
    result = DB[:conn].execute(sql)
    array = result.map do | row |
      self.new_from_db(row)
    end
    #it expect the instance inside the array, not the array.
    array[0]
  end 

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL 
    SELECT * FROM students WHERE grade = ?
    SQL
    result = DB[:conn].execute(sql, grade)
    array = result.map do | row |
      self.new_from_db(row)
    end
    array
  end 

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL 
    SELECT * FROM students WHERE name = ? LIMIT 1 
    SQL
    result = DB[:conn].execute(sql, name)
    #since we limit to one, result will be an array with one item. that item is another array. 
    #it looks like this [[1, "pat", 12]]
    arrayofoneinstance = result.map do | row |
      self.new_from_db(row)
    end
    #note: while each returns the old array, and map returns the new array
    #both methods leave the original array intact. returns does not mean mutate original array
    #if u access it it's still the same

    # return a new instance of the Student class
    arrayofoneinstance[0]
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
