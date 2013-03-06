function [list] = fun_tree(A)
% input:  A - matrix: each column is one edge, which has 1 at its vertecies
% output: [list] for Breadth-first search
% Aijan Ibraimova, 2013 March

    NVer = size(A, 1);  % Number of vertecies in graph

    B = zeros(NVer);    % prepare empty Adjacency matrix
    idx = 1:NVer;       % useful vector ;-)
    for e = 1:size(A, 2)                % take every edge
        vertecies = idx(A(:,e)==1);        % find its's vertecies
        B(vertecies(1), vertecies(2)) = 1;    % put this into 2 cells
        B(vertecies(2), vertecies(1)) = 1;  
    end

    looked = zeros(NVer, 1);    % we've added this vertcies to the list
    root = 1;                   % start vertex
    list = [root];              % final result
    queue = [root];             % start BFS from the root

    while ~isempty(queue)       % while the queue isn't empty
        vertex = queue(1);      % take it's first element
        incedent_vertecies_bool = (B(:,vertex) == 1) & (looked == 0);   % find adjacent vertecies in bool format
        list = [list, idx(incedent_vertecies_bool)];                    % add this vertecies to the list
        queue = [queue, idx(incedent_vertecies_bool)];                  % and to the queue
        queue = queue(2:end);
        looked(vertex) = 1;     % this vertex will be forgotten
    end
end
