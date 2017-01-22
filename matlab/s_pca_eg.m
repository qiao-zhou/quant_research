%% 
X = [-0.066 -0.124 0.259 0.289 -0.318 -0.015 -0.060 0.140 0.203 0.249 -0.229 0.174 0.149 -0.343 -0.308;
     -0.204 -0.079 0.565 0.607 -0.425 -0.135 0.011 0.411 0.350 0.535 -0.668 0.128 0.317 -0.543 -0.870];
 
scatter(X(1,:), X(2,:))

%% SVD Approach 
% [U,S,V] = svd(X*X');
% U*S*V'%should be equal to X
% U'*X*V%should be equal to S, the diagnoal matrix of singular values 
clc

[U,S,V] = svd(X);

k = 1;
Z = U(:,1:k);
score = Z'*X;
Xhat= Z*score;

m = size(X,2);
error_vec = (X-Xhat)';
total_error_squared = sum(error_vec(:,1).^2 + error_vec(:,2).^2);
e = 1/m * sqrt(total_error_squared);

avg_squared_projection_error = 1/m * sum(error_vec(:,1).^2 + error_vec(:,2).^2);
total_var = 1/m * sum(X(1,:).^2 + X(2,:).^2);
avg_squared_projection_error/total_var*100;


fprintf('PCs (Eigenvectors) in order of descending eigenvalues:\n')
disp(U)
fprintf('Corresponding eigenvalues:\n')
disp(S(1:2,1:2))
%% EIG Approach 

A=X*X';
[V,D] = eig(A);%Eigenvalues and eigenvectors
[tmp, I] = sort(diag(D),'descend');
L=diag(tmp);%sort eigenvalues in descending order
Q=V(:,I);%sort eigenvectors in descending order 
% A = Q*L*Q'; spectral theorem

fprintf('PCs (Eigenvectors) in order of descending eigenvalues:\n')
disp(Q)
fprintf('Corresponding eigenvalues:\n')
disp(sqrt(L))

k=1;
Z=Q(:,1:k);%retain only 1 principal component 
score = Z'*X;%the representation of X in the principal component space
Xhat = Z*score; %approximation of X using only 1 PC
error_vec = (X-Xhat)';%the vector of errors 
total_error_squared = sum(error_vec(:,1).^2 + error_vec(:,2).^2);
m = size(X,2);
e = 1/m * sqrt(total_error_squared);

%compute percentage of variance retained 
avg_squared_projection_error = 1/m * sum(error_vec(:,1).^2 + error_vec(:,2).^2);
total_var = 1/m * sum(X(1,:).^2 + X(2,:).^2);
prct_var_retained = (1-avg_squared_projection_error/total_var)*100;
100-prct_var_retained
%%
[coeff, score, latent, tsquare] = pca(X');
 coeff(:,1) * score(:,1)'
 
 fprintf('PCs (Eigenvectors) in order of descending eigenvalues (built-in function: pca):\n')
disp(coeff)
fprintf('Corresponding eigenvalues:\n')
disp(sqrt(L))
