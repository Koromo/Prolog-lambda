% 変数記号
variable(a).
variable(b).
variable(c).
variable(d).
variable(e).
variable(f).
variable(g).
variable(n).
variable(m).
variable(x).
variable(y).
variable(z).

% λ項
var_term([var, X]) :- variable(X).
app_term([app, M, N]) :- term(M), term(N).
abst_term([abst, X, M]) :- variable(X), term(M).

term(M) :- var_term(M).
term(M) :- app_term(M).
term(M) :- abst_term(M).

% M[x:=N]
replace_free(A, B, M, N) :- replace_free(A, B, [], M, N).

replace_free(_, _, S, [var, X], [var, X]) :- member(X, S).
replace_free([var, X], B, _, [var, X], B).
replace_free(_, _, _, [var, X], [var, X]).

replace_free(A, B, S, [app, M, N], [app, X, Y]) :- replace_free(A, B, S, M, X), replace_free(A, B, S, N, Y).

replace_free(A, B, S, [abst, X, M], [abst, X, N]) :- S2 = [X | S], replace_free(A, B, S2, M, N).

% α変換
alpha_rule(A, B, [abst, A, M], [abst, B, N]) :- replace_free([var, A], [var, B], M, N).
alpha_rule(_, _, [abst, X, M], [abst, X, M]).

% 正規形かどうか
normalizer(M) :- var_term(M).
normalizer([app, M, N]) :- \+abst_term(M), normalizer(M), normalizer(N).
normalizer([abst, _, M]) :- normalizer(M).

% 1ステップβ簡約
beta_red1([app, [abst, X, M], N], L) :- replace_free([var, X], N, M, L).
beta_red1([app, M, N], [app, L, N]) :- beta_red1(M, L).
beta_red1([app, M, N], [app, M, L]) :- beta_red1(N, L).
beta_red1([abst, X, M], [abst, X, N]) :- beta_red1(M, N).

% 正規形までβ簡約
cbeta_red(M, M) :- normalizer(M).
cbeta_red(M, N) :- beta_red1(M, L), cbeta_red(L, N). 
