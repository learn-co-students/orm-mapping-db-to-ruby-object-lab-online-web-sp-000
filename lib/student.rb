class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < ?
    SQL

    students_below_12th_grade_12 = DB[:conn].execute(sql, 12)
    students_below_12th_grade_12.collect {|student| self.new_from_db(student)}
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    students_in_grade_9 = DB[:conn].execute(sql, 9)
    students_in_grade_9.collect {|student| self.new_from_db(student)}

  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    students_in_grade_x = DB[:conn].execute(sql, grade)
    students_in_grade_x.collect {|student| self.new_from_db(student)}


  end
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    students_in_grade_10 = DB[:conn].execute(sql, 10)
    students_in_grade_10.collect {|student| self.new_from_db(student)}.first

  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ? LIMIT ?
    SQL

    students_in_grade_10 = DB[:conn].execute(sql, 10, x)
    students_in_grade_10.collect {|student| self.new_from_db(student)}

  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    student_array = DB[:conn].execute(sql)
    student_array.collect do |student|
      self.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    student = DB[:conn].execute(sql, name)
    student.collect {|data| self.new_from_db(data)}.first
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
