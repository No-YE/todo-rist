# frozen_string_literal: true

class RootController < ApplicationController
  def index
    @links = Link.completed.order(id: :desc).limit(20)
  end
end
