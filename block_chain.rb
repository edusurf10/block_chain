require 'digest'
require 'json'
require 'date'

class BlockChain
  @chain = []

  @block_chain = []

  def self.get_time
    Date.today
  end

  def self.is_valid_hash_difficulty(hash: nil, difficulty: nil)
    if hash[0,difficulty] == '0000'
      true
    else
      false
    end
  end

  def self.generate_hash(block)
    nonce = 0
    block[:nonce] = nonce
    hash = Digest::SHA256.hexdigest(block.to_json)

    while !is_valid_hash_difficulty(hash: hash, difficulty: 4)
      nonce += 1
      block[:nonce] = nonce
      hash = Digest::SHA256.hexdigest(block.to_json)
    end

    hash
  end

  def self.add_block(block)
    if @block_chain.length == 0
      block[:time_stamp] = get_time
      block[:hash] = generate_hash(block)
    else
      block[:time_stamp] = get_time
      last_block = @block_chain.last
      block[:last_hash] = last_block[:hash]
      block[:hash] = generate_hash(block)
    end
    @block_chain << block
  end

  def self.loop_for_miner
    for c in @chain do
      self.add_block(c)
    end
  end

  input_block = true
  while input_block
    payload = {}
    puts "===== Nova transação ====="
    puts "Informe o nome do pagador"
    STDOUT.flush
    payload[:from] = gets.chomp

    puts "Informe o nome do recebedor"
    STDOUT.flush
    payload[:to] = gets.chomp

    puts "Informe o valor a ser pago"
    STDOUT.flush
    payload[:value] = gets.chomp

    @chain << payload

    puts "Deseja fazer mais uma transação? (s = sim ou n = não)"
    STDOUT.flush
    if gets.chomp == 'n'
      input_block = false
      puts "Executando transações"
      loop_for_miner
      puts "Processo finalizado com sucesso."
      puts "==============================="
      puts @block_chain.to_json
      puts "==============================="
      break
    end
  end

end