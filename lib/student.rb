class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.new_from_rows(rows)
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.all
    sql = "SELECT * FROM students"

    new_from_rows(DB[:conn].execute(sql))
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    new_from_rows(DB[:conn].execute(sql, name)).first
  end

  def save
    sql = "INSERT INTO students (name, grade) VALUES (?, ?)"

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]

    self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
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
      WHERE grade = 9
    SQL

    new_from_rows(DB[:conn].execute(sql))
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL

    new_from_rows(DB[:conn].execute(sql))
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      ORDER BY id
      LIMIT ?
    SQL

    new_from_rows(DB[:conn].execute(sql, x))
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      ORDER BY id
      LIMIT 1
    SQL

    new_from_rows(DB[:conn].execute(sql)).first
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    new_from_rows(DB[:conn].execute(sql, x))
  end
end