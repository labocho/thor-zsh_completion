#compdef generator_spec

local state

_generator_spec() {
  __generator_spec
}

__generator_spec() {
  readonly local DEPTH=2

  case $CURRENT in
    $DEPTH)
      _arguments \
        '*: :->subcommands'

      case $state in
        subcommands)
          _values \
            'subcommand' \
            'foo[Description of foo]' \
            'nest1[Description of nest1]' \
            ;
          ;;
      esac
      ;;
    *)
      case $words[$DEPTH] in
        foo)
          __generator_spec_foo
          ;;
        nest1)
          __generator_spec_nest1
          ;;
        *)
          # if does not match any subcommand
          # complete rest arguments
          _files
          ;;
      esac
      ;;
  esac
}


__generator_spec_foo() {
  _arguments \
    {--global}"[Global option]" \
    '*: :->rest'

  case $state in
    rest)
      # complete rest arguments
      _files
      ;;
  esac
}

__generator_spec_nest1() {
  readonly local DEPTH=3

  case $CURRENT in
    $DEPTH)
      _arguments \
        {--global}"[Global option]" \
        '*: :->subcommands'

      case $state in
        subcommands)
          _values \
            'subcommand' \
            'bar[Description of bar]' \
            'nest2[Description of nest2]' \
            'help[Describe subcommands or one specific subcommand]' \
            ;
          ;;
      esac
      ;;
    *)
      case $words[$DEPTH] in
        bar)
          __generator_spec_nest1_bar
          ;;
        nest2)
          __generator_spec_nest1_nest2
          ;;
        help)
          __generator_spec_nest1_help
          ;;
        *)
          # if does not match any subcommand
          # complete rest arguments
          _files
          ;;
      esac
      ;;
  esac
}


__generator_spec_nest1_bar() {
  _arguments \
    '*: :->rest'

  case $state in
    rest)
      # complete rest arguments
      _files
      ;;
  esac
}

__generator_spec_nest1_nest2() {
  readonly local DEPTH=4

  case $CURRENT in
    $DEPTH)
      _arguments \
        '*: :->subcommands'

      case $state in
        subcommands)
          _values \
            'subcommand' \
            'baz[Description of baz]' \
            'help[Describe subcommands or one specific subcommand]' \
            ;
          ;;
      esac
      ;;
    *)
      case $words[$DEPTH] in
        baz)
          __generator_spec_nest1_nest2_baz
          ;;
        help)
          __generator_spec_nest1_nest2_help
          ;;
        *)
          # if does not match any subcommand
          # complete rest arguments
          _files
          ;;
      esac
      ;;
  esac
}


__generator_spec_nest1_nest2_baz() {
  _arguments \
    '*: :->rest'

  case $state in
    rest)
      # complete rest arguments
      _files
      ;;
  esac
}

__generator_spec_nest1_nest2_help() {
  _arguments \
    '*: :->rest'

  case $state in
    rest)
      # complete rest arguments
      _files
      ;;
  esac
}

__generator_spec_nest1_help() {
  _arguments \
    '*: :->rest'

  case $state in
    rest)
      # complete rest arguments
      _files
      ;;
  esac
}


compdef _generator_spec generator_spec
