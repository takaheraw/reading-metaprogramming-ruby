TryOver3 = Module.new
# Q1
# 以下要件を満たすクラス TryOver3::A1 を作成してください。
# - run_test というインスタンスメソッドを持ち、それはnilを返す
# - `test_` から始まるインスタンスメソッドが実行された場合、このクラスは `run_test` メソッドを実行する
# - `test_` メソッドがこのクラスに実装されていなくても `test_` から始まるメッセージに応答することができる
# - TryOver3::A1 には `test_` から始まるインスタンスメソッドが定義されていない
class TryOver3::A1
  def run_test
    nil
  end

  def method_missing(method_name, *args)
    if method_name.to_s.start_with?('test_')
      run_test
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('test_') || super
  end
end

# Q2
# 以下要件を満たす TryOver3::A2Proxy クラスを作成してください。
# - TryOver3::A2Proxy は initialize に TryOver3::A2 のインスタンスを受け取り、それを @source に代入する
# - TryOver3::A2Proxy は、@sourceに定義されているメソッドが自分自身に定義されているように振る舞う
class TryOver3::A2
  def initialize(name, value)
    instance_variable_set("@#{name}", value)
    self.class.attr_accessor name.to_sym unless respond_to? name.to_sym
  end
end

class TryOver3::A2Proxy
  def initialize(source)
    @source = source
  end

  def method_missing(method_name, *args, &block)
    if @source.respond_to?(method_name)
      @source.send(method_name, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @source.respond_to?(method_name) || super
  end
end

# Q3.
# 02_define.rbのQ3ではOriginalAccessor の my_attr_accessor で定義した getter/setter に
# boolean の値が入っている場合には #{name}? が定義されるようなモジュールを実装しました。
# 今回は、そのモジュールに boolean 以外が入っている場合には #{name}? メソッドが存在しないようにする変更を加えてください。
# （以下のコードに変更を加えてください）
#
module TryOver3::OriginalAccessor2
  def self.included(mod)
    mod.define_singleton_method :my_attr_accessor do |name|
      define_method name do
        @attr
      end

      define_method "#{name}=" do |value|
        if [true, false].include?(value)
          @attr = value
          unless respond_to?("#{name}?")
            self.class.define_method "#{name}?" do
              @attr == true
            end
          end
        else
          @attr = value
        end
      end
    end
  end
end

# Q4
# 以下のように実行できる TryOver3::A4 クラスを作成してください。
# TryOver3::A4.runners = [:Hoge]
# TryOver3::A4::Hoge.run
# # => "run Hoge"
# このとき、TryOver3::A4::Hogeという定数は定義されません。
module TryOver3
  class A4
    def self.runners=(runner_list)
      runner_list.each do |runner|
        runner_class = Class.new(Runner) do
          @name = runner.to_s
        end
        const_set(runner, runner_class)
      end
    end

    class Runner
      def self.run
        "run #{@name}"
      end
    end
  end
end
