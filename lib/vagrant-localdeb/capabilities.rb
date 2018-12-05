# vim: set ts=2 sw=2 et :

module VagrantPlugins
  module LocalDeb

    class Capabilities
      def self.rsync_install(machine)
        install_debs_or_apt(machine, "rsync", "rsync")
      end

      def self.nfs_client_install(machine)
        install_debs_or_apt(machine, "nfs", "nfs-common")
      end

      def self.install_debs_or_apt(machine, basename, fallback_packages)
        comms = machine.communicate
        raise NotReady.new() unless comms.wait_for_ready(60)
        debs = []
        paths = [".offline/", ".vagrant/", ""]
        while debs.count == 0 and paths.count > 0
          debs = Dir.glob(paths.pop + basename + '*.deb')
        end
        if debs.count > 0
          debs.sort!
          debs.each do |deb|
            begin
              comms.upload(deb,"/tmp/package.deb")
            rescue
              raise NoUpload.new()
            end
            raise NoDebInstall.new() unless comms.sudo("dpkg -i /tmp/package.deb") == 0
          end
        else
          comms.sudo("apt-get -yqq update")
          raise NoAptInstall.new() unless comms.sudo("apt-get -yqq install " + fallback_packages) == 0
        end
      end
      private_class_method :install_debs_or_apt
    end

    class NotReady < Vagrant::Errors::VagrantError
      error_message("VM not ready for communication")
    end

    class NoUpload < Vagrant::Errors::VagrantError
      error_message("Error uploading .deb file")
    end

    class NoDebInstall < Vagrant::Errors::VagrantError
      error_message("Error installing .deb file")
    end

    class NoAptInstall < Vagrant::Errors::VagrantError
      error_message("Error installing with apt-get (no .deb files found)")
    end

  end
end
