class Beer < ActiveRecord::Base
  include RatingAverage

  validates :name, presence: true

  validates :style, presence: true

  belongs_to :style
  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |beer| -(beer.average_rating||0)}
    sorted_by_rating_in_desc_order.first(n)
  end

  def to_s
    "#{name} #{brewery.name}"
  end

  def average
    return 0 if ratings.empty?
    ratings.map{ |r| r.score}.sum / ratings.count.to_f
  end

end
