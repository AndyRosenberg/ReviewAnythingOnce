class Service
  def initialize(**kwargs)
    kwargs.each { |k, v| self.send("#{k}=", v) }
  end
end
