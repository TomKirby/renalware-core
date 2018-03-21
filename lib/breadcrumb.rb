# frozen_string_literal: true

class Breadcrumb
  attr_reader :title, :anchor

  def initialize(title:, anchor:)
    @title = title
    @anchor = anchor
  end
end
