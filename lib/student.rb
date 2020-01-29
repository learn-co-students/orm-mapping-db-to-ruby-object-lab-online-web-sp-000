class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.db_get(query)
    DB[:conn].execute(query).map{ |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    self.db_get("SELECT * FROM students WHERE name = '#{name}' LIMIT 1").first
  end

  def self.all
    self.db_get('SELECT * FROM students')
  end

  def self.all_students_in_grade_9
    self.db_get('SELECT * FROM students WHERE grade = 9')
  end

  def self.students_below_12th_grade
    self.db_get('SELECT * FROM students WHERE grade < 12')
  end

  def self.first_X_students_in_grade_10(limit)
    self.db_get("SELECT * FROM students WHERE grade = 10 LIMIT #{limit}")
  end

  def self.first_student_in_grade_10
    self.db_get('SELECT * FROM students WHERE grade = 10 LIMIT 1').first
  end

  def self.all_students_in_grade_X(grade)
    self.db_get("SELECT * FROM students WHERE grade = #{grade}")
  end

  def self.drop_table() DB[:conn].execute('DROP TABLE IF EXISTS students') end

  def save
    DB[:conn].execute(
      'INSERT INTO students(name,grade) VALUES(?,?)', self.name, self.grade
    )
  end

  def self.create_table
    DB[:conn].execute(<<~SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    )
  end

end
