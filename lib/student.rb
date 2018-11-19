require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    all = DB[:conn].execute("SELECT * FROM students")
    all.map do |student_row|
      self.new_from_db(student_row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?;
    SQL

    student_row = DB[:conn].execute(sql, name).flatten
    self.new_from_db(student_row)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
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
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 9;
    SQL

    grade_9 = DB[:conn].execute(sql)
    grade_9.map {|student| self.new_from_db(student)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < 12;
    SQL

    below_grade_12 = DB[:conn].execute(sql)
    below_grade_12.map {|student| self.new_from_db(student)}
  end

  def self.first_X_students_in_grade_10(num_of_students)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT ?;
    SQL

    first_students = DB[:conn].execute(sql, num_of_students)
    first_students.map {|student| self.new_from_db(student)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT 1;
    SQL

    first_student = DB[:conn].execute(sql).flatten
    self.new_from_db(first_student)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?;
    SQL

    grade_X = DB[:conn].execute(sql, grade)
    grade_X.map {|student| self.new_from_db(student)}
  end
end
