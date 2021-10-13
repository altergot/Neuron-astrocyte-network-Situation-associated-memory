function [neuron_astrozone_activity, neuron_astrozone_spikes] = ...
    get_neuron_astrozone_activity(G, Mask_line)
params = model_parameters();

mask1 = reshape(Mask_line, params.mneuro_E, params.nneuro_E);
mask1 = single(mask1);
glutamate_above_thr = reshape(G >= params.G_thr, params.mneuro_E, params.nneuro_E);
neuron_astrozone_activity = zeros(params.mastro, params.nastro, 'int8');
neuron_astrozone_spikes = zeros(params.mastro, params.nastro, 'int8');
sj = 0;
for j = 1 : params.az : (params.mneuro_E - params.az)
    sk = 0;
    for k = 1 : params.az : (params.nneuro_E - params.az)
        neuron_astrozone_activity(j - sj, k - sk) = ...
            sum(glutamate_above_thr(j : j + params.az, k : k + params.az), 'all');
        neuron_astrozone_spikes(j - sj, k - sk) = ...
            sum(mask1(j : j + params.az, k : k + params.az), 'all');
        sk = sk + 2;
    end
    sj = sj + 2;
end
end