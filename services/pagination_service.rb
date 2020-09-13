class PaginationService < Service
  def self.paginate(**options)
    new(defaults.merge(options)).call
  end

  def self.defaults
    { klass: Review, limit: 25, sort: "DESC", order: "created_at" }
  end

  def call
    { "page" => page, "navigation" => navigation }.to_json
  end

  private

  def page
    @page ||= query.where("id #{direction} ?", cursor?)
                .limit(limit).order("#{order} #{sort}")
  end

  def navigation
    { "prev_cursor" => page.first&.id, "next_cursor" => page.last&.id }
  end

  def query
    where ? klass.send(:where, *where) : klass
  end

  def direction
    if ascending?
      before ? "<" : ">"
    else
      before ? ">" : "<"
    end
  end

  def cursor?
    cursor || start
  end

  def start
    ascending? ? 0 : last_id
  end

  def last_id
    (klass.last&.id || 0) + 1
  end

  def ascending?
    sort == "ASC"
  end

  attr_accessor :klass, :limit, :sort, :order, :where, :before, :cursor
end
