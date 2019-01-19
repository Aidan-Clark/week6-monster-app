require "pg"

class Monster
  attr_accessor :id, :name, :class_id, :attack_element_id, :weakness_element_id, :generation

  def self.open_connection
    return PG.connect(dbname: "monster_hunter", user: "postgres", password: "Acad3my1")
  end

  def get_info table, id
    conn = Monster.open_connection
    sql = "SELECT #{table}_name FROM #{table} WHERE id = #{id}"
    value = conn.exec(sql)[0]["#{table}_name"]

    conn.close

    return value
  end

  def get_img_path
    name = self.name
    filename = name.downcase.tr(' ', '_')
    return "/images/#{filename}.png"
  end

  def self.all
    conn = self.open_connection
    sql = "SELECT id, name, class_id, attack_element_id, weakness_element_id, generation FROM monster ORDER BY id;"
    results = conn.exec(sql)

    monsters = results.map do |tuple|
      self.hydrate_data tuple
    end

    conn.close

    return monsters
  end

  def self.hydrate_data monster_data
    monster = Monster.new
    monster.id = monster_data["id"].to_i
    monster.name = monster_data["name"]
    monster.class_id = monster_data["class_id"].to_i
    monster.attack_element_id = monster_data["attack_element_id"].to_i
    monster.weakness_element_id = monster_data["weakness_element_id"].to_i
    monster.generation = monster_data["generation"].to_i

    return monster
  end

  def self.find id
    conn = self.open_connection
    sql = "SELECT id, name, class_id, attack_element_id, weakness_element_id, generation FROM monster WHERE id=#{id};"

    result = conn.exec(sql)[0]
    monster = self.hydrate_data result

    conn.close

    return monster
  end

  def save
    conn = Monster.open_connection
    if self.id == nil
      sql = "INSERT INTO monster(name, class_id, attack_element_id, weakness_element_id, generation) VALUES('#{self.name}', '#{self.class_id}', '#{self.attack_element_id}', '#{self.weakness_element_id}', #{self.generation});"
    else
      sql = "UPDATE monster SET name='#{self.name}', class_id='#{self.class_id}', attack_element_id='#{self.attack_element_id}', weakness_element_id='#{self.weakness_element_id}', generation=#{self.generation} WHERE id=#{self.id};"
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
