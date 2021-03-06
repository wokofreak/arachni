=begin
    Copyright 2010-2013 Tasos Laskos <tasos.laskos@gmail.com>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
=end

module Arachni
module Support::Buffer

#
# A buffer implementation which flushes itself when it gets full or a number
# of push attempts is reached between flushes.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>
#
class AutoFlush < Base

    attr_reader :max_pushes

    # @param    [Integer]  max_size
    #   Maximum buffer size -- a flush will be triggered when that limit is
    #   reached.
    # @param    [Integer]  max_pushes
    #   Maximum number of pushes between flushes.
    # @param    [#<<, #|, #clear, #size, #empty?]   type
    #   Internal storage class to use.
    def initialize( max_size = nil, max_pushes = nil, type = Array )
        super( max_size, type )

        @max_pushes = max_pushes
        @pushes     = 0
    end

    def <<( *args )
        super( *args )
    ensure
        handle_push
    end

    def batch_push( *args )
        super( *args )
    ensure
        handle_push
    end

    def flush
        super
    ensure
        @pushes = 0
    end

    private

    def handle_push
        @pushes += 1
        flush if flush?
    end

    def flush?
        !!(full? || push_limit_reached?)
    end

    def push_limit_reached?
        max_pushes && @pushes >= max_pushes
    end

end
end
end
