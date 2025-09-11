function fish_user_key_bindings
  # At some point bindings made in snippets just... stopped working?
  # So now they need to go in here
  if functions _atuin_search > /dev/null
      bind ctrl-r _atuin_search
      bind -M insert ctrl-r _atuin_search
  end
end
