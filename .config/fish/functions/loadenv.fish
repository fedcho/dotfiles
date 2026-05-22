function loadenv
    set -l env_file .env
    if test -n "$argv[1]"
        set env_file $argv[1]
    end
    if test -f $env_file
        for line in (cat $env_file | grep -v '^#' | grep '=')
            set -gx (string split -m 1 = $line)
        end
        echo "Loaded $env_file file successfully!"
    else
        echo "No $env_file file found."
    end
end
