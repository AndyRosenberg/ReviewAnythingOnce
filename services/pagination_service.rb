class PaginationService < Service
  def self.paginate(**options)
    new(defaults.merge(options)).call
  end

  def call
    { "page" => page, "navigation" => navigation }.to_json
  end

  private
  attr_accessor :klass, :limit, :sort, :order, 
                :where, :cursor

  def self.defaults
    { klass: Review, limit: 25, sort: "DESC", order: "created_at" }
  end

  def page
    @page ||= query.where("id #{direction} ?", cursor?).limit(limit).order("#{order} #{sort}")
  end

  def query
    where ? klass.send(:where, *where) : klass
  end

  def cursor?
    cursor || start
  end

  def start
    ascending? ? 0 : klass.last.id + 1
  end

  def direction
    ascending? ? ">" : "<"
  end

  def ascending?
    sort == "ASC"
  end

  def navigation
    { "prev_cursor" => page.first&.id, "next_cursor" => page.last&.id }
  end
end
