require "tiniest_blockchain_ruby/version"
require "openssl"
require "date"

module TiniestBlockchainRuby
  class Block
    def initialize(index, timestamp, data, previous_hash)
      @index         = index
      @timestamp     = timestamp
      @data          = data
      @previous_hash = previous_hash
      @hash          = hash_block
    end

    def self.create_genesis_block
      self.new(0, Date.today.to_time, "Genesis Block", "0")
    end

    def self.next_block(last_block)
      this_index         = last_block.index + 1
      this_timestamp     = Date.today.to_time
      this_data          = "Hey! I'm block #{this_index}"
      this_previous_hash = last_block.hash

      self.new(this_index, this_timestamp, this_data, this_previous_hash)
    end

    attr_reader :index, :timestamp, :data, :previous_hash, :hash

    private

    def hash_block
      OpenSSL::Digest::SHA256.hexdigest(@index.to_s + @timestamp.to_s + @data.to_s + @previous_hash.to_s)
    end
  end
end
