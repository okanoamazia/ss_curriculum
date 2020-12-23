#Active Record
#関連付け
#https://railsguides.jp/association_basics.html

■ 関連付け
2つの「Active Recordモデル」同士のつながりのこと

■ 関連付けをする理由
コードでの共通操作をよりシンプル且つ簡単にできるから


■ 関連付けを宣言する効果
あるモデルが他のモデルに従属している(belongs_to)と宣言すると、
2つのモデルのそれぞれのインスタンス間で「主キー - 外部キー」情報を保持しておくようにRailsに指示が伝わります。同時に、いくつかの便利なメソッドもそのモデルに追加されます。
↓
つまり
宣言を行うと、下記が自動で設定される
主キー外部キー
新メソッド


■ 関連付けの種類
Railsでサポートされている関連付けは以下の6種類です。
belongs_to
has_one
has_many
has_many :through
has_one :through
has_and_belongs_to_many

■ 主キー - 外部キー

■ belongs_to
・他方のモデルとの間に「1対1」のつながりを設定
・belongs_to関連付けで指定するモデル名は必ず単数形
（Rails は関連付けの名前から自動的にモデルのクラス名を推測するため誤った名前にするとエラーになる）

■ has_one
・他方のモデルとの間に1対1の関連付けを設定

■ belongs_to と has_one の違い
class Book < ApplicationRecord
  belongs_to :author
end
=> Bookモデルに外部キー author_id が設定される

class Supplier < ApplicationRecord
  has_one :account
end
=> Supplierモデルではなく、Accountモデルに外部キー supplier_id が設定される
（つまり、has_oneしたモデルではなく、対になるモデルがhas_oneしたモデルに従属しているような形になる）

↓
基本的に、2つのモデルの間に1対1の関係を作りたいのであれば、
いずれか一方のモデルにbelongs_toを追加し、もう一方のモデルにhas_oneを追加する
区別の決め手となるのは外部キーをどちらに置くか（外部キーはbelongs_toを追加した方のモデルのテーブルに追加される）
あとは、has_oneというリレーションは、主語となるものが目的語となるものを「所有している」ということを意味するので、
それに合う形にする

■ has_many
・他のモデルとの間に「1対多」のつながりがあることを示す
・has_many関連付けを宣言する場合、相手のモデル名は「複数形」にする
・has_many関連付けが使われている場合、「反対側」のモデルでは多くの場合belongs_toが使われる

■ has_many :through
・他方のモデルと「多対多」のつながりを設定する場合によく使われる
・2つのモデルの間に「第3のモデル」(joinモデル)が介在する点が特徴

■ has_one :through
・他方のモデルに対して「1対1」のつながりを設定
・2つのモデルの間に「第3のモデル」(joinモデル)が介在する点が特徴


■ has_and_belongs_to_many
・他方のモデルと「多対多」のつながりを作成
・through:を指定した場合と異なり、第3のモデル(joinモデル)が介在しない

■ has_many :through と has_and_belongs_to_many の使い分け
・has_many :through
リレーションシップのモデルそれ自体を独立したエンティティとして扱いたい場合
(両モデルの関係そのものについて処理を行いたい)
・has_and_belongs_to_many
リレーションシップのモデルで何か特別なことをする必要がまったくない場合
(ただし、こちらの場合はjoinモデルが不要な代わりに、専用のjoinテーブルを別途データベースに作成しておく必要がありますので、お忘れなきよう)。

■ ポリモーフィック関連付け
ある1つのモデルが他の複数のモデルに属していることを、1つの関連付けだけで表現できる
