require 'csv'

class EventData
  attr_reader :contents

  def initialize
    @contents = CSV.open(
      File.expand_path('../event_attendees.csv', __FILE__),
      headers: true,
      header_converters: :symbol
    )
  end
end
