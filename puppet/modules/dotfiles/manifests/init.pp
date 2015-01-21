class dotfiles (
) {

  notify {"Coping dot fields":}

  file { "/home/vagrant":
    source  => "puppet:///modules/dotfiles/",
    recurse => true,
  }
}