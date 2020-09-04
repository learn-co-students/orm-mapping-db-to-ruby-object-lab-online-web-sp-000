class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map {|student| self.new_from_db(student)}
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    DB[:conn].execute(sql,name).map {|student| Student.new_from_db(student)}.first
    # find the student in the database given a name
    # return a new instance of the Student class
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

  def self.all_students_in_grade_9
    sql_grade_9 = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL
    DB[:conn].execute(sql_grade_9).map {|student| self.new_from_db(student)}
  end

  def self.students_below_12th_grade
    sql_under_grade_12 = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL
    DB[:conn].execute(sql_under_grade_12).map {|student| self.new_from_db(student)}
  end

  def self.first_X_students_in_grade_10(x)
    sql_grade_10 = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT ?
    SQL
    DB[:conn].execute(sql_grade_10,x).map {|student| self.new_from_db(student)}
  end

  def self.first_student_in_grade_10
    sql_only_one = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    SQL
    DB[:conn].execute(sql_only_one).collect {|student| self.new_from_db(student)}.first
  end

  def self.all_students_in_grade_X(x)
    sql_grade_x = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL
    DB[:conn].execute(sql_grade_x,x).map {|student| self.new_from_db(student)}
  end


end
