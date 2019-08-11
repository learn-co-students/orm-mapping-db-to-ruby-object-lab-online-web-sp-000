class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new  #Same as Student.new
    new_student.id = row[0] #Pulls id INTEGER
    new_student.name = row[1] #Pulls name from database
    new_student.grade = row[2]  #Pulls grade from database
    new_student #returns the instance of student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL  #Execute this SQL query to return all students
      SELECT *
      FROM students
      SQL
      
    DB[:conn].execute(sql).map do |row| #returns an array of rows, then iterates
      self.new_from_db(row) #creates a new Ruby Object from each row
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL    #Passing in SQL query using Heredoc
      Select *
      FROM students
      WHERE name = ?
      LIMIT 1
      SQL
     #Passed in name parameter in SQL query
    DB[:conn].execute(sql, name).map do |row| #execute iteration, map with name
      self.new_from_db(row) #using method to grab the created instance
    end.first   #grabs the first element from the returned array
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
      SQL
      
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade IS NOT 12
      SQL
      
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade IS 10
      LIMIT ?
      SQL
      #Limit is ? to pass in the user's EXACT number of students
      
    DB[:conn].execute(sql, num).map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade IS 10
      LIMIT 1
      SQL
      #Limits the return to 1 to grab the first student
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade IS ?
      SQL
      
    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end
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
