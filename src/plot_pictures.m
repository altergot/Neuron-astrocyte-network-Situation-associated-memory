function [Iapp,Freq] = plot_pictures(model)
params = model_parameters();

%% Combining tests into a single picture
line_width = 2; % width of the line separating the patterns
Iapp = zeros((params.mneuro_E + line_width) * params.N_cycles, (params.nneuro_E + line_width) * ...
    params.N_patterns_1_cycle, 'int8');
Freq = zeros((params.mneuro_E + line_width) * params.N_cycles, (params.nneuro_E + line_width) * ...
    params.N_patterns_1_cycle, 'logical');
pattern_number = 1;
for i = 1 : params.N_cycles
    m = (i - 1) * (params.mneuro_E + line_width) + 1;
    for j = 1 : params.N_patterns_1_cycle
        n = (j - 1) * (params.nneuro_E + line_width) + 1;
        Iapp(m : m + params.nneuro_E - 1, n : n + params.nneuro_E - 1) = ...
            model.Iapp_test(:,:,pattern_number);
        Iapp(m : m + params.nneuro_E + line_width - 1,...
            n + params.nneuro_E : n + params.nneuro_E + line_width - 1) = params.Iapp_test;
        Iapp(m + params.mneuro_E : m + params.mneuro_E + line_width - 1,...
            n : n + params.nneuro_E + line_width - 1) = params.Iapp_test;
        Freq(m : m + params.nneuro_E - 1, n:n+params.nneuro_E - 1) = ...
            model.Images_Accuracy(:,:,pattern_number);
        Freq(m : m + params.nneuro_E + line_width - 1,...
            n + params.nneuro_E : n + params.nneuro_E + line_width - 1) = 1;
        Freq(m + params.mneuro_E : m + params.mneuro_E + line_width - 1,...
            n : n + params.nneuro_E + line_width - 1) = 1;
        pattern_number = pattern_number + 1;
    end
end

%% Plot picture
fh1 = figure(1);
%set(gcf, 'color', 'none');
fh1.WindowState = 'maximized';
colormap(gray(5));
subplot(1,2,1)
imagesc(Iapp);
axis off;
set(gca,'FontSize',20,'fontWeight','bold');
title('Cues');
subplot(1,2,2)
imagesc(Freq);
axis off;
set(gca,'FontSize',20,'fontWeight','bold');
title('Neurons');
end