require 'specinfra/backend/exec'
require 'net/telnet'

module Specinfra::Backend
  class Telnet < Exec
    def run_command(cmd, opt={})
      cmd = build_command(cmd)
      cmd = add_pre_command(cmd)
      ret = with_env do
        telnet_exec!(cmd)
      end
    end

    def build_command(cmd)
      cmd = super(cmd)
      if sudo?
        cmd = "#{sudo} -p '#{prompt}' #{cmd}"
      end
      cmd
    end

    private
    def prompt
      'Login: '
    end

    def with_env
      env = Specinfra.configuration.env || {}
      env[:LANG] ||= 'C'

      env.each do |key, value|
        key = key.to_s
        ENV["_SPECINFRA_#{key}"] = ENV[key];
        ENV[key] = value
      end

      yield
    ensure
      env.each do |key, value|
        key = key.to_s
        ENV[key] = ENV.delete("_SPECINFRA_#{key}");
      end
    end

    def add_pre_command(cmd)
      if Specinfra.configuration.pre_command
        pre_cmd = build_command(Specinfra.configuration.pre_command)
        "#{pre_cmd} && #{cmd}"
      else
        cmd
      end
    end

    def telnet_exec!( command )
      stdout_data = ''
      stderr_data = ''
      exit_status = nil
      exit_signal = nil
      retry_prompt = /^Login: /
      if Specinfra.configuration.telnet.nil?
        Specinfra.configuration.telnet = create_telnet
      end
      telnet = Specinfra.configuration.telnet
      unless telnet.nil?
        telnet.cmd( command )
      end
    end
 
    def create_telnet
      tel = Net::Telnet.new( "Host" => Specinfra.configuration.host )
      tel.login( 
        "Name" => Specinfra.configuration.telnet_options[:user], 
        "Password" => Specinfra.configuration.telnet_options[:pass]
      )
      tel
    rescue
      return nil
    end

    #def create_telnet
    #  opt = {}
    #  unless @prompt.nil?
    #    opt = {"Prompt" => @prompt}
    #  end
    #  @server = Net::Telnet.new( {"Host" => @address}.merge(opt) )
    #  unless @user.nil?
    #    @server.login( @user, @pass ) {|c| print c}
    #  else
    #    @pass_prompt ||= /Password[: ]*\z/n
    #    @server.waitfor @pass_prompt
    #    @server.cmd( @pass ){|c| print c}
    #  end
    #  return true
    #rescue SocketError
    #  return false
    #rescue TimeoutError
    #  return false
    #end

  end
end
