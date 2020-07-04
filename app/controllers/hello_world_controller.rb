# frozen_string_literal: true

class HelloWorldController < ApplicationController
  def index
    render json: {
      message: 'Hello World'
    }
  end
end
