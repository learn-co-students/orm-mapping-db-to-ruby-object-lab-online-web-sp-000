class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new.tap do |s|
      s.id = row[0]
      s.name = row[1]
      s.grade = row[2]
    end
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students
    SQL

    # for each row returned from the SQL query, create a new Student
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  # Find all students in 9th grade
  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # Find all students below 12th grade
  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # Returns the first X students in 10th grade
  def self.first_X_students_in_grade_10(limit)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT ?
    SQL

    DB[:conn].execute(sql, limit).map do |row|
      self.new_from_db(row)
    end
  end

  # Returns the first student in 10th grade
  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  # Returns the first X students in 10th grade
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
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
