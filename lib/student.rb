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
    DB[:conn].execute("SELECT * FROM students;").map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.name = ?
    SQL

    self.new_from_db(DB[:conn].execute(sql, name)[0])
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9").map{|row| self.new_from_db(row)}
  end
  
  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12").map{|row| self.new_from_db(row)}
  end
  
  def self.first_X_students_in_grade_10(limit)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", limit).map{|row| self.new_from_db(row)}
  end
  
  def self.first_student_in_grade_10
    self.new_from_db(DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1")[0])
  end
  
  def self.all_students_in_grade_X(grade)
    DB[:conn].execute("SELECT * FROM students WHERE students.grade = grade").map{|row| self.new_from_db(row)}
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
