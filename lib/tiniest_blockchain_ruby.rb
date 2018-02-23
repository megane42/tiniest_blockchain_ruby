require "tiniest_blockchain_ruby/version"
require "openssl"

module TiniestBlockchainRuby
  class Block
    def initialize(index, timestamp, data, previous_hash)
      @index         = index
      @timestamp     = timestamp
      @data          = data
      @previous_hash = previous_hash
      @hash          = hash_block
    end

    attr_reader :index, :timestamp, :data, :previous_hash, :hash

    private

    def hash_block
      OpenSSL::Digest::SHA256.hexdigest(@index.to_s + @timestamp.to_s + @data.to_s + @previous_hash.to_s)
    end
  end
end
