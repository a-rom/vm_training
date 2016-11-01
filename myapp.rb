require 'sinatra'

post '/initializing' do
 #仮想マシンのためのディスク領域を作成する
 #例) mkdir /.../instances/i-xxxxxx
 #指定された仮想マシンのイメージを、 イメージサーバから、 指定のストレージへ転送する
 #転送が終わったら、 virshやqemu-kvmコマンドを⽤用いて 仮想マシンを起動する
 #Instance⽤用テーブルのステータスを ”running”にする (ここで⼀一旦終了)
end

post '/terminating' do
#qemu monitorへquitコマンドを送り込んで プロセスを終了させる
# virshをお使いの⽅方は そちらの作法に従ってください
#終了したら、インスタンスの領領域を削除する •  
#例) rm –rf /.../instances/i-xxxxxx
#DBへの記録をする
#物理サーバの領域が空いたので、それを記録する 
#•インスタンスのステータスを”terminated”にする􏰍
end

post '/starting' do 
# 空いている物理理サーバを検索索する
# DBへの記録をする
#貸し出される仮想マシンのエントリ(Instance⽤のテーブル)を作る
#物理サーバとして貸し出したリソースを記録する
#ここまで出来たらInstance⽤用のテーブルにあ るステータスを次の”initializing”に変更する
end

get '/' do
#公開鍵⼀一覧の取得
end

get '/:id' do
#指定IDの公開鍵を取得
end

post '/' do
#パラメータを⾒見見て、 公開鍵が与えられていたらそれを格納する
#公開鍵が与えられていなければ、 公開鍵と秘密鍵を⽣生成し、秘密鍵を返す
end

put '/:id' do
#指定IDの公開鍵を更新する
end

delete '/:id'
#指定IDの公開鍵を削除する
end

