function [G_opt,A_opt,G_bs,A_bs,complete_table,significantModel_table,XS,tracea] = TUSCA(X, Dm, R, opt)
% TUSCA -- TuckerHOSVD + ASCA analysis on the TuckerHOSVDresiduals + Bootstrapping
%
% [G_opt,A_opt,G_bs,A_bs,complete_table,significantModel_table] = TUSCA(X, Dm, R, opt)
%
% INPUTS:
%
% X = original data matrix
% Dm = design matrix
% scale_opt = scaling options from tucker3 original code
% G, H and E specify the number of factors to be retained in modes I, J, and K respectively

% OPTIONAL INPUTS:
%
% Preprocessing: 1-9 preprocessing structure for X block (see scaling options)
% L = 3 (for 3 way arrays)
% npermutations : [{0}] Number of permutations to use when applying
% permutation test to reach main factor to get P-value using Null
% hypothesis that the factor has no effect on the experimental outcome.
%
% OUTPUTS:
%
% Xmodel
% Xresid
% g_orig, h_orig, e_orig, and c_orig

% Modeling options
if nargin < 4
    opt.preproc = 1;   % isfield returns a logic val
    opt.npermutations = 10000;
    opt.interactions = {1 2 [1  2]}; % Look at Factor 1, Factor 2, and their interactions   %FK- should we delete this?
    opt.display = 'off'; % No output display (no option to turn off the waitbar though)
    opt.waitbar = 'off';
    opt.error = 1e-7; % hooib convergence tolerance
    opt.maxiter = 100; % hooib max iteration
    opt.optModel = 0; % optimal model for g, h, e (can be specified as e.g., [3 7 3]). If set to 0, optimal model will be calculated
    opt.alpha = 0.05; % significance level for p-values
%     opt.refold = [size(X,1)/3 size(X,2) 3]; % user should provide this!
    opt.bootstrap = 1; % Default option for the bootstrapping is 1
    opt.double = 1; % Default is double precision
    opt.als = 0; % Default is hooib (svd).  If als = 1, then tuckerals
    opt.nested = 0; % Default is crossed. If nested = 1, then nested parglm

elseif nargin < 3
    error('TUSCA - not enough input parameters.')
end

if numel(size(X)) < 3
    error('Data must be provided as 3d array')
end     
   
if isfield(opt, 'preproc') == 0
    opt.preproc = 1;
end

if isfield(opt, 'npermutations') == 0
    opt.npermutations = 10000;
end

if isfield(opt, 'interactions') == 0
    opt.interactions = {1 2 [1 2]};    % FK- should we delete this from the option? Just modify that. We'll do that for general code.
end

if isfield(opt, 'display') == 0
    opt.display = 'off';
end

if isfield(opt, 'waitbar') == 0
    opt.waitbar = 'off';
end

if isfield(opt, 'error') == 0
    opt.error = 1e-7;
end

if isfield(opt, 'maxiter') == 0
    opt.maxiter = 100;
end

if isfield(opt, 'optModel') == 0
    opt.optModel = 0;
end

if isfield(opt, 'alpha') == 0
    opt.alpha = 0.05;
end

if isfield(opt, 'refold') == 0
    if ndims(X) == 3
        opt.refold = size(X);
    else
%        opt.refold = [size(X,1)/3 size(X,2) 3]; % user needs to provide this
         error('TUSCA - op.refold must be defined.')
    end
end

if isfield(opt, 'bootstrap') == 0
    opt.bootstrap = 1;
end

if isfield(opt, 'double') == 0
    opt.double = 1;
end

if isfield(opt, 'nested') == 0    %FK- nested design option 
    opt.nested = 0;
end

%
% Recast the problem in single precision.
% 
if opt.double ~= 1
    X = single(X);
    R = single(R);
    fprintf('\n X ')
end

if ~ismatrix(X) 
    X = uf_tensor(X); 
end

[XS] = preproc_func(X,opt.preproc,opt.refold(1),opt.refold(2),opt.refold(3));
tracea = sum(XS(:).^2);
%clear X

% Refold if the data is provided as a 2-way array
if ismatrix(XS)
    XS = f_tensor(XS,opt.refold(1),opt.refold(2),opt.refold(3));
end

% Get initial est of A with HOSVD
[~, A, ~] = hosvd(XS,R);

% HOOIB Tucker decompositions
% nLayers = 3;
% [G, A, error1, Xr, iter] = hooib(XS, R, A, opt.error, opt.maxiter);
% [~,~,~,~,evlg,Xmodel,Xresid] = tuck_HOSVD(XS, R);

%% ASCA analysis on the residual and finding the best number of factors for each mode, I, J, and K
% This part should only be calculated if no optimal model is specified in
% the options
if numel(opt.optModel) == 1 && opt.optModel == 0

    %L = optionsT.nLayers;  % Number of layers in dataset
    numbG = (1:R(1)); % 1 to G factors for g, can be changed based on the data structure
    numbH = (1:R(2)); % 1 to H factors for h, can be changed based on the data structure
    numbE = (1:R(3)); % 1 to E factors for e, can be changed based on the data structure

    % ASCA options for the PLS toolbox


    % Pre-allocate for speed reasons
    completeCell = cell(numel(numbG)*numel(numbH)*numel(numbE),size(opt.interactions,2)+2);
    rowNames = cell(numel(numbG)*numel(numbH)*numel(numbE),1);
    R_asca = zeros(numel(numbG)*numel(numbH)*numel(numbE),3);

    rowNumber = 0;
    if opt.waitbar ~= 0
        wb = waitbar(rowNumber/(numel(numbG)*numel(numbH)*numel(numbE)),'Exploring the number of components needed for the Tucker-3 analysis...'); % Show a waitbar so you can follow progress
    end
    % Loop over all possible number of factors for g
    for i = 1:numel(numbG)
        % Loop over all possible number of factors for h
        for j = 1:numel(numbH)
            % Loop over all possible number of factors for e
            for k = 1:numel(numbE)

                % Increase the rowNumber to keep track where to store it in the
                % table
                rowNumber = rowNumber + 1;

                if opt.waitbar ~= 0
                    waitbar(rowNumber/opt.npermutations,wb,'Exploring the number of components needed for the Tucker-3 analysis...'); % Update the waitbar to follow progress
                end

                % Perform the Tucker-3 analysis for a given number of
                % components, and store the reconstructed data and
                % residuals in a cell.
                %[~,~,~,~,~,~,~,Res_calc]=tuck_HOSVD(X,opt.preproc,numbG(i),numbH(j),numbE(k),opt.nLayers);

                % Extract the number of components for the current model
                R_asca(rowNumber,:) = [i,j,k];
                totalComponents = i*j*k;

                % logical constraint for tucker3 model
                if ~any(R_asca(rowNumber,:)==1) && (i*j >= k && i*k >= j && j*k >= i)
                    [~, ~, ~, Xr, ~] = hooib(XS, R_asca(rowNumber,:), A, opt);
                    Res_calc = uf_tensor(XS - Xr);
                    varExplained = sum(Xr(:).^2)/tracea*100;
                    if opt.nested == 1                                              
                        [~,st_nested] = parglm(Res_calc,Dm, [1 2], [], [], [], [], [], [], [1 3]);  % FK- parglm for nested design- make it general for number of factors [1 3] and [1 2]
                        p_values = st_nested.p([1 2 4]);
                    else     
                        [~,st_crossed] = parglm(Res_calc,Dm, {[1 2]});   % FK- parglm for crossed design- two factors + Interaction
                        p_values = st_crossed.p([1 2 4]);
                    end 

%     FK- no need ascaPJG               model = ascaPJG(dataset(Res_calc),dataset(Dm),2,opt); % PJG 01/26/2023 added required input arg nfac = 2 PCs used by asca
%     FK- pvalues  from parglm needed            p_values = model.detail.pvalues;
                else
                    p_values = ones(1,length(opt.interactions))*(-1);
                    varExplained = 0;
                end

                % this should be in an array, and then trasfered to a table at
                % the end of the function
                rowNames{rowNumber} = ['{' num2str(R_asca(rowNumber,1)) ', ' num2str(R_asca(rowNumber,2)) ', ' num2str(R_asca(rowNumber,3)) '}'];
                completeCell(rowNumber,:) = num2cell([p_values varExplained totalComponents]);

            end
        end
    end

    % Convert the completeCell variable to a table structure.
    % Also make the variable names and row names of the complete table
    complete_table = cell2table(completeCell);
    for i = 1:size(opt.interactions,2)
        complete_table.Properties.VariableNames{i} = char(cell2mat(opt.interactions(i))+'A'-1);
    end
    complete_table.Properties.VariableNames{i+1} = 'Explained Variance';
    complete_table.Properties.VariableNames{end} = 'Total Number of Components';
    complete_table.Properties.RowNames = rowNames;

    if opt.waitbar ~= 0
        close(wb); % Close the waitbar
    end
else
    % Return an empty table to avoid errors in the output
    complete_table = [];
end
% Clean up the workspace
clear i j k numbG numbH numbE p_values rowNumber varExplained totalComponents R model wb

%% Finding the optimum rank (only if no optModel is specified in the options)
if numel(opt.optModel) == 1 && opt.optModel == 0
    % First, we will check if p-values are significant or not for all factors
    p_valueCheck = sum(cellfun(@(x) x>=opt.alpha,completeCell(:,1:end-2)),2) == size(opt.interactions,2);
    p_valueCheck_idx = find(p_valueCheck);

    % Extract the model components for the ones that have all factors
    % significant, and find the total number of components for these models
    if ~isempty(p_valueCheck_idx)
        significantModels = R_asca(p_valueCheck,:);
        significantModel_table = complete_table(p_valueCheck,:);
        totalComponents = table2array(complete_table(p_valueCheck,end));

        % The optimal model will be the one with the minimum number of components
        % of the significant models.
        % If there is a tie, then it takes the model with the maximum
        % variance.
        minTotal = min(totalComponents);
        MinModels = find(totalComponents == minTotal);
        if numel(MinModels) > 1
            Variances = table2array(significantModel_table(MinModels,4));
            [~, maxIdx] = max(Variances);
            minIdx = MinModels(maxIdx);
        else
            minIdx = MinModels;
        end
        optModel = rowNames{p_valueCheck_idx(minIdx)};

        g_opt = significantModels(minIdx,1);
        h_opt = significantModels(minIdx,2);
        e_opt = significantModels(minIdx,3);

        disp(['The optimal model is: ' optModel ' (total of ' num2str(minTotal) ' components; explained variance: ' num2str(completeCell{p_valueCheck_idx(minIdx),4}) '%)']);
    else

        % If no optimal model is found, display this. Also assign the
        % 'optimal' components to be 0 and return an empty 'significant
        % model table' for output of this function
        disp('There is no optimal model where p-values for all factors (and interactions) are valid.');

        g_opt = 0;
        h_opt = 0;
        e_opt = 0;

        % Return an empty table to avoid errors in the output
        significantModel_table = [];
    end
else
    % Use the pre-specified number of components as optimal model
    g_opt = opt.optModel(1);
    h_opt = opt.optModel(2);
    e_opt = opt.optModel(3);

    % Return an empty table to avoid errors in the output
    significantModel_table = [];
end
% Clear up the workspace
clear minIdx minTotal optModel completeCell p_valueCheck p_valueCheck_idx R_asca rowNames significantModels totalComponents MinModels wb

%% Bootstrapp analysis after finding the best number of factors for each mode I, J, and K
% Combine the optimal number of components to make it conform to the hooib
% code.
R_opt = [g_opt h_opt e_opt];

if opt.bootstrap == 1 && ~any(R_opt==0)

    % Run the Tucker model and calculate the residuals
    [G_opt,A_opt, ~, Xr, ~] = hooib(XS, R_opt, A, opt);
    Res_opt = uf_tensor(XS - Xr);
    
    % Pre-allocate for speed reasons
    G_bs = cell(1,opt.npermutations);
    A_bs = cell(opt.refold(3),opt.npermutations);
    
    % Perform the actual bootstrapping here
    if opt.waitbar ~= 0
        wb = waitbar(0,'Performing bootstrap analysis...'); % Show a waitbar so you can follow progress
    end

    for i = 1:opt.npermutations
        if opt.waitbar ~= 0
            waitbar(i/opt.npermutations,wb,'Performing bootstrap analysis...'); % Update the waitbar to follow progress
        end
    
        perm = randperm(size(Res_opt,1)); % Obtain the row IDs to randomly shuffle the residuals (obtained from the initial Tucker-3 model)
        Res_Shuffled = Res_opt(perm,:); % Shuffle the residuals
        ReconData_Shuffled = f_tensor(uf_tensor(Xr) + Res_Shuffled,opt.refold(1),opt.refold(2),opt.refold(3)); % Add the shuffled residuals to the reconstructed data (obtained from the initial Tucker-3 model).
    
        % Perform the Tucker-3 analysis on the bootstrapped data
        % We save all the output matrices for each of the permutations so we
        % can calculate confidence intervals on each of them.
        [G_bs{i},A_bs(:,i),~,~,iter] = hooib(ReconData_Shuffled, R_opt, A_opt, opt);
%        disp(iter)
    end
    if opt.waitbar ~= 0
        close(wb); % Close the waitbar
    end
else
    disp('There was no optimal model specified or no optimal model found in the provided search space')

    % Return empty output matrices to avoid errors in the output
    G_opt = [];
    A_opt = [];
    G_bs = [];
    A_bs = [];
end

% Clear the workspace
clear R_opt Xr Res_opt wb perm Res_Shuffled ReconData_Shuffled

end