defmodule OauthDemo.Utils.ASCII do
  def from_int(num) when num > 26 do
    num - calc_helper(num) * 26 + 96
  end
  def from_int(num), do: num + 96
  def calc_helper(num) do
    if rem(num, 26) == 0 do
      div(num, 26) -1
    else
      div(num, 26)
    end
  end
end
