class PaginationService < Service
  def self.paginate(**options)
    new(defaults.merge(options)).call
  end

  def call
    set_result(cursor_pagination)
  end

  private
  attr_accessor :klass, :limit, :sort, :order, 
                :where, :before, :after

  def self.defaults
    { klass: Review, limit: 25, sort: "-", order: "created_at" }
  end

  def set_result(cursor)
    { "page" => cursor.first, "navigation" => cursor.last }.to_json
  end

  def cursor_pagination
    query.pager(
      after: after,
      before: before,
      limit: limit,
      sort: sort.concat(order)
    )
  end

  def query
    where ? klass.send(:where, *where) : klass
  end
end
