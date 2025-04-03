if status is-interactive
    # Commands to run in interactive sessions can go here
end
uv generate-shell-completion fish | source
uvx --generate-shell-completion fish | source
