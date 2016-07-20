defmodule Myapp.Group.ServerSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_child(group) do
    Supervisor.start_child(__MODULE__, [group])
  end

  def init(_) do
    supervise([worker(Myapp.Group.GroupServer, [])], strategy: :simple_one_for_one)
  end
end
