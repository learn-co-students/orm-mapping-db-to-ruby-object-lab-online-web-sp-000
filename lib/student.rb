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
    students = DB[:conn].execute("SELECT * FROM students").map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    db_student = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).first
    self.new_from_db(db_student)
  end

  def self.all_students_in_grade_9
    students = DB[:conn].execute("SELECT * FROM students WHERE grade = 9").map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    students = DB[:conn].execute("SELECT * FROM students WHERE grade < 12").map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(count)
    students = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", count).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    row = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1").first
    self.new_from_db(row)
  end

  def self.all_students_in_grade_X(grade)
    students = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade).map do |row|
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
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end
end
