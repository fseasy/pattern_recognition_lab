function [  ] = feedforwardnn( )
%feedforwardnn feed 
%   此处显示详细说明
    % define class label
    CLASS_1 = 1 ;
    CLASS_2 = 2 ;
    CLASS_3 = 3 ;
    CLASS_4 = 4 ;
    
    OUTPUT_ID2LABEL = [CLASS_1 , CLASS_2 , CLASS_3 , CLASS_4] ;
    OUTPUT_LABEL2ID = containers.Map({CLASS_1 , CLASS_2 , CLASS_3 , CLASS_4} , {1,2,3,4}) ;
    
    
    HIDDEN_NODE_NUM = 4 ;
    OUTPUT_NODE_NUM = 4 ;
    INPUT_NODE_NUM = 3 ;
    
    ITE_NUM = 40 ;
    
    % 学习率小一点似乎更加稳定，反正不要取1就是了
    OUTPUT_ALPHA = 0.01 ;
    HIDDEN_ALPHA = 0.01 ;
    
    hidden_w = rand(HIDDEN_NODE_NUM,INPUT_NODE_NUM) ; % every row is a vector for a hidden node ; every col is corresponding to a input .
    hidden_b = rand(HIDDEN_NODE_NUM,1) ; % every row is the bias of a hidden node
    
    
    output_w = rand(OUTPUT_NODE_NUM , HIDDEN_NODE_NUM) ;
    output_b = rand(OUTPUT_NODE_NUM , 1) ;
    
    [ training_x , training_y , testing_x ,  testing_y ] = generate_data(false) ;
    
    TRAINING_SIZE = size(training_x , 1) ; % get row of trainning_x , which is the nums of trainning data
    TESTING_SIZE = size(testing_x , 1) ;
    for ite = 1 : ITE_NUM 
        for training_idx = 1 : TRAINING_SIZE 
          
         instance_x = training_x(training_idx,:)' ;
         instance_y = OUTPUT_LABEL2ID(training_y(training_idx)) ;
         
         %% feed forward
         hidden_layer_out = sigmoid(hidden_w * instance_x + hidden_b) ;
         output_layer_out = softmax(output_w * hidden_layer_out + output_b) ;
         
         %% back propagation
         true_output = zeros(OUTPUT_NODE_NUM , 1) ;
         true_output(instance_y) = 1 ;
         
         %% MSE
         %%output_layer_delta = 2 * ( output_layer_out - true_output) .* output_layer_out .* ( 1 - output_layer_out) ;
         
         %% NLL - one possible pattern
         %%output_layer_delta = zeros(OUTPUT_NODE_NUM , 1) ;
         %%output_layer_delta(instance_y) = output_layer_out(instance_y) - 1 ;
         %% NLL - another possible pattern
         output_layer_delta = output_layer_out - true_output ;

         
         hidden_layer_delta = (output_layer_delta' * output_w )' .* hidden_layer_out .* (1 - hidden_layer_out) ;
         
         
         % 如果加入正则，就又成为25% 了！！
         
         output_w_gradient = repmat(output_layer_delta , 1 , HIDDEN_NODE_NUM) .* repmat(hidden_layer_out' , OUTPUT_NODE_NUM , 1)  ;
         
         hidden_w_gradient = repmat(hidden_layer_delta , 1 , INPUT_NODE_NUM) .* repmat(instance_x' , HIDDEN_NODE_NUM , 1)  ;
         
         output_w = output_w - OUTPUT_ALPHA * output_w_gradient ;
         hidden_w = hidden_w - HIDDEN_ALPHA * hidden_w_gradient ;

         %%
         
        end
        %% testing
        right_num = 0 ;
        predict_cnt = zeros(1,OUTPUT_NODE_NUM) ;
        for i = 1 : TESTING_SIZE
            testing_instance = testing_x(i,:)' ;
            test_hidden_out = sigmoid(hidden_w * testing_instance + hidden_b) ;
            test_output_out = softmax(output_w * test_hidden_out + output_b ) ;
            [ ~ , test_output_id ] = max(test_output_out) ;
            test_output_label = OUTPUT_ID2LABEL(test_output_id) ;
            predict_cnt(test_output_id) = predict_cnt(test_output_id) + 1 ;
            if(test_output_label == testing_y(i))
                right_num = right_num + 1 ;
            end
        end
        disp( [ 'Iterate ', num2str(ite) , ': right nums (' , num2str(right_num) ,') precesion ( ' , num2str(right_num / TESTING_SIZE * 100 ), ')  predict count in each class(' , num2str(predict_cnt),')']) ;
    end
    
   
end

function sigmoid_value = sigmoid(v)
    [m,n] = size(v) ;
    sigmoid_value = ones(m ,n) ;
    for i = 1 : m 
        for j = 1 : n 
            sigmoid_value(i,j) = 1 / (1 + exp(- v(i,j))) ;
        end
    end
    
end
