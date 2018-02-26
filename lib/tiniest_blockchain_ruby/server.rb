require 'sinatra/base'
require 'json'
require 'date'

require "tiniest_blockchain_ruby/block"

module TiniestBlockchainRuby
  class Server < Sinatra::Application

    Me = 'asdfasdf'

    @@blockchain = []
    @@this_nodes_transactions = []

    post '/tx' do
      request.body.rewind
      new_tx = JSON.parse(request.body.read)
      @@this_nodes_transactions.push(new_tx)

      "Transaction submission successful \n" +
        "    from: #{new_tx['from']}     \n" +
        "      to: #{new_tx['to']}       \n" +
        "  amount: #{new_tx['amount']}   \n"
    end

    get '/tx' do
      @@this_nodes_transactions.to_s
    end

    get '/mine' do
      last_block = @@blockchain.last
      last_proof = last_block.data['proof_of_work']
      new_proof  = proof_of_work(last_proof)
      @@this_nodes_transactions.push({"from" => "network", "to" => Me, "amount" => 1})

      new_index         = last_block.index + 1
      new_timestamp     = Date.today.to_time
      new_previous_hash = last_block.hash
      new_data          = {
        'proof_of_work' => new_proof,
        'transactions'  => @@this_nodes_transactions
      }
      mined_block = Block.new(new_index, new_timestamp, new_data, new_previous_hash)
      @@blockchain.push(mined_block)

      @@this_nodes_transactions = []

      mined_block.to_json
    end

    get '/blocks' do
      @@blockchain.to_json
    end

    helpers do
      def proof_of_work(last_proof)
        i = last_proof
        i += 1 while !(i % 9 == 0 && i % last_proof == 0)
        i
      end
    end
  end
end
