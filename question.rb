require_relative "requires.rb"

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

    def author
        User.find_by_id(author_id)
    end

    def replies
        Reply.find_by_user_id(author_id)
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
        data[0]
    end
    
end