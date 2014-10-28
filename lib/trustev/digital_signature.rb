require 'digest'

module Trustev
  class DigitalSignature

    def initialize(digital_signature, timestamp, session_id, stage_1='')
      @digital_signature = digital_signature
      @timestamp = timestamp
      @session_id = session_id
      @stage_1 = stage_1
      @stage_1 = ".#{stage_1}" unless @stage_1.empty?
    end

    def valid?
      build_signature == @digital_signature
    end

    def invalid?
      build_signature != @digital_signature
    end

    private

    def build_signature
      sha256 = Digest::SHA256.new
      sha256 << "#{@username}.#{@private_key}.#{@timestamp}#{@stage_1}"
      stage_2 = sha256.hexdigest

      sha256 = Digest::SHA256.new
      sha256 << "#{stage_2}.#{@private_key}.#{@session_id}"
      sha256.hexdigest
    end
  end
end