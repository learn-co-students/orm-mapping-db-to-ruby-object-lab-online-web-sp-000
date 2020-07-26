class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new  # self.new is the same as running Student.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name=?
    LIMIT 1
    SQL
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def self.all_students_in_grade_9
    # returns an array of all students in grades 9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade=?
    SQL
    all_in_9=DB[:conn].execute(sql,"9")
  end
  
  def self.students_below_12th_grade
    # returns an array of all students in grades 11 or below
    arr=[]
    self.all.find {|obj| 
      if obj.grade.to_i<=11
        arr << obj
      end
    }
    arr
  end
  
  def self.all
    # returns all student instances from the db
    sql = <<-SQL
    SELECT *
    FROM students
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(x)
    # returns an array of the first X students in grade 10
    arr=[]
    i=1
    self.all.map {|obj|
      if obj.grade.to_i==10 and i<=x
        arr << obj
        i+=1
      end
    }
    arr
  end
  
  def self.first_student_in_grade_10
    # returns the first student in grade 10
    self.all.find {|obj| obj.grade.to_i==10}
  end
  
  def self.all_students_in_grade_X(x)
    #returns an array of all students in a given grade X 
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade=?
    SQL
    DB[:conn].execute(sql,x)
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
