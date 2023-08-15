%ECU Tucker-3 toolbox (requires chemom toolbox)
%
% tuckals3   - compute Tucker3 model of layer-unfolded 3-way array.
% tuckals3b  - Tucker3 model of layer-unfolded 3-way array w/ initial estimates
%
% hosvd     - Higher-order SVD - from thesis of Ridvanz
% support functions for HOSVD
%
% contract.m             inproduct.m            outproduct.m            
% kproduct.m             tcontract.m            unfold.m               
% hosvd.m                ndmult.m               ttsvd.m
%
% CORE      - calc core matrix c, from the eigenvectors g(I*i), h(J*j), and e(K*k).
% DISP_F    - display a matrix in folded row storage format
% JOINT     - produce Kronenberg's joint vectors. 
% ROT_TUCK  - Varimax rotation for three-mode factor analysis.
% SUPER_EYE - generate a kxkxk superdiagonal core matrix for PARAFAC solutions.
%
% ROT_COLS  - rotate col basis vectors, h, of a tucker 3-way model.
% ROT_LYRS  - rotate layer basis vectors, e, of a tucker 3-way model.
% ROT_ROWS  - rotate row basis vectors, g, of a tucker 3-way model.
%
% STACK     - unfold a Matlab 5.2 multidim array.
%
% F_COL     - fold columns in the 3-mode array, a.  
% F_LAYER   - fold layers in the 3-mode array, a.  
% UF_COL    - unfold the layers in the 3-mode array.
% UF_LAYER  - unfold the layers in the 3-mode array.
%
% f_tensor  - fold tuckals 2d storage format into a matlab 3-way array
% uf_tensor - unfold a matlab 3-way array to tuckals 2d format


