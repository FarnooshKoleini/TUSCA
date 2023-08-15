function [gr,hr,er,cr]=rot_tuck(g,h,e,c,tracea);
% ROT_TUCK -- Varimax rotation for three-mode factor analysis.
%
% [gr,hr,er,cr]=rot_tuck(g,h,e,c,tracea);

[I,s]=size(g);
[J,t]=size(h);
[K,u]=size(e);

disp('Rotating I-mode factors.');
[gr,simp,H2,gt,angle]=varimax(g);
[gr,cr]=rot_rows(g,c,gt,s,t,u);

disp('Rotating J-mode factors.');
[hr,simp,H2,ht,angle]=varimax(h);
[hr,cr]=rot_cols(h,cr,ht,s,t,u);

disp('Rotating K-mode factors.');
[er,simp,H2,et,angle]=varimax(e);
[er,cr]=rot_lyrs(e,cr,et,s,t,u);

% debug stuff
% sum(sum(cr.^2))
% sum(sum((core(c,g',h',e')-core(cr,gr',hr',er')).^2))

disp('Rotated core matrix:');
disp_f(cr,s,t,u);

disp('%Variance explained by IJK combinations of rotated factors:');
disp_f(cr.^2/tracea*100,s,t,u);

evlg=sum(uf_col(cr.^2,s,t,u)');
disp(sprintf('%%Variance preserved in I-mode factors (sum=%g):',sum(evlg/tracea*100)));
disp(evlg/tracea*100);

evlh=sum(cr.^2);
disp(sprintf('%%Variance preserved in J-mode factors (sum=%g):',sum(evlh/tracea*100)));
disp(evlh/tracea*100);

evle=sum(uf_layer(cr.^2,s,t,u)');
disp(sprintf('%%Variance preserved in K-mode factors (sum=%g):',sum(evle/tracea*100)));
disp(evle/tracea*100);

% display loadings and scores.

disp('Rotated I-mode loadings.');
disp([(1:I)' gr]);
disp('Rotated scaled, squared I-mode loadings.');
disp([(1:I)' (gr*sqrt(diag(evlg))).^2]);

disp('Rotated J-mode loadings.');
disp([(1:J)' hr]);
disp('Rotated, scaled, squared J-mode loadings.');
disp([(1:J)' (hr*sqrt(diag(evlh))).^2]);
 
disp('Rotated K-mode loadings.');
disp([(1:K)' er]);
disp('Rotated, scaled, squared K-mode loadings.');
disp([(1:K)' (er*sqrt(diag(evle))).^2]);
