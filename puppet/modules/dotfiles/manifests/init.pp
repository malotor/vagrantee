class dotfiles (
) {

  notify {"Coping dot fields":}
  /*
  file { '/home/vagrant/.gitconfig':
    source       => "puppet:///modules/dotfiles/gitconfig",
  }
  file { '/home/vagrant/.bash_aliases':
    source       => "puppet:///modules/dotfiles/.bash_aliases",
  }
  file { '/home/vagrant/.bash_git':
    source       => "puppet:///modules/dotfiles/.bash_git",
  }
  file { '/home/vagrant/.vimrc':
    source       => "puppet:///modules/dotfiles/.vimrc",
  }*/
  file { "/home/vagrant":
    source  => "puppet:///modules/dotfiles/",
    recurse => true,
  }
}