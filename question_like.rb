require_relative "requires.rb"
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