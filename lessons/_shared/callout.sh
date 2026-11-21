# Helpers for lesson videos: draw attention to important text in the terminal.
# Run them while the recording is hidden (Hide ... Show); each erases its own command line first, so viewers see only
# the result.
#   callout "Only 5 of 13 planted bugs were caught"   -> a bold, coloured box around the message
#   note "Same coverage, different strength"          -> a quieter, dimmed aside
_erase_command_line() { printf '\033[1A\033[2K\r'; }
callout() {
  _erase_command_line
  local text=" $* "
  local line
  line=$(printf '%*s' "${#text}" '' | tr ' ' '─')
  printf '\033[1;33m┌%s┐\n│%s│\n└%s┘\033[0m\n' "$line" "$text" "$line"
}
note() {
  _erase_command_line
  printf '\033[2;37m%s\033[0m\n' "$*"
}
