require "pg"

class Monster
  attr_accessor :id, :name, :class, :primary_element, :primary_weakness, :generation

  # A Class Method. Method of the Class, NOT an instance (Hash/Object) of the Class.
  def self.open_connection
    return PG.connect(dbname: "monster_hunter", user: "postgres", password: "Acad3my1")
  end


  def self.all
    conn = self.open_connection
    sql = "SELECT * FROM monster ORDER BY id;"
    results = conn.exec(sql)

    monsters = results.map do |tuple|
      self.hydrate_data tuple
    end

    conn.close

    return monsters
  end

  def self.hydrate_data monster_data
    monster = Monster.new
    monster.id = monster_data["id"]
    monster.name = monster_data["name"]
    monster.class = monster_data["class"]
    monster.primary_element = monster_data["primary_element"]
    monster.primary_weakness = monster_data["primary_weakness"]
    monster.generation = monster_data["generation"]

    return monster
  end

  def self.find id
    conn = self.open_connection
    sql = "SELECT * FROM monster WHERE id=#{id};"
    result = conn.exec(sql)[0]
    monster = self.hydrate_data result

    conn.close

    return monster
  end

  def save
    conn = Monster.open_connection
    if self.id == nil
      sql = "INSERT INTO monster(name, class, primary_element, primary_weakness, generation) VALUES('#{self.name}', '#{self.class}', '#{self.primary_element}', '#{self.primary_weakness}', #{self.generation});"
    else
      sql = "UPDATE monster SET name='#{self.name}', class='#{self.class}', primary_element='#{self.primary_element}', primary_weakness='#{self.primary_weakness}', generation=#{self.generation} WHERE id=#{self.id};"
    end
    conn.exec(sql)

    conn.close
  end

  def self.destroy id
    conn = self.open_connection
    sql = "DELETE FROM monster WHERE id=#{id}"
    conn.exec(sql)

    conn.close
  end

end
