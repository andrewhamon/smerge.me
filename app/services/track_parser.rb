class TrackParser
  def initialize(data:)
    @data = data
  end

  def call
    @result ||= @data.scan(/spotify:track:\w+/)
  end

  def self.call(data:)
    new(data: data).call
  end
end
