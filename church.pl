% 後者関数
succ([abst, n, [abst, f, [abst, x, [app, [var, f], [app, [app, [var, n], [var, f]], [var, x]]]]]]).

% +演算
plus([abst, m, [abst, n, [app, [app, [var, m], S], [var, n]]]]) :- succ(S).

% チャーチ数での自然数
church(0, [abst, f, [abst, x, [var, x]]]).
church(Num, [abst, f, [abst, x, M]]) :- Num2 is Num - 1, church(Num2, [abst, f, [abst, x, N]]), M = [app, [var, f], N].

