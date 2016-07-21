defmodule MyappUserGroupServerTest do
  use ExUnit.Case, async: false

  setup do
    {:ok, server_pid} = UserGroupServer.start_link
    {:ok, server_pid: server_pid}
  end

  test "add users", context do
    c1 = UserGroupServer.update_user_groups_state(context[:server_pid], {[:a, :b, :c], 1})
    assert(1 == c1)
    c2 = UserGroupServer.update_user_groups_state(context[:server_pid], {[:c, :d], 2})
    assert(2 == c2)
    c3 = UserGroupServer.update_user_groups_state(context[:server_pid], {[:x], 2})
    assert(1 == c3)
    c4 = UserGroupServer.update_user_groups_state(context[:server_pid], {[:d], 1})
    assert(1 == c4)
    c5 = UserGroupServer.update_user_groups_state(context[:server_pid], {[:d, :c], 2})
    assert(2 == c5)
  end
end
