# frozen_string_literal: true

module Services
  # Base class for building response hashes based on external API data.
  class ResponseBuilder
    # Builds a response hash using the provided data.
    #
    # This method is intended to be overridden by subclasses to implement
    # specific logic for building response hashes.
    #
    # @param data [Object] Data object containing information to build the response.
    # @raise [NotImplementedError] Subclasses must implement the build method.
    # @return [Hash] Hash containing relevant information based on the provided data.
    def build(data)
      raise NotImplementedError, 'Subclasses must implement the build method'
    end
  end
end
