require_relative 'service'

class PaginationService < Service
  def self.paginate(klass: Review, options: {})
    new(klass: klass, options: options).call
  end

  def call
    cursor_pagination
  end

  private
  attr_accessor :klass, :options

  def cursor_pagination
    query.pager(
      after: options[:after],
      before: options[:before],
      limit: limit,
      sort: sort
    )
  end

  def query
    options[:where] ? klass.send(:where, *options[:where]) : klass
  end

  def direction
    options.fetch(:direction, "DESC")
  end

  def order
    options.fetch(:order, "created_at")
  end

  def limit
    options.fetch(:limit, 25)
  end

  def sort
    direction == "DESC" ? "-#{order}" : order
  end
end
