require 'sqlite3'
require 'singleton'


class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    attr_accessor :fname, :lname, :id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map { |datum| self.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def create
        raise "#{self} is already in the table" if @id
        QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
            INSERT INTO
                users (fname, lname)
            VALUES
                (?, ?)
            SQL
            @id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update
        raise " #{self} not in table" unless @id 
        QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
            UPDATE
                users 
            SET
                fname = ?,
                lname = ?
            WHERE
                id = ?
            SQL
    end

    def self.find_by_id(id)
        # run sql query to retreive row matching "id"
        # initialize it as Users object
        # return that object
        data = QuestionsDatabase.instance.execute("SELECT * FROM users WHERE id = #{id}")
        User.new(data[0])
    end

end

class Question
    attr_accessor :id, :title, :body, :author_id
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| self.new(datum) }        
    end

    def self.find_by_author_id(author_id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE author_id = #{author_id}")
        
    end
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def create
        raise "#{self} is already in the table" if @id
        QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
            INSERT INTO
                questions (title, body, author_id)
            VALUES
                (?, ?, ?)
            SQL
        @id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update
        raise " #{self} not in table" unless @id 
        QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id, @id)
            UPDATE
                questions 
            SET
                title = ?,
                body = ?,
                author_id = ?
            WHERE
                id = ?
            SQL
    end

    def self.find_by_id(id)
        # run sql query to retreive row matching "id"
        # initialize it as Users object
        # return that object
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE id = #{id}")
        User.new(data[0])
    end
    
end

class Reply
    attr_accessor :id, :question_id, :user_id, :body

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map { |datum| self.new(datum) }        
    end

    def self.find_by_user_id(user_id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE user_id = #{user_id}")
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
        @body = options['body']
        @child_reply = options['child_reply']
        @parent_reply = options['parent_reply']
    end

    def create
        raise "#{self} is already in the table" if @id
        QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id, @body, @parent_reply, @child_reply)
            INSERT INTO
                replies (question_id, user_id, body, parent_reply, child_reply)
            VALUES
                (?, ?, ?, ?, ?)
            SQL
        @id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update
        raise " #{self} not in table" unless @id 
        QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id, @body, @child_reply, @parent_reply, @id)
            UPDATE
                questions 
            SET
                question_id = ?,
                user_id = ?,
                body = ?,
                child_reply = ?
                parent_reply = ?
            WHERE
                id = ?
            SQL
    end

    def find_by_id
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE id = #{self.id}")
        data[0]
    end

end

class QuestionLike
    
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
        data.map { |datum| QuestionLike.new(datum)}
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    def create
        return "#{self} is already in table" if @id
        QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id)
            INSERT INTO 
                question_likes(question_id, user_id)
            VALUES
                (?, ?)

        SQL
        @id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update
        return "#{self} is not in table" unless @id
        QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id, @id)
            UPDATE
                question_likes
            SET
                question_id = ?,
                user_id = ?
            WHERE
                id = ?
        SQL
    end

    def find_by_id
        data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes WHERE id = #{id}")
    end
end

class QuestionFollow
    attr_accessor :id, :user_id, :question_id
    def self.all
       data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
       data.map { |datum| QuestionFollow.new(datum) }     
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def create
        return "#{self} is already in the table" if @id

        QuestionsDatabase.instance.execute(<<-SQL, @user_id, @question_id)
            INSERT INTO
                question_follows(user_id, question_id)
            VALUES
                (?, ?)
        SQL

        @id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update
        return "#{self} is not in the table" unless @id

        QuestionsDatabase.instance.execute(<<-SQL, @user_id, @question_id, @id)
            UPDATE
                question_follows(user_id, question_id)
            SET
                (?, ?)
            WHERE
                id = ?
        SQL
    end

    def find_by_id
        data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows WHERE id = #{@id}")
        data[0]
    end
end