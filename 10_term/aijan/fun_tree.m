function Spis=fun_tree(A)
% vxod A- matrisa ident,  vyxod spisok vershin

kVer=size(A,1);   % kol strok
kRebr=size(A,2);  % kol stolbsov

VerInSpis=zeros(kVer);   % Obnulili massiv
Spis=zeros(kVer);
VerInSpis(1)=1;
PorNomer=1
Spis(PorNomer)=1 


for i=1:kVer -1

  for j=1:kRebr

     if A(i,j)==1
        for i1= i+1 : kVer
          if (A(i1,j)==1) & (VerInSpis(i1)==0)
            PorNomer=PorNomer+1
            Spis(PorNomer)= i1
            VerInSpis(i1)=1

          end       


        end

     end
  end

end


return
