function [V_E, V_I, U_E, U_I, G, Isyn_EE, Isyn_EI, Isyn_IE, W_EE, W_EI, is_active, mask_E1] = ...
    step_neurons(V_E, V_I, U_E, U_I, G, t_Iapp_met,t_Iapp, array_Iapp, Isyn_EE, Isyn_EI, ...
    Isyn_IE, Post_EE, Pre_EE, Post_EI, Pre_EI, Post_IE, Pre_IE, W_EE, W_EI, is_active, ...
    Iastro_neuron, is_pre_training, i)

params = model_parameters(true);

%% Input image as rectangle function of applied current to neuronal layer
if t_Iapp_met == 0
    Iapp = zeros(params.mneuro_E, params.nneuro_E);
else
    Iapp = array_Iapp(:, :, t_Iapp_met);
end

%% Izhikevich neuron model
Iapp = Iapp(:);
Iapp = double(Iapp);
if i < 10000
    Isyn_EE = zeros(params.quantity_neurons_E,1);
    Isyn_EI = zeros(params.quantity_neurons_E,1);
end

fired = find(V_E >= params.neuron_fired_thr);
V_E(fired) = params.c;
U_E(fired) = U_E(fired) + params.d;
I_sum = Iapp + Isyn_EE + Isyn_EI;
V_E = V_E + params.step .* 1000 .* (0.04 .* V_E .^ 2 + 5 .* V_E + 140 + I_sum - U_E);
U_E = U_E + params.step .* 1000 .* params.aa .* (params.b .* V_E - U_E);
V_E = min(V_E, params.neuron_fired_thr);

fired = find(V_I >= params.neuron_fired_thr);
V_I(fired) = params.c;
U_I(fired) = U_I(fired) + params.d;
V_I = V_I + params.step .* 1000 .* (0.04 .* V_I .^ 2 + 5 .* V_I + 140 +  Isyn_IE - U_I);
U_I = U_I + params.step .* 1000 .* params.aa .* (params.b .* V_I - U_I);
V_I = min(V_I, params.neuron_fired_thr);

mask_E = zeros(params.quantity_neurons_E, 1);
mask_E(V_E > 25) = 1;
mask_E1 = zeros(params.quantity_neurons_E, 1);
mask_E1(V_E > 29) = 1;
mask_I = zeros(params.quantity_neurons_I, 1);
mask_I(V_I > 25) = 1;

A = any(t_Iapp(:, 1) == i);
if A > 0
    V_E(:,1) = params.V_0;
    U_E(:,1) = params.U_0;
    V_I(:,1) = params.V_0;
    U_I(:,1) = params.U_0;
    if is_pre_training
        is_active = zeros(params.quantity_neurons_E, 1);
    end
end

Isyn_EE = zeros(params.quantity_neurons_E, 1);
Isyn_EI = zeros(params.quantity_neurons_E, 1);
Isyn_IE = zeros(params.quantity_neurons_I, 1);

S_E = 1 ./ (1 + exp(( - V_E ./ params.ksyn)));
S_I = 1 ./ (1 + exp(( - V_I ./ params.ksyn)));

if is_pre_training
    delta_gsyn_EE = params.delta_gsynEE .* mask_E(Post_EE) .* mask_E(Pre_EE);
    W_EE = W_EE + delta_gsyn_EE;
    W_EE = min(W_EE, params.max_gsynEE);
    Isync_EE = W_EE .* S_E(Pre_EE) .* ( - V_E(Post_EE));
else
    W_EE_1 = W_EE .*(1 + Iastro_neuron(Post_EE,1).* params.aep);
    Isync_EE = W_EE_1 .* S_E(Pre_EE) .* ( - V_E(Post_EE));
end
for q = 1 : params.quantity_connections_EE
    Isyn_EE(Post_EE(q)) = Isyn_EE(Post_EE(q)) + Isync_EE(q);
end

if is_pre_training
    is_active = (1 - params.step * params.beta) .* is_active;
    is_active = min(1, is_active + 0.5) .* mask_E + is_active .* ~mask_E;
    F = zeros(params.quantity_neurons_E, 1);
    F(is_active < 0.3) = 1;
    
    delta_gsyn_EI = params.delta_gsynEI .* F(Post_EI) .* mask_I(Pre_EI);
    W_EI = W_EI + delta_gsyn_EI;
    W_EI = min(W_EI, params.max_gsynEI);
end

Isync_EI = W_EI .* S_I(Pre_EI) .* (params.Esyn_ - V_E(Post_EI));
for q = 1 : params.quantity_connections_EI
    Isyn_EI(Post_EI(q)) = Isyn_EI(Post_EI(q)) + Isync_EI(q);
end

Isync_IE = params.W_IE .* S_E(Pre_IE) .* (- V_I(Post_IE));
for q = 1 : params.quantity_connections_IE
    Isyn_IE(Post_IE(q)) = Isyn_IE(Post_IE(q)) + Isync_IE(q);
end

Isyn_EE(Isyn_EE < 0) = 0;

if ~is_pre_training
    %% Glutamate (neurotransmitter model)
    del = zeros(params.quantity_neurons_E,1);
    del(V_E >= params.neuron_fired_thr) = 1;
    G = G - params.step .* (params.alf .* G - params.k  .* del);
end

end