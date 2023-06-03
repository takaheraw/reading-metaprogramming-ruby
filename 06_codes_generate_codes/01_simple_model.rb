# 次の仕様を満たす、SimpleModelモジュールを作成してください
#
# 1. include されたクラスがattr_accessorを使用すると、以下の追加動作を行う
#   1. 作成したアクセサのreaderメソッドは、通常通りの動作を行う
#   2. 作成したアクセサのwriterメソッドは、通常に加え以下の動作を行う
#     1. 何らかの方法で、writerメソッドを利用した値の書き込み履歴を記憶する
#     2. いずれかのwriterメソッド経由で更新をした履歴がある場合、 `true` を返すメソッド `changed?` を作成する
#     3. 個別のwriterメソッド経由で更新した履歴を取得できるメソッド、 `ATTR_changed?` を作成する
#       1. 例として、`attr_accessor :name, :desc`　とした時、このオブジェクトに対して `obj.name = 'hoge` という操作を行ったとする
#       2. `obj.name_changed?` は `true` を返すが、 `obj.desc_changed?` は `false` を返す
#       3. 参考として、この時 `obj.changed?` は `true` を返す
# 2. initializeメソッドはハッシュを受け取り、attr_accessorで作成したアトリビュートと同名のキーがあれば、自動でインスタンス変数に記録する
#   1. ただし、この動作をwriterメソッドの履歴に残してはいけない
# 3. 履歴がある場合、すべての操作履歴を放棄し、値も初期状態に戻す `restore!` メソッドを作成する

module SimpleModel
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor(*vars)
      @history_vars ||= []

      vars.each do |var|
        @history_vars << var
        attr_reader var

        # Define writer method with history tracking.
        define_method("#{var}=") do |value|
          instance_variable_set("@#{var}", value)
          @changes[var] = true
          @changed = true
        end
      end
    end

    def history_vars
      @history_vars
    end
  end

  def initialize(hash = {})
    @changes = {}
    @changed = false
    hash.each do |key, value|
      if self.class.history_vars.include? key
        instance_variable_set("@#{key}", value)
      end
    end
  end

  def changed?
    @changed
  end

  def method_missing(name, *args)
    method_name = name.to_s
    if method_name.end_with?('_changed?') && self.class.history_vars.include?(method_name[0...-8].to_sym)
      @changes[method_name[0...-8].to_sym] || false
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.end_with?('_changed?') && self.class.history_vars.include?(method_name.to_s[0...-8].to_sym) || super
  end

  def restore!
    self.class.history_vars.each do |var|
      instance_variable_set("@#{var}", nil)
      @changes[var] = false
    end
    @changed = false
  end
end
