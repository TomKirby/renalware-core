# Cache PDF Letters so we are not constantly regenerating the same ones - wkhtml2pdf takes around
# 2.5 seconds and a fair chunk of memory to convert html to pdf, so we want to cache generated PDFs
# for a period of time.
#
# Note that even when checking to see if the PDF exists in the cache, we *always* regenerate at
# least the HTML letter content (i.e. the letter content wrapped in a layout) as we want to make
# sure we picking up any view and layout changes (Rails fragment caching could possibly be levered
# here as it knows the MD5 of the views and layouts used, and thus might help us to avoid having
# to re-render the letter HTML each time - but I have started by taking the less `magical` route
# of rendering the entire HTML letter to get its MD5 hash, which is then used in trying to find a
# PDF file cache hit for that filename.
# Note that PDF Letters are stored in the rails cache, which is currently Filestore. If we move
# to a multi-server environment we would need to switch to Memcached or Redis, and the PDF files
# would be poked into that - using quite a lot of memory I am sure (ag 25k per PDF), so would be
# unable to keep PDFs in the cache for as long as we can in the FileStore implementation, which is
# only limited by disc space. However PDFs can be regenerated on demand so there is no need to be
# bothered about not keeping them other than as mentioned the wasted resources in creating the
# same file several times.
#
# Example usage which stores the PDF in the rails cache if not found
#
#   letter_presenter = LetterPresenterFactory.new(letter)
#   PdfLetterCache.fetch(letter_presenter) do
#     # No cache hit so render and return the PDF content which will be stored in the cache
#     Letters::PdfRenderer.call(letter)
#   end
#
require_dependency "renalware/letters"

module Renalware
  module Letters
    class PdfLetterCache
      def self.fetch(letter)
        Rails.cache.fetch(cache_key_for(letter), expires_in: 1.month) do
          yield
        end
      end

      # Note the letter must be a LetterPresenter which has a #to_html method
      def self.cache_key_for(letter)
        "#{letter.id}-#{Digest::MD5.hexdigest(letter.to_html)}"
      end
    end
  end
end