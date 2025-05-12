function upup -d "Upgrade all the things"
    if command -sq brew
        brew update; brew upgrade; brew cleanup;
    end
    if command -sq rustup
        rustup self update; rustup update;
    end
    if command -sq mise
        mise plugins update
    end
    if functions -q fisher
        fisher update;
    end
end
