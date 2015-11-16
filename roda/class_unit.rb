module Main
  class ClassUnit < Jsonable
    attr_reader :id, :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end
  end
end