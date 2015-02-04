class Specinfra::Command::Base::Runmqsc < Specinfra::Command::Base
  class << self
    def runmqsc_cmd(str)
      cmd  = ""
      cmd += "echo dis \" #{str} ALL\" | #{property['bin']}/runmqsc #{property['qmgr']}"
    end
    
    alias :get_counts :runmqsc_cmd
    alias :get_status :runmqsc_cmd
  end
end

