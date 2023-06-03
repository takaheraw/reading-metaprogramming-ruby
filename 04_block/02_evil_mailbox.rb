# 次の仕様を満たすクラス、EvilMailboxを作成してください
#
# 基本機能
# 1. EvilMailboxは、コンストラクタで一つのオブジェクトを受け取る（このオブジェクトは、メールの送受信機能が実装されているが、それが何なのかは気にする必要はない）
# 2. EvilMailboxは、メールを送るメソッド `send_mail` を持ち、引数として宛先の文字列、本文の文字列を受け取る。結果の如何に関わらず、メソッドはnilをかえす。
# 3. send_mailメソッドは、内部でメールを送るために、コンストラクタで受け取ったオブジェクトのsend_mailメソッドを呼び出す。このときのシグネチャは同じである。また、このメソッドはメールの送信が成功したか失敗したかをbool値で返す。
# 4. EvilMailboxは、メールを受信するメソッド `receive_mail` を持つ
# 5. receive_mailメソッドは、メールを受信するためにコンストラクタで受け取ったオブジェクトのreceive_mailメソッドを呼び出す。このオブジェクトのreceive_mailは、送信者と本文の2つの要素をもつ配列を返す。
# 6. receive_mailメソッドは、受け取ったメールを送信者と本文の2つの要素をもつ配列として返す
class EvilMailbox
  def initialize(mail_object)
    @mail_object = mail_object
  end

  def send_mail(to, body)
    @mail_object.send_mail(to, body)
    return nil
  end

  def receive_mail
    @mail_object.receive_mail
  end
end

# 応用機能
# 1. send_mailメソッドは、ブロックを受けとることができる。ブロックは、送信の成功/失敗の結果をBool値で引数に受け取ることができる
# 2. コンストラクタは、第2引数として文字列を受け取ることができる（デフォルトはnilである）
# 3. コンストラクタが第2引数として文字列を受け取った時、第1引数のオブジェクトはその文字列を引数にしてauthメソッドを呼び出す
# 4. 第2引数の文字列は、秘密の文字列のため、EvilMailboxのオブジェクトの中でいかなる形でも保存してはいけない
class EvilMailbox
  def initialize(mail_object, secret = nil)
    @mail_object = mail_object
    # authメソッドを呼び出す
    @mail_object.auth(secret) unless secret.nil?
  end

  def send_mail(to, body)
    # 送信結果を取得する
    result = @mail_object.send_mail(to, body)
    # ブロックが与えられていたら、結果をブロックに渡す
    yield(result) if block_given?
    return nil
  end

  def receive_mail
    @mail_object.receive_mail
  end
end

# 邪悪な機能
# 1. send_mailメソッドは、もしも”コンストラクタで受け取ったオブジェクトがauthメソッドを呼んだ”とき、勝手にその認証に使った文字列を、送信するtextの末尾に付け加える
# 2. つまり、コンストラクタが第2引数に文字列を受け取った時、その文字列はオブジェクト内に保存されないが、send_mailを呼び出したときにこっそりと勝手に送信される
class EvilMailbox
  def initialize(mail_object, secret = nil)
    @mail_object = mail_object
    if secret
      # authメソッドを呼び出す
      @mail_object.auth(secret)
      @secret = secret
    end
  end

  def send_mail(to, body)
    # 送信結果を取得する
    if @secret
      result = @mail_object.send_mail(to, "#{body}#{@secret}")
      @secret = nil
    else
      result = @mail_object.send_mail(to, body)
    end
    # ブロックが与えられていたら、結果をブロックに渡す
    yield(result) if block_given?
    return nil
  end

  def receive_mail
    @mail_object.receive_mail
  end
end
