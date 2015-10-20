function [ px , h ] = calc_pd_by_parzen( x , sample_x , h0  )
% calc probability using parzen window
%   此处显示详细说明
    [ n , d ]  = size(sample_x) ;
    if n == 0 || d == 0 
        px = [] ;
        return
    end
    h = h0 / sqrt(n) ;
    [nr_input_points , d_input] = size(x) ;
    if d_input ~= d 
        fprintf('input dimention is %d , while sample x dimension is %d' , d_input , d) ;
        px = [] ;
        return ;
    end
    px = zeros(nr_input_points , 1) ; 
    for i = 1:nr_input_points
        sigma_value = sigma( (x(i) - sample_x) / h ) ;
        px(i) = sum( sigma_value ) / ( pow2(h ,d ) * n ) ;
    end
end

function [ ret ] = sigma(u)
% sigma function
    [n , d ]= size(u) ;
    ret = ones(n,1) ;
    for i = 1:n 
        for j = 1:d 
            if abs(u(i,j)) > 0.5 
                ret(i)=0 ;
                break
            end
        end
    end
end

