class Specinfra::Command::Base::Runmqsc < Specinfra::Command::Base
  class << self
    def get_status(str)
      cmd  = ""
      cmd += "echo dis \" #{str} ALL\" | #{property['bin']}/runmqsc #{property['qmgr']}"
    end
  end
end

