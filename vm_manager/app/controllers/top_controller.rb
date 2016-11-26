class TopController < ApplicationController

before_filter :authenticate_user!

  def index
  @records = Vm.where(user_id:current_user.id).all
  end
  
  def create
  end

  def create_vm
#id1から順に検索して、nameがNULLのレコードが見つかり且つid1から5までのcpuカラムと新しく入力されるcpuの値を足し合わせて、物理サーバーの上限cpuを超えない場合
Vm.create(vmname: params[:vmname],cpu: params[:cpu],ram: params[:ram],status: "initialize",user_id:current_user.id)
#ip_record = IpPool.where(use_vm_id:nil).first
#newest_vm_id = Vm.order("id desc").first.id
#ip_record.use_vm_id = newest_vm_id
#ip_record.save
#secret_key_record = Sshkey.where(email:current_user.email,use_vm_id:nil).first
#secret_key_record.use_vm_id = newest_vm_id
#secret_key_record.save
#%x(sudo sh /home/a-tanaka/top/vm_training/vm_manager/app/controllers/initializing.sh tanakatanaka 10 10 10.100.10.10)
%x(sudo sh /home/a-tanaka/top/vm_training/vm_manager/app/controllers/initializing.sh #{params[:vmname]} 1 1 192.168.1.104 -----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAsaXRg+ARVZhwnD0NY34DWggL8Aeq0P5R9j9vqdf0NxSXodos
Rkxj92cOfexEfUTTgk2RH+Et0oxFqZkEOkJZsLyp9f+inFSfPAvqjazVtJasQvsK
5PBZrNJFUOeLVSWOlYe9S+AupIVkoz1XAm1MNy79372RHbjFynlacYzPYfxkcLae
61FAqpRoKxbdV6VEMGD14hTcGLZfX0BYcp2bEDXksYFYDRR2HMd/raWjq5OoI0dq
24lcpU9wHuSCyCwjcOOqMXicyXIWQk6fBfqcFRXHanC7kUekOoq2WgD3ODNwtOgC
Z+w/1xC5Q79yiccqyCQ0KfEs12ti9uM7eohYlwIDAQABAoIBAG50yNHzhzOuhg5P
U7zSBGl9aVbEnaw3BWVUSizTztBUqHeFfVP0eY/B71vShT9ShSSW8C5fR6uLdmEe
eGd1C+l9VTxUx5nmb9/ZFO0kUvhnWxKGn158J3XyhBDq91Jo+L/213ePG9FF864g
HLKwnNwPBuGQL+PIGIttaxQBVoz4ZHSneaCkuFCZVfR/WvgvcT69LShlTbqffefT
qti8BDMxSsisaNVQSOUbYPJYf2P9wn/yViQ21yVEQnUA1XQpGkiPqOHDLohPakCi
2PUYdZcQX9eDCwfuF6HZDBrMQ/8H4dPBT04CVk4lEYHl9M7aL07mB2gtt9baZPMx
qahNp8kCgYEA6ddHko3bdiRLyMMiyX0A/N09ptL57ckqhB4AfHYc0oW+Zqt5XDAC
XOh4CovbRgf6D7XTx8oksH6js8E9lw+w+si+meuXnxZkrYtVqahlhxtd+A1EaJIU
rG+wZJKebUQt3x1Cw5Gel2KaKNDvnQ0uNDpcMbkdsW7B2RKFsdqtVuUCgYEAwnta
sRGsfe2Px47FK6X0ihR7NL0Ua+1R96sCaeCULWv4FgtdG077VHHOhJtwerksNC6F
tfY6elTMuE5G+t4Qod1TSVII63vX4tS7PjqP1PR0H9qzpjAmhnvsWAZE3/aSul+b
H8tBQs2jkSb+TnE2wzHrIEMFRqVeBQQxu0sCncsCgYAA66oKd6h/hJEPz0TZyjYw
yKYve/Ej8IDMWFnkI4rlgUVInjAyHrZDq16dnANW+T0QxsR4quEOGNGIKaCWcade
tV+at4S3SZ1H2Z6Stmj/6SmrilHUn46ZRy9IlhMtlvEfSbwzjOU071xwALKQybZ+
2iP2xiXJxwfYVOxV0OiRyQKBgQC/wHIeDef9zYIq5zi+nYUrs5/60sbU1wwvXrwl
ell/I2pbCd9GMqyZiRBvLPdM+VB9LrWFQH5N6VhkDEHtzY+mmJsquqiyzcuBCfCI
HaN8+32XfsIMhIMnq/3OmHfGPs5S1jsTsQrqe+jfEAxDeVreQFSs3YfRLPEzjvwd
x4qP2wKBgGXgqJ6UuRrNUFGMGjcenJ1OJuEHuG3AIHIYb6BRAVegpuSKtDE35j6d
cdRvqS59gZCgWoeaO+oCfrVsFrtSy5R36IbGlipVHkvYOWxzCqizXq7vxMxznyEZ
TYJGTjEXhaP9XiMAopy1JiL6pQJpJv/T8p1cpX9H4WZUAWDleTDm
-----END RSA PRIVATE KEY-----)
#%x(sudo sh /home/a-tanaka/top/vm_training/vm_manager/app/controllers/initializing.sh #{params[:vmname]} #{params[:cpu]} #{params[:ram]} #{ip_record.ip})
  redirect_to action: 'index'
  end

  def destroy
  end

  def destroy_vm
#vmnameとparams[:vmname]}が同じ値だった場合に実行
 if Vm.find_by(vmname: params[:vmname],user_id:current_user.id)
 destroy_vm = Vm.find_by(vmname: params[:vmname])
 destroy_vm.status ="terminating"
 destroy_vm.save
 redirect_to action: 'index'
#%x(sudo sh app/controllers/destroying.sh #{params[:vmname]})
 end

  end

  def starting
  end

  def starting_vm
 if Vm.find_by(vmname: params[:vmname],user_id:current_user.id)
 starting_vm = Vm.find_by(vmname: params[:vmname])
 starting_vm.status ="starting"
 starting_vm.save
 redirect_to action: 'index'
 # p 'pwd'
 # %x(sh app/controllers/starting.sh params[:vmname])
 end
  end

  def sshkey
  end

  def create_sshkey
    key = {}
    filename = 'file' + Time.now.to_i.to_s
    path = '/tmp/'
    cmd = "ssh-keygen -q -t rsa -N '' -f '#{path}#{filename}' >/dev/null && openssl rsa -in #{path}#{filename} -outform pem > #{path}#{filename}.pem "

    system(cmd)
    result = ''
    f = open("#{path}#{filename}.pub", 'r')
    f.each do |line|
      result += line
    end
    
    f.close
    key[:result] = result
    key[:name] = filename
    key

   @a = `cat #{path}#{filename}.pem`
    Sshkey.create(secret_key: @a)
  end
end
