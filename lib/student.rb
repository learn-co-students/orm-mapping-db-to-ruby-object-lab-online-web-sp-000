class Student
  attr_accessor :id, :name, :grade

  def initialize(name: nil, grade: nil, id: nil)
    @name = name
    @grade = grade
    @id = id
  end

  #row = [1, "Pat", 12]
  #pat = Student.new_from_db(row)

  def self.new_from_db(row)
    Student.new(id: row[0], name: row[1], grade: row[2])
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    student_data = DB[:conn].execute("SELECT * FROM students WHERE name = ? ", name)
    return self.new_from_db(student_data[0])
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
    student_data = DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
    student_data.map do |student_row|
      new_from_db(student_row)
    end
  end

  def self.students_below_12th_grade
    student_data = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    student_data.map do |student_row|
      new_from_db(student_row)
    end
  end

  def self.all
    student_data = DB[:conn].execute("SELECT * FROM students")
    student_data.map do |student_row|
      new_from_db(student_row)
    end
  end

  def self.first_X_students_in_grade_10(x)
    student_data = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", x)
    student_data.map do |student_row|
      new_from_db(student_row)
    end
  end

  def self.first_student_in_grade_10
    student_data = DB[:conn].execute("SELECT * FROM students WHERE grade = 10")
    new_from_db(student_data[0])
  end

  def self.all_students_in_grade_X(grade)
    student_data = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade)
    student_data.map do |student_row|
      new_from_db(student_row)
    end
  end


end
