function [  ] = feedforwardnn( )
%feedforwardnn feed 
%   �˴���ʾ��ϸ˵��
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
    
    ITE_NUM = 80 ;
    
    % ѧϰ��Сһ���ƺ������ȶ���������Ҫȡ1������
    OUTPUT_ALPHA = 0.01 ;
    HIDDEN_ALPHA = 0.01 ;
    
    hidden_w = rand(HIDDEN_NODE_NUM,INPUT_NODE_NUM) ; % every row is a vector for a hidden node ; every col is corresponding to a input .
    hidden_b = rand(HIDDEN_NODE_NUM,1) ; % every row is the bias of a hidden node
    hidden_w_gradient = zeros(HIDDEN_NODE_NUM , INPUT_NODE_NUM) ;
    hidden_b_gradient = zeros(HIDDEN_NODE_NUM , 1) ;
    
    output_w = rand(OUTPUT_NODE_NUM , HIDDEN_NODE_NUM) ;
    output_b = rand(OUTPUT_NODE_NUM , 1) ;
    output_w_gradient = zeros(OUTPUT_NODE_NUM , HIDDEN_NODE_NUM) ;
    output_b_gradient = zeros(OUTPUT_NODE_NUM , 1) ;
    
    [ training_x , training_y , testing_x ,  testing_y ] = generate_data(false) ;
    
    TRAINING_SIZE = size(training_x , 1) ; % get row of trainning_x , which is the nums of trainning data
    TESTING_SIZE = size(testing_x , 1) ;
    
    BATCH_SIZE = 10 ;
    
    
    for ite = 1 : ITE_NUM 
        randidx = randperm(TRAINING_SIZE) ;
        for instance_ite_idx = 1 : TRAINING_SIZE 
         instance_idx = randidx(instance_ite_idx) ;
         instance_x = training_x(instance_idx,:)' ;
         instance_y = OUTPUT_LABEL2ID(training_y(instance_idx)) ;
         
         %% feed forward
         hidden_layer_out = sigmoid(hidden_w * instance_x + hidden_b) ;
         output_layer_out = softmax(output_w * hidden_layer_out + output_b) ;
         
         %% back propagation
         
         %% MSE
         %true_output = zeros(OUTPUT_NODE_NUM , 1) ;
         %true_output(instance_y) = 1 ;
         %output_layer_delta = 2 * ( output_layer_out - true_output) .* output_layer_out .* ( 1 - output_layer_out) ;
         
         %% NLL
         diff_value = zeros(OUTPUT_NODE_NUM , 1) ;
         diff_value(instance_y) = 1 ;
         output_layer_delta = output_layer_out - diff_value ;

         
         hidden_layer_delta = (output_layer_delta' * output_w )' .* hidden_layer_out .* (1 - hidden_layer_out) ;
         
         % ����������򣬾��ֳ�Ϊ25% �ˣ���
         output_w_gradient = output_w_gradient + repmat(output_layer_delta , 1 , HIDDEN_NODE_NUM) .* repmat(hidden_layer_out' , OUTPUT_NODE_NUM , 1)  ;
         hidden_w_gradient = hidden_w_gradient + repmat(hidden_layer_delta , 1 , INPUT_NODE_NUM) .* repmat(instance_x' , HIDDEN_NODE_NUM , 1)  ;
         
         output_b_gradient = output_b_gradient + output_layer_delta ;
         hidden_b_gradient = hidden_b_gradient + hidden_layer_delta ;
         
         % if batch finished , or went to the last , then UPDATE
         if mod(instance_ite_idx , BATCH_SIZE) == 0 || instance_ite_idx == TRAINING_SIZE 
            output_w = output_w - OUTPUT_ALPHA * output_w_gradient ;
            hidden_w = hidden_w - HIDDEN_ALPHA * hidden_w_gradient ;
            
            output_b = output_b - OUTPUT_ALPHA * output_b_gradient ;
            hidden_b = hidden_b - HIDDEN_ALPHA * hidden_b_gradient ;
            % clear gradient
            output_w_gradient = zeros(OUTPUT_NODE_NUM , HIDDEN_NODE_NUM) ;
            hidden_w_gradient = zeros(HIDDEN_NODE_NUM , INPUT_NODE_NUM) ;
            
            output_b_gradient = zeros(OUTPUT_NODE_NUM , 1) ;
            hidden_b_gradient = zeros(HIDDEN_NODE_NUM , 1) ;
         end
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
