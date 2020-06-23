lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "thor/zsh_completion/version"

Gem::Specification.new do |spec|
  spec.name          = "thor-zsh_completion"
  spec.version       = Thor::ZshCompletion::VERSION
  spec.authors       = ["labocho"]
  spec.email         = ["labocho@penguinlab.jp"]

  spec.summary       = "Create zsh completion script for Thor subclass"
  spec.description   = "Create zsh completion script for Thor subclass"
  spec.homepage      = "https://github.com/labocho/thor-zsh_completion"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r(^exe/)) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0"
end
