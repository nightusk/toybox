set default-list

dot_git := `git rev-parse --git-common-dir --path-format=absolute`

@_install-git-hooks:
    mise exec -- just _install-git-hook commit-msg
    mise exec -- just _install-git-hook pre-commit

@_install-git-hook hook:
    printf "%s\n" "#!/bin/sh" "mise exec -- just _run-git-hook \$(basename \$0) \"\$@\"" > {{ dot_git }}/hooks/{{ hook }}
    echo "{{ dot_git }}/hooks/{{ hook }}"
    cat "{{ dot_git }}/hooks/{{ hook }}"
    chmod +x "{{ dot_git }}/hooks/{{ hook }}"

@_run-git-hook hook *args:
    mise exec -- just _run-git-{{ hook }}-hook {{ args }}

@_run-git-commit-msg-hook file:
    mise exec -- committed --commit-file {{ file }}

@_run-git-pre-commit-hook *args:
    mise exec -- biome check --staged --files-ignore-unknown=true --no-errors-on-unmatched
