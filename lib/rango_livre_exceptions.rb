# frozen_string_literal: true

module RangoLivreExceptions
  class RangoLivreException < StandardError; end
  class BadParameters < RangoLivreException; end
  class GenericError < RangoLivreException; end
  class NotFound < RangoLivreException; end
  class UnauthorizedOperation < RangoLivreException; end
  class CreateConflict < RangoLivreException; end
  class Forbidden < RangoLivreException; end
end
