class SwipeFile < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :brand, presence: true, inclusion: { in: %w[everclear phrendly] }

  scope :by_brand, ->(brand) { where(brand: brand) }
  scope :by_tags, ->(tags) { where("tags ILIKE ANY (ARRAY[?])", tags.map { |tag| "%#{tag}%" }) }

  def tag_list
    tags&.split(',')&.map(&:strip) || []
  end

  def tag_list=(new_tags)
    self.tags = Array(new_tags).join(', ')
  end
end
