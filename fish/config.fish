if status is-interactive
    set fish_greeting ""
    # Commands to run in interactive sessions can go here
end

if status --is-login
    and test (tty) = /dev/tty1
    exec startx
end
