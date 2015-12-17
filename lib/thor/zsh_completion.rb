require "thor"
require "thor/zsh_completion/version"
require "erb"

class Thor
  module ZshCompletion
  end
end

require "thor/zsh_completion/command"
require "thor/zsh_completion/generator"
