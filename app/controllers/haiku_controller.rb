require 'haiku_gadget'

class HaikuController < ApplicationController

  def index

    @haiku_lines = HaikuGadget.haiku

  end

  def randomize

    @lines = HaikuGadget.haiku
    respond_to do |format|
      format.js
    end

  end

  def random_line

    @line_index = params[:line]
    @line = HaikuGadget.random_line @line_index.to_i
    respond_to do |format|
      format.js
    end

  end

end