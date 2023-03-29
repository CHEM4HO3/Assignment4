function [t, wstar, c, p, w, u,  R2_y, res_y] = nipalspls(x,y,A)

% mean center and scale x and y data
xs = (x - mean(x))./std(x); 
ys = (y - mean(y))./std(y); 
x = xs;
y = ys;

% keep initial x and y for R2 calculation
x0 = x;
y0 = y;

tol = 1e-6;

% preload loadings, scores, R2, and residuals
k = size(x,2);
n = size(x,1);
m = size(y,2);

w = zeros(k,A);
u = zeros(n,A); 
t = zeros(n,A);
c = zeros(m,A);
res_x = zeros(n,k,A); 
res_y = zeros(n,m,A);
R2_y = zeros(1, A);
p = zeros(k,A);

for a =1:A
    u(:,a) = x(:,1);
    
    delta_u = inf(size(u,1),1);
    while(any(delta_u>tol))
        
        w(:,a) = (u(:,a)'*x)/(u(:,a)'*u(:,a)); % calculate PLS deflated (X) loadings
     
        w(:,a) = w(:,a)./sqrt(w(:,a)'*w(:,a)); % normalize loadings
        
        t(:,a) = (x*w(:,a))/(w(:,a)'*w(:,a)); % calulate PLS X scores
        
        c(:,a) = (t(:,a)'*y)/(t(:,a)'*t(:,a)); % calculate PLS Y loadings
             
        uNew = (y*c(:,a))/(c(:,a)'*c(:,a)); % calculate PLS Y scores
        
        % update delta_u
        delta_u = uNew - u(:,a);
        u(:,a) = uNew;
    end

    p(:,a) = (t(:,a)'*x)/(t(:,a)'*t(:,a)); % calculate p loadings
    
%     p(:,a) = p(:,a)./sqrt(p(:,a)'*p(:,a)); % this step is NOT NEEDED
    
    % Get residuals and calculate R2
    x = x-t(:,a)*p(:,a)';
    y = y-t(:,a)*c(:,a)';
    
    
%     res_x(:,:,a) = x;
    res_y(:,:,a) = y;
    
    R2_y(a) = 1- nansum(nansum(y.*y))./nansum(nansum(y0.*y0));
%     R2_x(a) = 1- nansum(nansum(x.*x))./nansum(nansum(x0.*x0)); can output
%     R2_x if you want
end
wstar = w*(p'*w)^-1; % calculate wstar
end