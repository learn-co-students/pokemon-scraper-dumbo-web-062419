class Pokemon

    attr_reader :name, :type, :db, :id

    def initialize(name:, type:, db:, id: nil)
        @id = id
        @name = name
        @type = type
        @db = db
    end

    def self.save
        sql = <<-SQL
            INSERT INTO pokemon (name, type, db)
            VALUES (?, ?, ?)
        SQL

        DB[:conn].execute(sql, self.name, self.type, self.db)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
    end

    def self.find(id)
        sql = <<-SQL
            SELECT *
            FROM pokemon
            WHERE id = ?
            LIMIT 1
        SQL

        DB[:conn].execute(sql, id).map do |row|
            self.new_from_db(row)
        end.first
    end

    def self.new_from_db(row)
        pokemon = self.new
        pokemon.id = row[0]
        pokemon.name = row[1]
        pokemon.type = row[2]
        pokemon.db = row[3]
        pokemon
    end

end
