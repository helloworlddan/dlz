# Module to standardize formats for CLI communication.
module Interface
  PROMPT = 'DLZ>'.freeze
  def self.print(message: 'something happened.', level: :info)
    puts "#{PROMPT} #{level.to_s.upcase}: #{message.downcase}"
  end

  def self.info(message: 'something informative happened.')
    print(message: message, level: :info)
  end

  def self.warn(message: 'something almost terrible happened.')
    print(message: message, level: :warn)
  end

  def self.error(message: 'something terrible happened.')
    print(message: message, level: :error)
  end

  def self.panic(message: 'something really fucked up happened.')
    print(message: message, level: :error)
    exit(-1)
  end
end
