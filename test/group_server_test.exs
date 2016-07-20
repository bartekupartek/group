defmodule MyappGroupServerTest do
  use ExUnit.Case, async: false
  alias Myapp.Group.{ServerSupervisor, GroupServer}

  setup do
    ServerSupervisor.start_link

    groups1 = [:a, :b, :c]

    Enum.map(groups1, fn(gr) ->
      GroupServer.create_group(gr)

      GroupServer.add_user(gr, 1)
    end)

    groups2 = [:c, :d]
    Enum.map(groups2, fn(gr) ->
      GroupServer.create_group(gr)

      GroupServer.add_user(gr, 2)
    end)

    {:ok, []}
  end

  test "users count in gorup", context do
    assert(2 == GroupServer.users_count_in_gorup(:c))
  end

  test "unique users count in groups", context do
    assert(2 == GroupServer.unique_users_count_in_groups([:c, :d]))
  end

  test "user chaned group - remove user from old groups", context do
    GroupServer.add_user(:d, 2) #should remove user 2 from :c group
    assert(1 == GroupServer.users_count_in_gorup(:c))
  end

  test "remove empty group", context do
    GroupServer.add_user(:c, 2) #should remove :d group
  end
end
