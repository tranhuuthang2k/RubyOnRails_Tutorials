def check(arr) 
   a = arr.shift
   arr.each do |val|
      temp = a & val
      a =temp
   end       
   p a
end

arr = [[11,2,3], [1,5,6], [7,8,5,1]]
check(arr)