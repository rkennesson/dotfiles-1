alias gti='git'
#alias tmux='tmux -2'
alias less='less -R'
alias diff='colordiff'
alias dc='cd'
alias nethack-online='ssh nethack@nethack.alt.org ; clear'
alias tron-online='ssh sshtron.zachlatta.com ; clear'
alias glog='git log --oneline --graph --color --all --decorate'

extract() {
  local xcmd rc fsobj

  (($#)) || return
  rc=0
  for fsobj; do
    xcmd=''

    if [[ ! -r ${fsobj} ]]; then
      printf -- '%s\n' "$0: file is unreadable: '${fsobj}'" >&2
      continue
    fi

    [[ -e ./"${fsobj#/}" ]] && fsobj="./${fsobj#/}"

    case ${fsobj} in
      (*.cbt|*.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
                xcmd=(bsdtar xvf)
      ;;
      (*.7z*|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                xcmd=(7z x)
      ;;
      (*.ace|*.cba)
                xcmd=(unace x)
      ;;
      (*.cbr|*.rar)
                xcmd=(unrar x)
      ;;
      (*.cbz|*.epub|*.zip)
                xcmd=(unzip)
      ;;
      (*.cpio)
                cpio -id < "${fsobj}"
                rc=$(( rc + "${?}" ))
                continue
      ;;
      (*.cso)
                ciso 0 "${fsobj}" "${fsobj}".iso
                extract "${fsobj}".iso
                rm -rf "${fsobj:?}"
                rc=$(( rc + "${?}" ))
                continue
      ;;
      (*.arc)   xcmd=(arc e);;
      (*.bz2)   xcmd=(bunzip2);;
      (*.exe)   xcmd=(cabextract);;
      (*.gz)    xcmd=(gunzip);;
      (*.lzma)  xcmd=(unlzma);;
      (*.xz)    xcmd=(unxz);;
      (*.Z|*.z) xcmd=(uncompress);;
      (*.zpaq)  xcmd=(zpaq x);;
      (*)       printf -- '%s\n' "$0: unrecognized file extension: '${fsobj}'" >&2
                continue
      ;;
    esac

    command "${xcmd[@]}" "${fsobj}"
    rc=$(( rc + "${?}" ))
  done
  (( rc > 0 )) && return "${rc}"
  return 0
}
