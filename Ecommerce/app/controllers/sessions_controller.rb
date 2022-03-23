# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :authenticate_user!, except: [:carts]
  def authenticate_user
    redirect_to '/admin'
  end

  def new; end

  def index; end

  def cart_items; end
end
