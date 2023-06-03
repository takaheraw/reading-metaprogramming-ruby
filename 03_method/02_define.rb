# Q1.
# 次の動作をする A1 class を実装する
# - "//" を返す "//"メソッドが存在すること
class A1
  def initialize
  end

  define_method :"//" do
    "//"
  end
end

# Q2.
# 次の動作をする A2 class を実装する
# - 1. "SmartHR Dev Team"と返すdev_teamメソッドが存在すること
# - 2. initializeに渡した配列に含まれる値に対して、"hoge_" をprefixを付与したメソッドが存在すること
# - 2で定義するメソッドは下記とする
#   - 受け取った引数の回数分、メソッド名を繰り返した文字列を返すこと
#   - 引数がnilの場合は、dev_teamメソッドを呼ぶこと
# - また、2で定義するメソッドは以下を満たすものとする
#   - メソッドが定義されるのは同時に生成されるオブジェクトのみで、別のA2インスタンスには（同じ値を含む配列を生成時に渡さない限り）定義されない
class A2
  def initialize(array)
    array.each do |item|
      define_singleton_method("hoge_#{item}") do |count|
        if count.nil?
          dev_team
        else
          method_name = "hoge_#{item}"
          method_name * count
        end
      end
    end
  end

  def dev_team
    'SmartHR Dev Team'
  end
end

# Q3.
# 次の動作をする OriginalAccessor モジュール を実装する
# - OriginalAccessorモジュールはincludeされたときのみ、my_attr_accessorメソッドを定義すること
# - my_attr_accessorはgetter/setterに加えて、boolean値を代入した際のみ真偽値判定を行うaccessorと同名の?メソッドができること
module OriginalAccessor
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def my_attr_accessor(attr_name)
      define_method(attr_name) do
        instance_variable_get("@#{attr_name}")
      end

      define_method("#{attr_name}=") do |value|
        instance_variable_set("@#{attr_name}", value)
      end

      define_method("#{attr_name}?") do
        !!send(attr_name)
      end
    end
  end
end
