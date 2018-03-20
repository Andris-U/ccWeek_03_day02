require('pg')
require('pry')

class Bounty
  attr_accessor :name, :species, :danger_level, :collected_by
  attr_reader :id

  def initialize options
    @name = options['name']
    @species = options['species']
    @danger_level = options['danger_level']
    @collected_by = options['collected_by']
    @id = options['id']
  end

  def save
    db = PG.connect({ dbname: 'bounties', host: 'localhost' })

    sql = "
      INSERT INTO bounties (name, species, danger_level, collected_by)
        VALUES ($1, $2, $3, $4);
    "
    values = [@name, @species, @danger_level, @collected_by]

    db.prepare("save_it", sql)
    db.exec_prepared("save_it", values)
    db.close
  end

  def update
    db = PG.connect({ dbname: 'bounties', host: 'localhost' })

    sql = "
      UPDATE bounties
      SET (name, species, danger_level, collected_by) = ($1, $2, $3, $4)
      WHERE id = $5;
      "
    values = [@name, @species, @danger_level, @collected_by, @id]
    db.prepare("update_it", sql)
    db.exec_prepared("update_it", values)
    db.close
  end

  def delete
    db = PG.connect({ dbname: 'bounties', host: 'localhost' })
    sql = "
      DELETE FROM bounties
      WHERE id = $1;
    "
    values = [@id]
    db.prepare("delete", sql)
    db.exec_prepared("delete", values)
    db.close
  end

  def Bounty.all
      db = PG.connect({ dbname: 'bounties', host: 'localhost' })
      sql = "SELECT * FROM bounties"
      db.prepare("get_all", sql)
      bounties = db.exec_prepared("get_all")
      db.close

      bounty_objs = bounties.map do |bounty|
        Bounty.new(bounty)
      end
  end

  def Bounty.find_by_name name
    db = PG.connect({ dbname: 'bounties', host: 'localhost' })
    sql = "
      SELECT *
      FROM bounties
      WHERE name = $1
    "
    values = [name]
    db.prepare("find_by_name", sql)
    bounty = db.exec_prepared("find_by_name", values).first
    # binding.pry
    db.close

    return Bounty.new(bounty)
  end

  def Bounty.find_by_id id
    db = PG.connect({ dbname: 'bounties', host: 'localhost' })
    sql = "
      SELECT *
      FROM bounties
      WHERE id = $1
    "
    values = [id]
    db.prepare("find_by_id", sql)
    bounty = db.exec_prepared("find_by_id", values).first
    db.close

    return Bounty.new(bounty)
  end

  def Bounty.delete_all
    db = PG.connect({ dbname:'bounties', host: 'localhost' })
    sql = "DELETE FROM bounties"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close
  end
end
