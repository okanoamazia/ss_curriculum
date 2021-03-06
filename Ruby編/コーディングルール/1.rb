#コーディングルール

#文字列
[SHOULD] 空文字列は '' と書くこと。

# 配列
[MUST] 代入の後ろに配列リテラルを複数行で書く場合は、[ の後ろで改行し、要素行のインデントを1レベル下げ、] は独立した行に置いて [ を書いた行の行頭にインデントを揃える。
array = [
  :foo,
  :bar,
  :baz,
]

[SHOULD] 文字列配列は%記法 %w(...) or %W(...) を用いて書くこと。
words = %w(foo bar baz)

#ハッシュ
[MUST] ハッシュリテラルを一行に書くときは、{ と第一要素のキーとの間、および最終要素の値と } との間にそれぞれ空白を一つずつ入れること。
{ hoge: 1, fuga: 2 }

[MUST] ハッシュリテラルは、Symbol (主に文字列にコロン（:）を前に置いて定義したもの)を key にするときは HashRocket (Ruby 1.8 までで使われていた => の記法{ :foo => 42 })を使わない。
# good
{ first: 42,
  second: 'foo',
}
# bad
{ :first => 42,
  :second => 'foo',
}

#演算式
[SHOULD] 演算子の両側に空白を入れること。ただし ** の両側には空白は入れないこと。

