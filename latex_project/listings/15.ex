iex(1)> %{} = %{:a => 1, 2 => :b}
%{:a => 1, 2 => :b}
iex(2)>%{:a => a} = %{:a => 1, 2 => :b}
%{2 => :b, :a => 1}
iex(3)>a
1
iex(4)>%{:c => c} = %{:a => 1, 2 => :b}
** (MatchError) no match of right hand side value: %{1 => :b, :a => 1}
    (stdlib) erl_eval.erl:453: :erl_eval.expr/5
    (iex) lib/iex/evaluator.ex:257: IEx.Evaluator.handle_eval/5
    (iex) lib/iex/evaluator.ex:237: IEx.Evaluator.do_eval/3
    (iex) lib/iex/evaluator.ex:215: IEx.Evaluator.eval/3
    (iex) lib/iex/evaluator.ex:103: IEx.Evaluator.loop/1
    (iex) lib/iex/evaluator.ex:27: IEx.Evaluator.init/4
