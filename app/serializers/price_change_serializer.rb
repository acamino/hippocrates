class PriceChangeSerializer < ActiveModel::Serializer
  attributes :date,
             :reason

  attribute :previous_price, key: :previousPrice
  attribute :updated_price,  key: :updatedPrice
  attribute :user_name,      key: :userName

  delegate :user, to: :object

  def previous_price
    format('%.2f', object.previous_price)
  end

  def updated_price
    format('%.2f', object.updated_price)
  end

  def user_name
    user.pretty_name.upcase
  end

  def date
    object.created_at.strftime('%b %d, %Y %I:%M %p')
  end
end
