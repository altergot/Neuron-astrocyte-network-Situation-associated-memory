function [Pre_EE, Post_EE, Pre_EI, Post_EI, Pre_IE, Post_IE] ...
    = create_connections()
params = model_parameters();

%% Zone EE
Zone_syn_relation = zeros(params.mneuro_E, params.nneuro_E, params.N_connections_EE);
Zone_syn_relation_for_one = zeros(params.mneuro_E, params.nneuro_E);
ties_stock = 1000 * params.N_connections_EE;
for i = 1 : params.mneuro_E
    for j = 1 : params.nneuro_E
        XY = zeros(2, ties_stock, 'int8');
        R = random('exp', params.lambda_EE, 1, ties_stock);
        fi = 2 * pi * rand(1, ties_stock);
        XY(1,:) = fix(R .* cos(fi));
        XY(2,:) = fix(R .* sin(fi));
        XY1 = unique(XY', 'row','stable');
        XY = XY1';
        n1 = 1;
        for k = 1 : ties_stock
            x = i + XY(1, k);
            y = j + XY(2, k);
            if (i == x && j == y)
                pp = 1;
            else pp = 0;
            end
            if (x > 0 && y > 0 && x <= params.mneuro_E && y <= params.nneuro_E && pp == 0)
                Zone_syn_relation(i, j, n1) = sub2ind(size(Zone_syn_relation_for_one), x, y);
                n1 = n1 + 1;
            end
            if n1 > params.N_connections_EE
                break
            end
        end
    end
end
Zone_syn_relation2 = permute(Zone_syn_relation, [3 1 2]);
Post_EE = Zone_syn_relation2(:)';
k = 1;
for i = 1 : params.N_connections_EE : size(Post_EE, 2)
    Pre_EE(i : i + params.N_connections_EE - 1) = k;
    k = k + 1;
end
Post_EE = int32(Post_EE);
Pre_EE = int32(Pre_EE);

%% Zone IE
Zone_syn_relation = zeros(params.mneuro_E, params.nneuro_E, params.N_connections_IE);
Zone_syn_relation_for_one = zeros(params.mneuro_I, params.nneuro_I);
ties_stock = 100 * params.N_connections_IE;
for i = 1 : params.mneuro_E
    for j = 1 : params.nneuro_E
        XY = zeros(2, ties_stock, 'int8');
        R = random('exp', params.lambda_IE, 1, ties_stock);
        fi = 2 * pi * rand(1, ties_stock);
        XY(1,:) = fix(R .* cos(fi));
        XY(2,:) = fix(R .* sin(fi));
        XY1 = unique(XY', 'row','stable');
        XY = XY1';
        n1 = 1;
        for k = 1 : ties_stock
            x = fix(i / 2) + XY(1, k);
            y = fix(j / 2) + XY(2, k);
            if (fix(i / 2) == x && fix(j / 2) == y)
                pp = 1;
            else pp = 0;
            end
            if (x > 0 && y > 0 && x <= params.mneuro_I && y <= params.nneuro_I && pp == 0)
                Zone_syn_relation(i, j, n1) = sub2ind(size(Zone_syn_relation_for_one), x, y);
                n1 = n1 + 1;
            end
            
            if n1 > params.N_connections_IE
                break
            end
        end
    end
end
Zone_syn_relation2 = permute(Zone_syn_relation, [3 1 2]);
Post_IE = Zone_syn_relation2(:)';
k = 1;
for i = 1 : params.N_connections_IE : size(Post_IE, 2)
    Pre_IE(i : i + params.N_connections_IE - 1) = k;
    k = k + 1;
end
Post_IE = int32(Post_IE);
Pre_IE = int32(Pre_IE);

%% Zone EI
Zone_syn_relation = zeros(params.mneuro_I, params.nneuro_I, params.N_connections_EI);
Zone_syn_relation_for_one = zeros(params.mneuro_E, params.nneuro_E);
ties_stock = 100 * params.N_connections_EI;
for i = 1 : params.mneuro_I
    for j = 1 : params.nneuro_I
        XY = zeros(2, ties_stock, 'int8');
        R = random('exp', params.lambda_EI, 1, ties_stock);
        fi = 2 * pi * rand(1, ties_stock);
        XY(1,:) = fix(R .* cos(fi));
        XY(2,:) = fix(R .* sin(fi));
        XY1 = unique(XY', 'row','stable');
        XY = XY1';
        n1 = 1;
        for k = 1 : ties_stock
            x = fix(2 * i) + XY(1, k);
            y = fix(2 * j) + XY(2, k);
            if (fix(2 * i) == x && fix(2 * j) == y)
                pp = 1;
            else pp = 0;
            end
            if (x > 0 && y > 0 && x <= params.mneuro_E && y <= params.nneuro_E && pp == 0)
                Zone_syn_relation(i, j, n1) = sub2ind(size(Zone_syn_relation_for_one), x, y);
                n1 = n1 + 1;
            end
            
            if n1 > params.N_connections_EI
                break
            end
        end
    end
end
Zone_syn_relation2 = permute(Zone_syn_relation, [3 1 2]);
Post_EI = Zone_syn_relation2(:)';
k = 1;
for i = 1 : params.N_connections_EI : size(Post_EI, 2)
    Pre_EI(i : i + params.N_connections_EI - 1) = k;
    k = k + 1;
end
Post_EI = int32(Post_EI);
Pre_EI = int32(Pre_EI);
end
