class TrackParser
  def initialize(data:)
    @data = data
  end

  def call
    @result ||= @data.each_line
                     .map { |line| parse_line(line) }
                     .compact.select { |track| track.start_with? "spotify:track:" }
  end

  def self.call(data:)
    new(data: data).call
  end

  private

  def parse_line(line)
    line.split.last
  end
end
