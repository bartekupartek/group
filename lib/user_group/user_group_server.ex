defmodule UserGroupServer do
  use GenServer

  ## Client API
  def start_link(opts \\ []) do
   GenServer.start_link(__MODULE__, :ok, opts)
  end

  def update_user_groups_state(server, data) do
    {groups, user_id} = data
    GenServer.call(server, {:clean_groups, user_id}, :infinity)
    users = Enum.map(groups, fn(group) ->
      GenServer.call(server, {:add_user_group, group, user_id}, :infinity)
    end)
    Enum.count(Enum.uniq(List.flatten(users)))
  end

  def get_user_groups(server, user_id) do
    GenServer.call(server, {:get_user_groups, user_id})
  end

  def users_count_in_gorup(server, group) do
    GenServer.call(server, {:users_count_in_gorup, group})
  end

  ## Callbacks (Server API)

  def init(_) do
    {:ok, Map.new}
  end

  def handle_call({:clean_groups, user_id}, _from, user_group_dict) do
    user_group_dict = user_group_dict
    |> Enum.map(fn({gr, users}) -> {gr, List.delete(users, user_id)} end)
    |> Enum.into(%{})
    {:reply, user_group_dict, user_group_dict}
  end

  def handle_call({:add_user_group, group, user_id}, _from, user_group_dict) do
    user_group_dict = if Map.has_key?(user_group_dict, group) do
      Map.update!(user_group_dict, group, fn(users) -> [user_id | users] end)
    else
      Map.put(user_group_dict, group, [user_id])
    end
    {:reply, Map.fetch(user_group_dict, group), user_group_dict}
  end
end
