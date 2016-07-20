defmodule Myapp.Group.GroupServer do
  use GenServer
  require IEx

  ##Client API

  def create_group(gr) do
    case GenServer.whereis(ref(gr)) do
      nil -> Supervisor.start_child(Myapp.Group.ServerSupervisor, [gr])
      _group -> {:error, :group_already_exists}
    end
  end

  def start_link(group_name) do
    GenServer.start_link(__MODULE__, [], name: ref(group_name))
  end

  def add_user(group_name, user_id) do
    try_cast group_name, {:add_user, user_id}
  end

  def users_count_in_gorup(group_name) do
    try_call group_name, :users_count_in_gorup
  end

  def unique_users_count_in_groups(groups) do
    users = Enum.map(groups, fn(group_name) ->
      try_call group_name, :users_in_gorups
    end)
    Enum.count(Enum.uniq(List.flatten(users)))
  end

  # def user_gorups(user_id) do
  # end

  defp ref(group_name) do
    {:global, {:group_server, group_name}}
  end

  ## Callbacks (Server API)
  def init(group_state) do
    {:ok, group_state}
  end

  def handle_cast({:add_user, user_id}, group_state) do
    {:noreply, [user_id | group_state]}
  end

  def handle_call(:users_count_in_gorup, _, group_state) do
    {:reply, Enum.count(group_state), group_state}
  end

  def handle_call(:users_in_gorups, _, group_state) do
    {:reply, group_state, group_state}
  end

  defp try_call(group_name, call_function) do
    case GenServer.whereis(ref(group_name)) do
      nil ->
        {:error, :invalid_group}
      group_pid ->
        GenServer.call(group_pid, call_function)
    end
  end

  defp try_cast(group_name, call_function) do
    case GenServer.whereis(ref(group_name)) do
      nil -> {:error, :invalid_group}
      group_pid -> GenServer.cast(group_pid, call_function)
    end
  end
end
