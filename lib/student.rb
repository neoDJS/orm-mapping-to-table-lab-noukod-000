class Student
  attr_reader  :id
  attr_accessor :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade, id=nil)
    @id = id
    self.name = name
    self.grade = grade
  end

  def self.create_table
    sql =  <<-SQL
                CREATE TABLE IF NOT EXISTS students (
                  id INTEGER PRIMARY KEY,
                  name TEXT,
                  grade INTEGER
                )
          SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql =  <<-SQL
                DROP TABLE IF EXISTS students
          SQL
    DB[:conn].execute(sql)
  end

  def save
    sql =  <<-SQL
                INSERT INTO students (name, grade)
                VALUES (?, ?)
          SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("Select last_insert_rowid() from students").flatten.first
  end

  def self.create(name:, grade:)
    s = self.new(name, grade)
    s.save
    s
  end
end
