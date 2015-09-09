module Jenkins
  module Model
    class Build

      def getNumber
        @native.getNumber()
      end

      alias_method :number, :getNumber

    end
  end
end
