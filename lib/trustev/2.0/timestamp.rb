module Trustev
  class Timestamp

    def initialize(timestamp=Time.now.utc)
      raise Error.new('timestamp must be an instance of Time') unless timestamp.instance_of?(Time)
      @timestamp = timestamp
    end

    def to_s
      @timestamp.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
    end
  end
end
