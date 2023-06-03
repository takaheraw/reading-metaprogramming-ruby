# Q1.
# Hogeクラスは次の仕様を持つ
# "hoge" という文字列の定数Hogeを持つ
# "hoge" という文字列を返すhogehogeメソッドを持つ
# HogeクラスのスーパークラスはStringである
# 自身が"hoge"という文字列である時（HogeクラスはStringがスーパークラスなので、当然自身は文字列である）、trueを返すhoge?メソッドが定義されている

class Hoge < String
  HOGE = "hoge"

  def hogehoge
    "hoge"
  end

  def hoge?
    self == "hoge"
  end
end

# Q2.
# 次に挙げるクラスのいかなるインスタンスからも、hogeメソッドが呼び出せるようにする
# それらのhogeメソッドは、全て"hoge"という文字列を返す
# - String
# - Integer
# - Numeric
# - Class
# - Hash
# - TrueClass

class String
  def hoge
    "hoge"
  end
end

class Integer
  def hoge
    "hoge"
  end
end

class Numeric
  def hoge
    "hoge"
  end
end

class Class
  def hoge
    "hoge"
  end
end

class Hash
  def hoge
    "hoge"
  end
end

class TrueClass
  def hoge
    "hoge"
  end
end
