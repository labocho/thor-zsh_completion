class Thor
  module ZshCompletion
    module Command
      def self.included(klass)
        klass.class_eval do
          desc "zsh-completion", "Print zsh completion script"
          option :name, aliases: [:n]
          def zsh_completion
            name = options.name || File.basename($0)
            puts ZshCompletion::Generator.new(self.class, name).generate
          end
        end
      end
    end
  end
end
