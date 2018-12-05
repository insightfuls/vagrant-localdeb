begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant local .deb plugin must be run within Vagrant."
end

module VagrantPlugins
  module LocalDeb
    class Plugin < Vagrant.plugin("2")

      name "LocalDeb"

      description <<-DESC
      Overrides Debian capabilities to use a .deb files instead
      of apt-get to install rsync and an NFS client.
      DESC

      guest_capability "debian", "rsync_install" do
        require_relative "capabilities"
        Capabilities
      end

      guest_capability "debian", "nfs_client_install" do
        require_relative "capabilities"
        Capabilities
      end

    end
  end
end
