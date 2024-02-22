function t = logfacttable
% LOGFACTTABLE  
%
%   t = 1./(2.*n+1)./(2.^(2.*n)) for n=1:9
%
%   written ... 2024-02-23 ... UCHINO Yuki
t = dd([
   8.3333333333333329e-02
   1.2500000000000001e-02
   2.2321428571428570e-03
   4.3402777777777775e-04
   8.8778409090909093e-05
   1.8780048076923078e-05
   4.0690104166666666e-06
   8.9757582720588234e-07
   2.0077354029605262e-07
   ],[
   4.6259292692714853e-18
   -6.9388939039072288e-19
   1.2390881971262907e-19
   2.4093381610788986e-20
   -2.4640958465579647e-21
   -1.0425020889283697e-21
   5.6468863150286688e-23
   1.2456366871386770e-23
   1.1145170358609214e-23
   ],"no");
end