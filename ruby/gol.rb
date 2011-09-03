#!/usr/bin/env ruby
# gol.rb    Game of Life

=begin rdoc
   To run this code, type:
   irb -r ./gol.rb

   >>  gen=tick!(INIT)

   & run this command repeatedly to see the succeeding generations.
=end

=begin rdoc
   Essential logic of game-of-life; where x is no. of live neighbours.
   (x < 2) || (x > 3): death
   x=2: life (only if previously alive) 
   x=3: life
=end

 
class Array
=begin rdoc
   Addition for coordinates, that is, 2 member arrays
=end
  def addTuple(coord)
    output = self.dup
    output[0]+=coord[0] 
    output[1]+=coord[1] 
    output
  end
end   
 

class Hash
=begin rdoc
    Create a "neighbourhood" around a live cell 
    (eight cells around it where cells will live or die in the next generation)
=end
  def creep(x,y) 
    out={}
    self.each{|k,v| out[k.addTuple(x)] = v+y }
    out 
  end

=begin rdoc
    reset the 'neighbour-count' to zero before the clock-tick for the next gen.
=end
  def zero
    self.each{|k,v| self[k] = 0 }
  end

=begin rdoc
    create rings of neighbour-counts; then merge them into one hash
=end
  def genRings!()
    rings = []
    
    self.each{|k,v| rings << HOOD.creep(k,v)  }

    rings.each{|r| self.merge!(r) {|k, v1, v2| v1 + v2 } }
  end


=begin rdoc
   kill off cells which do not meet criteria
   pass in prev as previous-generation 
=end
  def reaper!(prev)
    self.reject!{|k,v| (v!=3) && (v!=2 || !prev.has_key?(k)) }
    #self.select!{|k,v| (v==3) || (v==2 && prev.has_key?(k)) }
  end

end

=begin rdoc
   This method represents the clock-tick to produce a new generation of cells.
   input: prev is a hash representing the previous generation.
=end
  def tick!(prev)
     cells=prev.dup
     cells.genRings!
     cells.reaper!(prev)
     cells.zero
  end


=begin rdoc
  initial state: 'die hard' pattern (runs to 130 iterations before dying off)
  the key represents co-ordinates in a Cartesian plane.
  the values is a count of neighbours (calculated each tick, then reset to 0).
=end
INIT = { [1,0] => 0, [1,1] => 0, [0,1] => 0, [5,0] => 0, [6,0] => 0, [7,0] => 0, [6,2] => 0}

  
=begin rdoc
  relative co-ordinate values, to create a 'ring'/neighbourhood around a cell.
=end
HOOD = { 
  [-1, -1] => 1, 
  [-1,  0] => 1,  
  [-1, +1] => 1,  
  [ 0, +1] => 1, 
  [ 0, -1] => 1, 
  [+1, -1] => 1, 
  [+1,  0] => 1, 
  [+1, +1] => 1 
} 
