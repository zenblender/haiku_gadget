require 'haiku_hipster'

class HaikuController < ApplicationController

  def index

    @haiku_lines = HaikuHipster.haiku

  end

  def randomize

    @lines = HaikuHipster.haiku
    respond_to do |format|
      format.js
    end

  end

  def random_line

    @line_index = params[:line]
    @line = HaikuHipster.random_line @line_index.to_i
    respond_to do |format|
      format.js
    end

  end

end