require_relative "requires.rb"

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