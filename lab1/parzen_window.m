function [] = parzen_window()
% do parzen window using window function 
% 3 samples 

axis_x = -5:0.1:5 ;
axis_x = axis_x' ; % row array to col vector

sample_nums = [50 , 400 ,  1000 , 10000 ] ;
sample_nums_length = length(sample_nums) ;

h0s = [0.1 , 1 , 10] ;
h0s_length = length(h0s) ;

for i = 1:h0s_length 
    h0 = h0s(i) ;
    for j = 1:sample_nums_length
        sample_num = sample_nums(j) ;
        instance_x = randn(sample_num , 1) ;
        [ axis_y , h ] = calc_pd_by_parzen(axis_x , instance_x , h0) ;
        subplot(h0s_length , sample_nums_length , (i -1) * sample_nums_length + j) ;
        draw_2d_pdf(axis_x , axis_y , sample_num , h0 , h ) ;
    end
end
end