class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards, through: :deck_cards
  has_many :deck_cards

  validates :user_id, presence: true
  validates :title, presence: true, uniqueness: {
              scope: :user_id
            }
end
