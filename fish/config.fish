if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr --add pac sudo pacman -Syu --noconfirm
    abbr --add ocr ocrmypdf --force-ocr
    abbr --add dockrun docker run -it -e "DISPLAY=unix$DISPLAY" -e "QT_X11_NO_MITSHM=1" \
            -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"

    fish_ssh_agent
end
