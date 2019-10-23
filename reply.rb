require_relative "requires.rb"

class Reply
    attr_accessor :id, :question_id, :user_id, :body

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map { |datum| self.new(datum) }        
    end

    def self.find_by_user_id(user_id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE user_id = #{user_id}")
    end

    def self.find_by_question_id(question_id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE question_id = #{question_id}")        
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

    def author
        User.find_by_id(user_id)
    end

    def question
        Question.find_by_id(id)
    end

    def find_by_id
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE id = #{self.id}")
        data[0]
    end

end