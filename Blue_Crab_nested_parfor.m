%% TUSCA running
load Blue_Crab_nested_parfor
tic
[G_opt,A_opt,G_bs,A_bs,complete_table,significantModel_table,XS,tracea,Xr,Res_opt] = TUSCA_parfor(x3do, Dm, R, opt);
toc
%%
tic
[AA_bs, GG_bs, A_rem, G_rem, AA_opt, GG_opt, t, ~] = sort_bs_loadings(A_opt, G_opt, A_bs, G_bs,tracea,1:3,[0.05 0.05 0.001]);
toc

%%
t = sortrows(t,'SSQ','descend');

Tred = uf_tensor(XS);  % Initialize the model
nfactors = numel(GG_opt);
p_values = zeros(nfactors,3); 
pT_values = zeros(nfactors,3); 
AA_opt = AA_opt';

for i = 1:nfactors

    % calc the triad to be removed

        T = core(GG_opt(t.i(i), t.j(i), t.k(i)) ...
            ,AA_opt{1,1}(:,t.i(i))'...
            ,AA_opt{1,2}(:,t.j(i))'...
            ,AA_opt{1,3}(:,t.k(i))');

        Tred = Tred - T;        % substract current triad from the model
    
    % test the reduced model for ASCA struture

    [tablered,structred] = parglm(Tred,Dm, [1 2], [], [], [], [], [], [], [1 3]);
    p_values(i,:) = structred.p([1 2 4]);


    [tableT,structT] = parglm(T+Res_opt,Dm, [1 2], [], [], [], [], [], [], [1 3]);
    pT_values(i,:) = structT.p([1 2 4]);

end

t.Ared_p = p_values(:,1);
t.Bred_p = p_values(:,2);
t.ABred_p = p_values(:,3);

t.At_p = pT_values(:,1);
t.Bt_p = pT_values(:,2);
t.ABt_p = pT_values(:,3);

save temp1