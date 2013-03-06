function list = fun_tree(A)
  % vxod A - matrisa ident,  vyxod spisok vershin
  NVer = size(A, 1);

  B = zeros(NVer);
  idx = 1:NVer;
  for e = 1:size(A, 2)
        vertex = idx(A(:,e)==1);
        B(vertex(1), vertex(2)) = 1;
        B(vertex(2), vertex(1)) = 1;
  end
 
  looked = zeros(NVer, 1); 
  root = 1;
  list = [root]; % final result
  queue = [root];
  looked(root) = 1;
  
  while ~isempty(queue)
        vertex = queue(1);
        incedent_vertecies = idx((B(:,vertex) == 1) & (looked == 0));
        for i = 1:length(incedent_vertecies)
            v = incedent_vertecies(i)
            list = [list; v];
            looked(v) = 1;
            queue = [queue; v];
        end
        queue = queue(2:end)
  end
end
