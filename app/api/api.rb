module API
  class Root < Grape::API
    # http://localhost:3000/api/
    prefix 'api'
    mount V1::Root
    # api/ver1/rootを認識させて使えるようにする
  end
end

