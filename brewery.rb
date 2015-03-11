class Brewery < ActiveRecord::Base
  include RatingAverage

  validates :name, allow_blank: false,
            length: { minimum: 1}
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                            only_integer: true }
  validate :back_to_the_future, on: :create

  scope :active, -> { where active:true}
  scope :retired, -> { where active:[nil, false]}

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0)}
    sorted_by_rating_in_desc_order.first(n)
  end

  def back_to_the_future
    if year > Date.today.year
      errors.add(:year, "This is heavy")
    end
  end

  def print_report
    puts self.name
    puts "established at year #{self.year}"
    puts "number of beers #{self.beers.count}"
  end

  def restart
    self.year = 2015
    puts "changed year to #{year}"
  end
end
