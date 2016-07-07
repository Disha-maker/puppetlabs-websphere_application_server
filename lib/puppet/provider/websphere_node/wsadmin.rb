require_relative '../websphere_helper'

Puppet::Type.type(:websphere_node).provide(:wsadmin, :parent => Puppet::Provider::Websphere_Helper) do

  def create
    cmd = "\"AdminTask.createUnmanagedNode('[-nodeName #{resource[:node_name]} "
    cmd += "-hostName #{resource[:hostname]} -nodeOperatingSystem "
    cmd += "#{resource[:os]}]')\""

    self.debug "Running #{cmd}"
    result = wsadmin(:command => cmd, :user => resource[:user])
    self.debug result
  end

  def exists?
    cmd = "\"print AdminTask.listNodes()\""

    self.debug "Running #{cmd}"
    result = wsadmin(:command => cmd, :user => resource[:user])
    self.debug result

    unless result =~ /^('|")?#{resource[:node_name]}$/
      return false
    end
    return true
  end

  def destroy
    cmd = "\"AdminTask.removeUnmanagedNode('[-nodeName #{resource[:node_name]}]')\""

    self.debug "Running #{cmd}"
    result = wsadmin(:command => cmd, :user => resource[:user])
    self.debug result
  end

  def flush
    # do nothing
  end

end
