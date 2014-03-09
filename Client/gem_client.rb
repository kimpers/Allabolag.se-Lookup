require 'allabolag_client'

if __FILE__ == $0
  name = ''
  $*.each { |x| name << x + ' ' }
  name.strip!
  c = AllabolagClient.new('http://localhost:3000')
  puts c.search(name)
end