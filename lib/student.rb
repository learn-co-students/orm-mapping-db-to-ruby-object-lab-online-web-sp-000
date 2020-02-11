


class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0] 
    new_student.name = row[1] 
    new_student.grade = row[2] 
    new_student 
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).collect do |student|
      self.new_from_db(student)
    end 
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL 
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1 
    SQL
    
    new_student = nil
    DB[:conn].execute(sql, name).each do |student|
      new_student = student
    end 
    self.new_from_db(new_student)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL 
      SELECT name FROM students 
      WHERE grade = 9
    SQL
    grade_9_students = [] 
    DB[:conn].execute(sql).each do |student|
      grade_9_students << student 
    end 
    grade_9_students
  end 
  
  def self.students_below_12th_grade 
    students_below_12th_grade = []
    self.all.each do |student|
      if student.grade.to_i < 12 
        students_below_12th_grade << student 
      end 
    end 
    students_below_12th_grade
  end 

  def self.first_X_students_in_grade_10(num_students)
    # student_counter = 0 
    # first_x_students = [] 
    # while student_counter < num_students 
    #   first_x_students << self.all.select {|student| student.grade.to_i == 10}
    #   student_counter += 1
    # end 
    # first_x_students 
    first_x_students = []
    1.upto(num_students) do |student|
      first_x_students << self.all.select {|student| student.grade.to_i == 10}
    end 
    binding.pry 
    self.new_from_db(first_x_students.flatten)
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
