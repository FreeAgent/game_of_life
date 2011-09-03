#!/usr/bin/env ruby
# gui_gol.rb    Game of Life with wxRuby for GUI display

require 'gol.rb'  # see logic & comments in this file for more information.

begin
  require 'rubygems' 
rescue LoadError
end
require 'wx'

class GolWindow < Wx::Window
  attr_accessor :rect
  
  def initialize(parent)
    super(parent)
    # Timer for animation
    @timer = Wx::Timer.new(self,1000)
    # run every 750 milliseconds
    @timer.start(750)
    # Setup the event Handler to do the drawing on this window.
    evt_paint :on_paint
    evt_timer 1000, :animate
  end
  
  def animate()
    refresh()
  end
  
  def on_paint
    # We do our drawing now
    rect = self.get_client_size
    paint do |dc|
      gdc = Wx::GraphicsContext.create(dc)
      pen = gdc.create_pen(Wx::Pen.new(Wx::Colour.new(255,0,255,255)))
      gdc.set_pen(pen)

      $nextgen.each{|k,v| 
              gdc.draw_rectangle(220 + (k[0] *11),220 +(k[1]* 11),11,11)
      }
      $nextgen=tick!($nextgen)
    end
  end
end

class GolFrame < Wx::Frame
  def initialize()
    $nextgen=INIT

    super(nil,:title=>"Game of Life with wxRuby display",:size=>[500,400])
    @win = GolWindow.new(self)
    
  end
end

class GolApp < Wx::App
  def on_init()
    GolFrame.new.show
  end
end

GolApp.new.main_loop()
