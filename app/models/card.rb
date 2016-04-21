class Card < ActiveRecord::Base
  belongs_to :card_set
  validates_presence_of :name, :multiverse_id, :type, :card_set_id
  validates :multiverse_id, uniqueness: true

  include PgSearch

  pg_search_scope :named, against: :name
  pg_search_scope :containing, against: :text

  scope :cost_under, -> (amount) { where("converted_cost < ?", amount) }
  scope :cost_over,  -> (amount) { where("converted_cost > ?", amount) }
  scope :cost_is,    -> (amount) { where("converted_cost = ?", amount) }

  ## TODO: Add Scopes for Card Type, Colors and use them in SearchController!
  ## The of_type scope should support multiple types!
  ## I.e. [Artifact, Creature] should find Cards where card_type contains
  ## artifact *or* creature.
  scope :of_type,    -> (name)   { where("card_type ILIKE ?", "%#{name}%") }

  IMAGE_BASE_URI = "https://s3.amazonaws.com/images.planeswalker.io"
  BASIC_LANDS = ["Island", "Forest", "Mountain", "Plains", "Swamp"]

  def image_url
    "#{IMAGE_BASE_URI}/#{self.card_set.image_dir}/#{self.image_name}.jpg"
  end

  def image_name
    if self.name.include?(":")
      self.name.gsub(/:/, "")
    elsif BASIC_LANDS.include?(self.name)
      "#{self.name} [#{self.card_number}]"
    else
      self.name
    end
  end

  def self.import_from_json(card_data)
    match = card_data['imageName'].match(/.+(\d)$/)
    Card.new(name: card_data["name"],
             mana_cost: card_data["manaCost"],
             converted_cost: card_data["cmc"],
             card_type: card_data["type"],
             subtypes: card_data["subtypes"],
             supertypes: card_data["supertypes"],
             rarity: card_data["rarity"],
             text: card_data["text"],
             flavor: card_data["flavor"],
             artist: card_data["artist"],
             power: card_data["power"],
             toughness: card_data["toughness"],
             card_number: match ? match[1] : nil,
             colors: card_data["colors"],
             multiverse_id: card_data["multiverseid"])
  end
end
