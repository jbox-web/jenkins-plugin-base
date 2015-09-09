class String

  def constantize
    ActiveSupport::Inflector.constantize(self)
  end

end
