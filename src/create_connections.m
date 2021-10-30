function [Pre, Post_line] = create_connections(syn_connection_type)
%% syn_connection_type
% 1 - EE
% 2 - EI
% 3 - IE

%% parameters
params = model_parameters();
if syn_connection_type == 1
    Post = zeros(params.mneuro_E, params.nneuro_E, params.N_connections_EE, 'int32');
    Post_for_one = zeros(params.mneuro_E, params.nneuro_E, 'int32');
    ties_stock = 1000 * params.N_connections_EE;
    i_max = params.mneuro_E;
    j_max = params.mneuro_E;
    lambda = params.lambda_EE;
    x_max = params.mneuro_E;
    y_max = params.nneuro_E;
    A = round(params.mneuro_E/params.mneuro_E , 0);
    n_max = params.N_connections_EE;
elseif syn_connection_type == 2
    Post = zeros(params.mneuro_I, params.nneuro_I, params.N_connections_EI, 'int32');
    Post_for_one = zeros(params.mneuro_E, params.nneuro_E, 'int32');
    ties_stock = 100 * params.N_connections_EI;
    i_max = params.mneuro_I;
    j_max = params.mneuro_I;
    lambda = params.lambda_EI;
    x_max = params.mneuro_E;
    y_max = params.nneuro_E;
    A = round(params.mneuro_E/params.mneuro_I , 0);
    n_max = params.N_connections_EI;
else
    Post = zeros(params.mneuro_E, params.nneuro_E, params.N_connections_IE, 'int32');
    Post_for_one = zeros(params.mneuro_I, params.nneuro_I, 'int32');
    ties_stock = 100 * params.N_connections_IE;
    i_max = params.mneuro_E;
    j_max = params.mneuro_E;
    lambda = params.lambda_IE;
    x_max = params.mneuro_I;
    y_max = params.nneuro_I;
    A = round(params.mneuro_I/params.mneuro_E , 1);
    n_max = params.N_connections_IE;
end

%% Indices of presynaptic and postsynaptic neurons
for i = 1 : i_max
    for j = 1 : j_max
        XY = zeros(2, ties_stock, 'int8');
        R = random('exp', lambda, 1, ties_stock);
        fi = 2 * pi * rand(1, ties_stock);
        XY(1,:) = fix(R .* cos(fi));
        XY(2,:) = fix(R .* sin(fi));
        XY1 = unique(XY', 'row','stable');
        XY = XY1';
        n1 = 1;
        for k = 1 : ties_stock
            x = A * i + XY(1, k);
            y = A * j + XY(2, k);
            if (i == x && j == y)
                p = 1;
            else p = 0;
            end
            if (x > 0 && y > 0 && x <= x_max && y <= y_max && p == 0)
                Post(i, j, n1) = sub2ind(size(Post_for_one), x, y);
                n1 = n1 + 1;
            end
            if n1 > n_max
                break
            end
        end
    end
end
Post = permute(Post, [3 1 2]);
Post_line = Post(:)';
k = 1;
for i = 1 : n_max : size(Post_line, 2)
    Pre(i : i + n_max - 1) = k;
    k = k + 1;
end
Post_line = int32(Post_line);
Pre = int32(Pre);
end