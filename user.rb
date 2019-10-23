require_relative "requires.rb"

class User
    attr_accessor :fname, :lname, :id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map { |datum| self.new(datum) }
    end

    def self.find_by_name(fname_in, lname_in)
        data = QuestionsDatabase.instance.execute(<<-SQL, fname_in, lname_in)
            SELECT 
                * 
            FROM 
                users 
            WHERE 
                fname = ?
            AND 
                lname = ?
        SQL
    end

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
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