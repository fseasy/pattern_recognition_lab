function [ ] = draw_2d_pdf( axis_x , axis_y , sample_num ,window_init_edge , window_edge )
% pilot the 2-dimension iamge
% x = axis_x , y = axis_y , with display sample's number and window's edge
% length
    plot(axis_x , axis_y ) ;
    xlabel('x') ;
    ylabel('p(x)') ;
    title(sprintf('Parzen´°(N=%d h_0=%.2f h_n=%.2f)' , sample_num ,window_init_edge , window_edge)) ;
end

