# Stack w/ OTP

それぞれ`GenEvent`, `GenServer`, `Agent`を使って実装したスタック。

## Spec

```
# スタックつくる。引数は初期状態
{:ok, pid} = Stack.start_link([])

Stack.push(pid, 1)  #=> :ok
Stack.pop(pid)      #=> 1
Stack.pop(pid)      #=> nil
```
