class PizzaConfig
  CONFIG_PATH = Rails.root.join("../data/config.yml")

  def self.data
    @data ||= YAML.load_file(CONFIG_PATH)
  end

  def self.size_multipliers
    data["size_multipliers"]
  end

  def self.size_keys
    size_multipliers.keys
  end

  def self.ingredients
    data["ingredients"]
  end

  def self.ingredient_keys
    ingredients.keys
  end

  def self.promotions
    data["promotions"]
  end

  def self.discounts
    data["discounts"]
  end

  def self.reload!
    @data = nil
  end
end