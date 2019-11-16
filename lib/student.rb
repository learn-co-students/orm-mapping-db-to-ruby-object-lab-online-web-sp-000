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
    sql = <<-WTF
      SELECT * 
      FROM students
      WTF
    
    make_a_new_db(sql)
    
    #DB[:conn].execute(sql).map do |row|
      #self.new_from_db(row)
    #end
    
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save
    sql = "INSERT INTO students (name, grade) VALUES (?, ?)"

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

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end
    
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL
    
    make_a_new_db(sql)

    #DB[:conn].execute(sql).map do |row|
    #  self.new_from_db(row)
    #end
  end
  
  def self.first_X_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY students.id LIMIT #{num}"
    
    make_a_new_db(sql)
  end
  
  def self.make_a_new_db(with_this) #helper method for standard DB
    DB[:conn].execute(with_this).map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.all_students_in_grade_X(num)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = #{num}
    SQL
 
    make_a_new_db(sql)
  end   
  
  def self.first_student_in_grade_10
    first_X_students_in_grade_10(5).first
  end
    
end


